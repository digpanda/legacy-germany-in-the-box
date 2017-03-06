class Api::Guest::CartController < Api::ApplicationController

  attr_reader :order, :package_set

  def total
    render status: :ok,
           json: {success: true, datas: cart_manager.products_number}.to_json
  end

  def destroy_package_set
    @order = Order.find(params[:order_id])
    @package_set = PackageSet.find(params[:package_set_id])
    order.order_items.where(package_set: package_set).each do |order_item|
      order_item.destroy
    end
    
    render status: :ok,
           json: {success: true}.to_json
  end

end
