class ImageDecorator < Draper::Decorator
  include Concerns::Imageable

  delegate_all
  decorates :image
end
