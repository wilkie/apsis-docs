require_relative 'class'
require_relative 'function'
require_relative 'namespace'
require_relative 'parameter'
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

    def _curse(cursor, prefix = "")
      # We want to build up information about what is contained within this
      # scope. We are parsing a class, for instance, so we want to know what
      # functions it defines. At the end of this function, we will build a
      # class for that scope and define what children it has.
      namespaces = []
      classes    = []
      functions  = []
      parameters = []

      # Rake the comments
      comment = nil
      if cursor.comment.kind != :comment_null
        comment = cursor.comment.child(0).text.gsub("\n", " ").strip
      end

      # TODO: Parse the comments for special things!

      # Get the name of this object (class name, namespace name, method name)
      name = cursor.spelling

      new_prefix = prefix
      case cursor.kind
      when :cursor_namespace,
           :cursor_class_decl
        new_prefix = "#{prefix}#{name}::"
      end

      # Collect child information
      cursor.visit_children do |sub_cursor, parent|
        if parent == cursor
          case sub_cursor.kind
          when :cursor_namespace
            namespaces << _curse(sub_cursor, new_prefix)
          when :cursor_class_decl
            if sub_cursor.public?
              classes << _curse(sub_cursor, new_prefix)
            end
          when :cursor_cxx_method
            if sub_cursor.public?
              functions << _curse(sub_cursor, new_prefix)
            end
          end
        end
        :recurse
      end

      # Image path
      image = nil

      # Select the object type to add to our tree
      object = case cursor.kind
               when :cursor_translation_unit
                 Documentor::Root
               when :cursor_namespace
                 tmp_ns = Documentor::Namespace.new(:name => name)
                 img_path = "img/namespaces/#{tmp_ns.safe_path_from_module_name(prefix)}.svg"
                 if File.exists?(img_path)
                   image = img_path
                 end

                 Documentor::Namespace
               when :cursor_class_decl
                 img_path = "img/#{@relative_path.gsub(/#{Regexp.escape(File.extname(@relative_path))}$/, ".svg")}"
                 if File.exists?(img_path)
                   image = img_path
                 end

                 Documentor::Class
               when :cursor_cxx_method
                 # Retrieve arguments
                 parameters = cursor.arguments.map do |arg_cursor|
                   arg_comment = nil
                   if arg_cursor.comment.kind != :comment_null
                     arg_comment = arg_cursor.comment.child(0).text.gsub("\n", " ").strip
                   end
                   Documentor::Parameter.new(:name    => arg_cursor.spelling,
                                             :file    => @relative_path,
                                             :comment => arg_comment)
                 end

                 # Create a Function
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
                   :parameters => parameters,
                   :image      => image,
                   :file       => @relative_path)
      end
    end
  end
end
