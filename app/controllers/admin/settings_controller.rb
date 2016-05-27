class Admin::SettingsController < ApplicationController

  layout :custom_sublayout

  def show
    @settings = Settings.instance
    render 'users/admin/edit_setting'
  end

  def update
    Settings.instance.update(settings_params)
    Settings.instance.save!
    redirect_to request.referer
  end

  private

  def settings_params
    delocalize_config = { :exchange_rate_to_yuan => :number }
    params.require('/admin/settings').permit(:exchange_rate_to_yuan).delocalize(delocalize_config)
  end

end