class ReferrerCustomizationDecorator < Draper::Decorator
  include Concerns::Imageable

  delegate_all
  decorates :referrer_customization
end
