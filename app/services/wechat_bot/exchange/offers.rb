class WechatBot
  class Exchange < Base
    class Offers < Base
      # TODO : valid_until will be managed from within the class, we can store it in database but we will work on that later

      def request
        "i typed offers"
      end

      def response
        puts "YEAH BOI HE TYPED OFFERS AND THINGS HAPPENED"
      end

    end
  end
end
