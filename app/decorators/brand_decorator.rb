class BrandDecorator < Draper::Decorator
  include Concerns::Imageable

  delegate_all
  decorates :brand
end
