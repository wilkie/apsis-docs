module Documentor
  class Function
    attr_reader :name
    attr_reader :returns
    attr_reader :parameters
    attr_reader :comment
    attr_reader :file

    def initialize(options = {})
      @name       = options[:name]       || ""
      @returns    = options[:returns]    || ""
      @parameters = options[:parameters] || []
      @comment    = options[:comment]
      @file       = options[:file]
    end

    def <=>(b)
      case b
      when Documentor::Function
        self.name <=> b.name
      else
        super(b)
      end
    end
  end
end
