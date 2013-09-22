require_relative 'class'
require_relative 'function'
require_relative 'namespace'
require_relative 'root'

module Documentor
  class Parser
    FLAGS = [
      "-xc++",                # Expect C++
      "-fparse-all-comments", # Parse every comment (not just doc ones)
      "-nobuiltininc",        # Do not include from builtins
      "-nostdinc++",          # Do not include system path for C++
      "-nostdinc"             # Do not include system path for C
    ]

    def initialize(file, basepath)
      index          = FFI::Clang::Index.new
      @basepath      = File.expand_path(basepath)
      @file          = File.expand_path(file)
      @relative_path = @file[@basepath.size+1..-1]
      @parser        = index.parse_translation_unit(file, FLAGS)
      @cursor        = @parser.cursor
    end

    def parse
      _curse @cursor
    end

    private

    def _curse(cursor)
      # We want to build up information about what is contained within this
      # scope. We are parsing a class, for instance, so we want to know what
      # functions it defines. At the end of this function, we will build a
      # class for that scope and define what children it has.
      namespaces = []
      classes    = []
      functions  = []

      # Rake the comments
      comment = nil
      if cursor.comment.kind != :comment_null
        comment = cursor.comment.child(0).text.gsub("\n", " ").strip
      end

      # TODO: Parse the comments for special things!

      # Get the name of this object (class name, namespace name, method name)
      name = cursor.spelling

      # Collect child information
      cursor.visit_children do |sub_cursor, parent|
        if parent == cursor
          case sub_cursor.kind
          when :cursor_namespace
            namespaces << _curse(sub_cursor)
          when :cursor_class_decl
            if sub_cursor.public?
              classes << _curse(sub_cursor)
            end
          when :cursor_cxx_method
            if sub_cursor.public?
              functions << _curse(sub_cursor)
            end
          end
        end
        :recurse
      end

      # Select the object type to add to our tree
      object = case cursor.kind
               when :cursor_translation_unit
                 Documentor::Root
               when :cursor_namespace
                 Documentor::Namespace
               when :cursor_class_decl
                 Documentor::Class
               when :cursor_cxx_method
                 Documentor::Function
               else
                 nil
               end

      # Create that object
      if object
        object.new(:name       => name,
                   :comment    => comment,
                   :namespaces => namespaces,
                   :classes    => classes,
                   :functions  => functions,
                   :file       => @relative_path)
      end
    end
  end
end
