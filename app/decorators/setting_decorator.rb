class SettingDecorator < Draper::Decorator

  include Concerns::Imageable

  delegate_all
  decorates :setting

end
