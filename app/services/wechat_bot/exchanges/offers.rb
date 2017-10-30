class WechatBot
  class Exchanges < Base
    class Offers
      # TODO : valid_until will be managed from within the class, we can store it in database but we will work on that later
      
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
