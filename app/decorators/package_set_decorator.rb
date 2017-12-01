class PackageSetDecorator < Draper::Decorator
  include Concerns::Imageable
  include ActionView::Helpers::TextHelper

  delegate_all
  decorates :package_set

  def short_desc(characters = 100)
    truncate(self.desc, length: characters)
  end

  # if the casual total price (the normal one) is different from the current price with taxes
  # it means the price has been altered and is different
  # we make sure to make the difference depending the original price too
  def custom_price?
    (casual_total_price != total_price_with_taxes) && (original_price > 0)
  end

  def casual_total_price
    custom_price = Thread.current[:custom_price]
    Thread.current[:custom_price] = :casual_price
    final_price = total_price_with_taxes
    Thread.current[:custom_price] = custom_price
    final_price
  end

end
