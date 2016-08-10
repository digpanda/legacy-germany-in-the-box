module Wirecard
  class Merchant < Base

    class << self

      def checkout_portal(shop)
        Merchant::CheckoutPortal.new(shop)
      end

    end

  end
end
