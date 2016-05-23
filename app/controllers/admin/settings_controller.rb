class Admin::SettingsController < ApplicationController

  layout :custom_sublayout

  def show
    @settings = Settings.instance
    render 'users/admin/edit_setting'
  end

end