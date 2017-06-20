class Notifier
  class Admin < Notifier

    attr_reader :user

    # no specific admin
    # we are using a more classical
    # emailing system
    def initialize
      @user = nil
    end

    def referrer_claimed_money(referrer)
      dispatch(
        email: "info@digpanda.com",
        title: "Referrer #{referrer.reference_id}",
        desc: "This referrer claimed money. Please check his account and process operations if needed."
      ).perform
    end

  end
end
