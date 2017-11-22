# when someone scans a qrcode related to our service channel
# it will go down here
module WechatBot
  class Event < Base
    class Scan < Base
      attr_reader :user, :event_key

      def initialize(user, event_key)
        @user = user
        @event_key = event_key
      end

      # we bind the user to the referrer when he scans the QRCode
      def handle
        unless Parser.valid_json?(event_key)
          raise WechatBot::Error, 'Wrong extra data transmitted'
        end

        # db.referrers.find({"reference_id": "okv2022017"}).sort({ "_id": 1}).skip(0).limit(30)

        # we are in front of a referrer request
        referrer = Referrer.where(reference_id: reference_id).first
        SlackDispatcher.new.message("REFERENCE ID IS #{reference_id}")
        SlackDispatcher.new.message("REFERRER FOUND FROM IT IS: #{referrer}")
        SlackDispatcher.new.message("SELECTOR #{Referrer.where(reference_id: reference_id).selector}")
        slack.message "Referrer is `#{referrer.id}`", url: admin_referrer_url(referrer)

        if user && referrer
          slack.message "Customer is `#{user.id}`", url: admin_user_url(user)
        else
          slack.message "Customer was not resolved : #{wechat_user_solver.error}"
          raise WechatBot::Error, 'Wrong referrer or/and customer'
          return
        end

        # binding the potential user with the referrer
        ReferrerBinding.new(referrer).bind(user)

        slack.message "Referrer user children `#{referrer.children_users.count}`"

        return_with(:success)
      end

      private

        def reference_id
          SlackDispatcher.new.message("EXTRA DATA #{extra_data}")
          # remove absolutely all invisible characters
          extra_data['referrer']['reference_id'].gsub(/[^[:print:]]/,'.').squish
        end

        def extra_data
          @extra_data ||= JSON.parse(event_key)
        end

    end
  end
end
