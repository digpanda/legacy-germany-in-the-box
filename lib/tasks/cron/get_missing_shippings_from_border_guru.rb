class Tasks::Cron::GetMissingShippingsFromBorderGuru

  attr_reader :orders

  def initialize
    devlog "Let's start to fetch all the orders without border guru shipping ids ..."
    @orders = Order.bought.where(border_guru_shipment_id: nil).all
  end

  # it will try to get the shipping id and all other information to the orders that don't have it
  def perform

    if Setting.instance.logistic_partner == :borderguru

      unless orders.length.zero?
        begin
          orders.each do |order|
            response = BorderGuruApiHandler.new(order).get_shipping!
            if response.success?
              devlog "Order processed correctly."
            else
              devlog "A problem occurred while communicating with BorderGuru Api (#{response.error.message}) for Order `#{order.id}`"
            end
          end
        rescue StandardError => exception
          devlog "A problem occured while transmitting the orders (#{exception.message})."
          return
        end
      end

    else
      devlog "Logistic partner is not BorderGuru, we skip the processing."
    end

    devlog "Process finished."
  end

  def devlog(content)
    @@log ||= Logger.new(Rails.root.join("log/border-guru-shipment-id-recovery-#{Time.now.strftime('%Y-%m-%d')}.log"))
    @@log.info content
    puts content if Rails.env.development?
  end

end
