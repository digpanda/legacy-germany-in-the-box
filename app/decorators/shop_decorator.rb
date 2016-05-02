class ShopDecorator < Draper::Decorator

  delegate_all
  decorates :shop

end

