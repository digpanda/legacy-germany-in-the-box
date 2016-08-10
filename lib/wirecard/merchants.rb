module Wirecard
  class Merchants < Base

    class << self

      def checkout_portal(shop)
       CheckoutPortal.new(shop)
      end

    end

  end
end
