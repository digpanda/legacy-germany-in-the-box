class Tasks::Cron::GetMissingShippingsFromBorderGuru

  attr_reader :orders

  def initialize
    devlog "Let's start to fetch all the orders without border guru shipping ids ..."
    @orders = Order.where(border_guru_shipment_id: nil).all
  end

  # it will try to get the shipping id and all other information to the orders that don't have it
  def perform

    unless orders.length.zero?
      begin
        orders.each do |order|
          response = BorderGuruApiHandler.new(order).track!
          if response.success?
            devlog "Order processed correctly."
          else
            devlog "A problem occurred while communicating with BorderGuru Api (#{response.error.message})"
          end
        end
      rescue StandardError => exception
        devlog "A problem occured while transmitting the orders (#{exception.message})."
        return
      end
    end

    devlog "Process finished."
  end

  def devlog(content)
    @@log ||= Logger.new(Rails.root.join("log/border_guru_shipment_id_recovery"))
    @@log.info content
    puts content if Rails.env.development?
  end

end
