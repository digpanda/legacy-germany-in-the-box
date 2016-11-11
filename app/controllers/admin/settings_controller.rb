class Admin::SettingsController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout

  def show
    @settings = Settings.instance
  end

  def update
    Settings.instance.update(settings_params)
    Settings.instance.save!
    redirect_to request.referer
  end

  private

  def settings_params
    delocalize_config = { :exchange_rate_to_yuan => :number, :max_total_per_day => :number }
    params.require('/admin/settings').permit(:exchange_rate_to_yuan, :max_total_per_day, :highlight_title, :alert).delocalize(delocalize_config)
  end

end
