require 'slack-notifier'

# manage the communication between slack and the project
class SlackDispatcher < BaseService
  include Rails.application.routes.url_helpers

  attr_reader :counter

  def initialize
    @counter = 0
    worker "--- *#{Rails.env.capitalize} Mode* #{Time.now.utc}"
  end

  def message(message, url: nil)
    push "#{message}"
    push "More : #{url}" if url
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
        SlackWorker.new.delay.perform(message)
        #SlackWorker.perform_async(message)
      end
    end

end
