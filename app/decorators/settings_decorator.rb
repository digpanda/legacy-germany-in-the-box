class SettingsDecorator < Draper::Decorator

  include Concerns::Imageable

  delegate_all
  decorates :settings

end
