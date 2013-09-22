require_relative 'parser'

module Documentor
  class Collector
    attr_reader :root

    def initialize
      @root = Documentor::Root.new
    end

    def path(path, extension)
      Dir.glob("#{path}/**/*.#{extension}").each do |file|
        root = parse(file, path)
        add root
      end
    end

    def parse(filename, path)
      Documentor::Parser.new(filename, path).parse
    end

    def add(root, old_root = @root)
      namespaces = []
      classes    = root.classes
      functions  = root.functions

      file = old_root.file
      comment = old_root.comment

      if root.comment and root.comment != ""
        file = root.file
        comment = root.comment
      end

      root.namespaces.each do |namespace|
        existing = old_root.namespaces.select do |e|
          e.name == namespace.name
        end

        unless existing.empty?
          namespaces << add(namespace, existing.first)
        else
          namespaces << namespace
        end
      end

      old_root.namespaces.each do |namespace|
        existing = root.namespaces.select do |e|
          e.name == namespace.name
        end

        if existing.empty?
          namespaces << namespace
        end
      end

      classes.concat old_root.classes
      functions.concat old_root.functions

      ret = root.class.new(:namespaces => namespaces,
                           :classes    => classes,
                           :functions  => functions,
                           :name       => root.name,
                           :comment    => comment,
                           :file       => file)

      if old_root == @root
        @root = ret
      end

      ret
    end
  end
end
