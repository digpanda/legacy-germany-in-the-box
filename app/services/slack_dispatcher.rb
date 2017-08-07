require 'slack-notifier'

# manage the communication between slack and the project
class SlackDispatcher < BaseService

  WEBHOOK_URL = "https://hooks.slack.com/services/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"
  CHANNEL = "#notifs"
  USERNAME = "Lorenzo Schaffnero"

  include Rails.application.routes.url_helpers

  attr_reader :counter

  def initialize
    @counter = 0
    slack.delay.ping "--- *#{Rails.env.capitalize} Mode* #{Time.now.utc}"
  end

  def message(message, url: nil)
    push "#{message}"
    push "More : #{url}" if url
  end

  def paid_transaction(order_payment)
    order = order_payment.order
    message "*#{order.billing_address.decorate.chinese_full_name}* just paid *#{order.total_paid_in_euro} / #{order.total_price_with_extra_costs.in_euro.display}*", url: admin_order_url(order)
  end

  def failed_transaction(order_payment)
    order = order_payment.order
    message "*#{order.billing_address.decorate.chinese_full_name}* just *FAILED* to pay *#{order.total_paid_in_euro} / #{order.total_price_with_extra_costs.in_euro.display}*", url: admin_order_url(order)
  end

  private

  def push(message)
    slack.delay.ping "[#{counter}] #{message}"
    @counter += 1
  end

  def slack
    @slack ||= Slack::Notifier.new WEBHOOK_URL, channel: CHANNEL, username: USERNAME
  end

end
