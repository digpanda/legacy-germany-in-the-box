class Admin::OrdersController < ApplicationController

  CSV_ENCODE = "UTF-8"

  load_and_authorize_resource
  before_action :set_order, :except => [:index]

  layout :custom_sublayout

  attr_accessor :order, :orders

  def index
    respond_to do |format|
      format.html do
        @orders = Order.nonempty.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
      end
      format.csv do
        render text: OrdersFormatter.new(orders).to_csv.encode(CSV_ENCODE),
               type: "text/csv; charset=#{CSV_ENCODE}; header=present",
               disposition: 'attachment'
      end
    end
  end

  def show
  end

  def update
    if order.update(order_params)
      flash[:success] = "The order was updated."
    else
      flash[:error] = "The order was not updated (#{order.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  # could be placed after a while into a new controller
  def force_get_shipping
    response = BorderGuruApiHandler.new(order).get_shipping!
    if response.success?
      flash[:success] = "Shipping was attributed."
    else
      flash[:error] = "A problem occurred while communicating with BorderGuru Api (#{response.error.message})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def order_params
    params.require(:order).permit!
  end

end
