# output orders in different format
class OrderDisplayer < BaseService

  attr_reader :order

  def initialize(order)
    @order = order
  end

  # will be used in multiple methods
  def render_to_pdf
      render pdf: order.id.to_s, disposition: 'attachment'
  end

  # render a CSV for one specific order
  def render_to_csv
    render text: BorderGuruFtp::TransferOrders::Makers::Generate.new([order]).to_csv.encode(CSV_ENCODE),
           type: "text/csv; charset=#{CSV_ENCODE}; header=present",
           disposition: 'attachment'
  end

end
