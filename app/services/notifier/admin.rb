class Notifier
  class Admin < Notifier
    include Rails.application.routes.url_helpers

    attr_reader :user, :unique_id

    # no specific admin
    # we are using a more classical
    # emailing system
    def initialize
      @user = nil
    end

    def referrer_claimed_money(referrer)
      dispatch(
        email: 'info@digpanda.com',
        mailer: AdminMailer,
        title: "Referrer #{referrer.reference_id} claimed money",
        desc: 'This referrer claimed money. Please check his account and process operations if needed.',
        url: admin_referrer_url(referrer)
      ).perform
    end

    def unvalid_link_detected(link)
      dispatch(
        email: 'info@digpanda.com',
        mailer: AdminMailer,
        title: "Link #{link.id} was found invalid",
        desc: "The end link #{link.raw_url} is not valid, please fix / remove it from the database.",
        url: admin_link_url(link)
      ).perform
    end
  end
end
