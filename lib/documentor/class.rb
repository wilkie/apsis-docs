module Documentor
  class Class
    attr_reader :name
    attr_reader :namespaces
    attr_reader :classes
    attr_reader :functions
    attr_reader :comment
    attr_reader :file
    attr_reader :image

    def initialize(options = {})
      @name       = options[:name]       || ""
      @namespaces = options[:namespaces] || []
      @classes    = options[:classes]    || []
      @functions  = options[:functions]  || []
      @comment    = options[:comment]
      @file       = options[:file]
      @image      = options[:image]
    end

    def <=>(b)
      case b
      when Documentor::Class
        self.name <=> b.name
      else
        super(b)
      end
    end
  end
end
