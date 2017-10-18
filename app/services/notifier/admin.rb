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
        url: admin_referrer_path(referrer)
      ).perform
    end

    def new_wechat_message(identity, message)
      dispatch(
        email: 'info@digpanda.com',
        mailer: AdminMailer,
        title: "Wechat Message",
        desc: "We just received a new message from the Wechat Service : (#{identity}) #{message}",
      ).perform
    end

    def new_inquiry(inquiry)
      dispatch(
        email: 'info@digpanda.com',
        mailer: AdminMailer,
        title: "Inquiry #{inquiry.id}",
        desc: 'There is a new inquiry which was sent to us. Please check it out.',
        scope: :admin_inquiries,
        url: admin_inquiry_path(inquiry)
      ).perform
    end

    def unvalid_link_detected(link)
      dispatch(
        email: 'info@digpanda.com',
        mailer: AdminMailer,
        title: "Link #{link.id} was found invalid",
        desc: "The end link #{link.raw_url} is not valid, please fix / remove it from the database.",
        url: admin_link_path(link)
      ).perform
    end
  end
end
