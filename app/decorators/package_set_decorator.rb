class PackageSetDecorator < Draper::Decorator
  include Concerns::Imageable
  include ActionView::Helpers::TextHelper

  delegate_all
  decorates :package_set

  def short_desc(characters = 100)
    truncate(self.desc, length: characters)
  end

  # we just check if the current price_per_unit is equal to the casual price
  # if not it's custom
  def custom_price?
    total_price_with_taxes != casual_total_price
  end

  # this is to show the normal casual price
  # by forcing the thread definition
  # and rollingback afterwards
  def casual_total_price
    price_origin = Thread.current[:price_origin]
    Thread.current[:price_origin] = :casual_price
    casual_price = total_price_with_taxes
    Thread.current[:price_origin] = price_origin
    casual_price
  end

end
