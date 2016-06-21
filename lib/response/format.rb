module Response
  class Format

    attr_reader :scheme

    def initialize
      @scheme = Struct.new(:error?, :success?, :error)
    end

    def error(error)
      scheme.new(true, false, error)
    end

    def success
      scheme.new(false, true)
    end
    
  end
end