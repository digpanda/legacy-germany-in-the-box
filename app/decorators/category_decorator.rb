class CategoryDecorator < Draper::Decorator
  include Concerns::Imageable

  delegate_all
  decorates :category
end
