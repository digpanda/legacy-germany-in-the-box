class OrderDecorator < Draper::Decorator

  MAX_DESCRIPTION_CHARACTERS = 200

  delegate_all
  decorates :order

  def clean_desc
    Cleaner.slug(desc)
  end

  def clean_order_items_description
    self.order_items.reduce([]) do |acc, order_item|
      acc << order_item.clean_desc
    end.join(', ')
  end

end
