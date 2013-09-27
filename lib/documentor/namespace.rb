module Documentor
  class Namespace
    attr_reader :name
    attr_reader :namespaces
    attr_reader :classes
    attr_reader :functions
    attr_reader :comment
    attr_reader :file

    def initialize(options = {})
      @name       = options[:name]       || ""
      @namespaces = options[:namespaces] || []
      @classes    = options[:classes]    || []
      @functions  = options[:functions]  || []
      @comment    = options[:comment]
      @file       = options[:file]
    end

    def safe_path_from_module_name(prefix)
      full_name = "#{prefix}#{@name}"
      full_name.gsub /\:\:/, "/"
    end
  end
end