class Admin::SettingsController < ApplicationController
  include DestroyImage

  attr_reader :setting, :settings

  authorize_resource class: false
  before_action :set_setting

  layout :custom_sublayout

  def index
    redirect_to admin_setting_path(setting)
  end

  def show
  end

  def update
    Setting.instance.update!(settings_params)
    # this line is here for a reason, please keep it or fix it.
    # NOTE : upload image not persisting if no previous image before
    Setting.instance.save(validation: false)
    redirect_to navigation.back(1)
  end

  private

    # setting is a special case
    # we have only one instance (for now)
    def set_setting
      @setting ||= Setting.instance
    end

    def settings_params
      params.require(:setting).permit!
    end
end
