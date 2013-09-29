module Documentor
  class Root
    attr_reader :namespaces
    attr_reader :classes
    attr_reader :functions
    attr_reader :comment
    attr_reader :name
    attr_reader :file
    attr_reader :image

    def initialize(options = {})
      @namespaces = options[:namespaces] || []
      @classes    = options[:classes]    || []
      @functions  = options[:functions]  || []
      @image      = options[:image]
      @comment    = nil
      @file       = nil
      @name       = "{root}"
    end
  end
end
