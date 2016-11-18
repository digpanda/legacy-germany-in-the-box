require 'border_guru_email/transmit_orders'

# manage the orders between the project and BorderGuru (provider : Hermes)
# pretty self explanatory.
module BorderGuruEmail

  CONFIG = Rails.application.config.border_guru
  Error = Class.new(StandardError)

  class << self

    # we transmit the orders to our post office
    # and update the orders accordingly
    def transmit_orders(orders)
      TransmitOrders.new(orders).tap do |transmit|
        transmit.send_emails
        transmit.update_orders!
      end
    end

    # you can add any BorderGuru Email specifig logs by doing BorderGuruFtp.log('message')
    def log(content)
      @@log ||= Logger.new(Rails.root.join("log/#{CONFIG[:email][:log]}"))
      @@log.info content
      puts content if Rails.env.development?
    end

  end

end
