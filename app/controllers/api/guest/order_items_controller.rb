class Api::Guest::OrderItemsController < Guest::OrderItemsController

  load_and_authorize_resource
  
  # +/- items of the same product
  def set_quantity
    # You can use @order_item here
    # The json-view is in views/api/order_item/set_quantity.json.jbuilder
  end

end