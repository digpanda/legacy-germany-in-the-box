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
        puts "YEAH BOI HE TYPED OFFERS AND THINGS HAPPENED"
      end

    end
  end
end
