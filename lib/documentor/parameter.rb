module Documentor
  class Parameter
    attr_reader :name
    attr_reader :type
    attr_reader :comment
    attr_reader :file

    def initialize(options = {})
      @name       = options[:name]       || ""
      @type       = options[:type]       || ""
      @comment    = options[:comment]
      @file       = options[:file]
    end
  end
end
