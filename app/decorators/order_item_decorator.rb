class OrderItemDecorator < Draper::Decorator

  delegate_all
  decorates :order_item
  
end