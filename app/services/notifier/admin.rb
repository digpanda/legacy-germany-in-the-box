class Notifier
  class Admin

    def initialize
    end

    def referrer_claimed_money(referrer)
      DispatchNotification.new(
      email: "info@digpanda.com",
      title: "Referrer #{referrer.reference_id}",
      desc: "This referrer claimed money. Please check his account and process operations if needed."
      ).perform
    end

  end
end
