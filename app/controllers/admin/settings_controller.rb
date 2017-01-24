class Admin::SettingsController < ApplicationController

  include DestroyImage

  attr_reader :setting, :settings

  authorize_resource :class => false
  before_action :set_setting

  layout :custom_sublayout

  def index
    redirect_to admin_setting_path(setting)
  end

  def show
  end

  def update
    Settings.instance.update(settings_params)
    # this line is here for a reason, please keep it or fix it.
    # NOTE : upload image not persisting if no previous image before
    Settings.instance.save!
    redirect_to navigation.back(1)
  end

  private

  # setting is a special case
  # we have only one instance (for now)
  def set_setting
    @setting ||= Settings.instance
  end

  def settings_params
    params.require(:settings).permit!
  end

end
