module Response
 module Handler

    binding.pry
    def self.response_format(format)
      binding.pry
      @format = format
    end

    def response(format=:ruby)
      binding.pry
      Response::Format.new(@format || format)
    end

  end
end