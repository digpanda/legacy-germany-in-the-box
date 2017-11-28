module SmartExchange
  module Scheme
    class Ping < Base

      # valid_until -> { 7.days.from_now }

      # test system to see if the whole structure works fine
      def request
        'special deal'
      end

      def response
        if package_set
          messenger.image! url: "#{guest_package_sets_promote_qrcode_url(package_set)}.jpg"
          messenger.text! "#{promotion}"
        else
          messenger.text! 'No deal found.'
        end
      end

      def package_set
        @package_set ||= Setting.instance.promoted_package_set
      end

      def promotion
        Setting.instance.promoted_package_set_text
      end
    end
  end
end
