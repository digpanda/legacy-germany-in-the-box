require 'slack-notifier'

# manage the communication between slack and the project
class SlackDispatcher < BaseService

  WEBHOOK_URL = "https://hooks.slack.com/services/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"
  CHANNEL = "#notifs"
  USERNAME = "Lorenzo Schaffnero"

  include Rails.application.routes.url_helpers

  def initialize
    slack.ping "--- *#{Rails.env.capitalize} Mode*"
  end

  def new_paid_transaction(order_payment)
    order = order_payment.order
    slack.ping "*#{order.billing_address.decorate.chinese_full_name}* just paid *#{order.total_paid_in_euro} / #{order.decorate.total_sum_in_euro}*"
    slack.ping "Trace : Order ID *#{order.id}* URL : #{admin_order_url(order)}"
  end

  private

  def slack
    @slack ||= Slack::Notifier.new WEBHOOK_URL, channel: CHANNEL, username: USERNAME
  end

end
