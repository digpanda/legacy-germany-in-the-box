class SettingDecorator < Draper::Decorator

  include Concerns::Imageable

  delegate_all
  decorates :setting

  # NOTE : we need this decorator for image_url method used on settings

end
