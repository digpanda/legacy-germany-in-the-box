require 'slack-notifier'

# manage the communication between slack and the project
class SlackDispatcher < BaseService
  include Rails.application.routes.url_helpers

  WEBHOOK_URL = 'https://hooks.slack.com/services/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'.freeze
  DEFAULT_CHANNEL = '#notifs'.freeze
  USERNAME = 'Lorenzo Schaffnero'.freeze

  attr_reader :counter, :custom_channel

  def initialize(custom_channel: nil)
    @counter = 0
    @custom_channel = custom_channel
    worker "--- *#{Rails.env.capitalize} Mode* #{Time.now.utc}"
  end

  def message(message, url: nil, channel: nil)
    push "#{message}"
    push "More : #{url}" if url
  end

  def service_message(user, content)
    message "[Wechat] #{user&.decorate&.who} : `#{content}`", url: admin_user_url(user)
  end

  def paid_transaction(order_payment)
    order = order_payment.order
    message "*#{order.billing_address.decorate.full_name}* just paid *#{order.total_paid_in_euro} / #{order.total_price_with_extra_costs.in_euro.display}*", url: admin_order_url(order)
  end

  def failed_transaction(order_payment)
    order = order_payment.order
    message "*#{order.billing_address.decorate.full_name}* just *FAILED* to pay *#{order.total_paid_in_euro} / #{order.total_price_with_extra_costs.in_euro.display}*", url: admin_order_url(order)
  end

  def login(user)
    message "[Login] Auth #{user.decorate.readable_role} `#{user.decorate.who}`", url: admin_user_url(user)
  end

  def error(error)
    message "[Error] `#{error}`"
  end

  private

    def slack
      @slack ||= Slack::Notifier.new WEBHOOK_URL, channel: end_channel, username: USERNAME
    end

    def end_channel
      custom_channel || DEFAULT_CHANNEL
    end

    def push(message)
      worker "[#{counter}] #{message}"
      @counter += 1
    end

    def worker(message)
      if Rails.env.development? || Rails.env.test?
        # SlackWorker.new.perform(message)
        # NO DISPATCH AT ALL, CAN BE ACTIVATED AGAIN
      else
        # ROLLBACK TO OLD WORKER (WAS FASTER)
        slack.delay.ping message
        # SlackWorker.new.delay.perform(message)
        #SlackWorker.perform_async(message)
      end
    end

end
