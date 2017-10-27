class WechatBot
  class Schemes < Base
    class Offers

      # NOTE : this will be changed and we will inject user and action when we are done with the recursive thing
      def initialize
      end

      def request
        "i typed offers"
      end

      def response
        # whatever you want, could be empty
        binding.pry
      end

    end
  end
end
