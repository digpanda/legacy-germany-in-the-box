class BannerDecorator < Draper::Decorator
  include Concerns::Imageable

  delegate_all
  decorates :banner
end
