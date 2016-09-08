class Admin::OrdersController < ApplicationController

  load_and_authorize_resource
  before_action :set_order, :except => [:index]

  layout :custom_sublayout, only: [:index, :show]

  attr_accessor :order

  def index
    respond_to do |format|
      format.html do
        @orders = Order.nonempty.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
      end
      format.csv do
        # TODO : make this work correctly
        #render text: OrdersToCsv.new(orders).to_csv.encode(CSV_ENCODE),
        #       type: "text/csv; charset=#{CSV_ENCODE}; header=present",
        #       disposition: 'attachment'
      end
    end
  end

  def show
  end

  def update
    if order.update(order_params)
      flash[:success] = "The order was updated."
    else
      flash[:error] = "The order was not updated (#{order.erros.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def order_params
    params.require(:order).permit(:bill_id)
  end

end
