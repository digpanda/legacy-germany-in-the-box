# account management from the shopkeeper area
class Shopkeeper::AccountController < ApplicationController
  attr_reader :user

  authorize_resource class: false
  before_action :set_user

  layout :custom_sublayout

  def edit
  end

  def update
    if account_manager.success?
      flash[:success] = I18n.t('notice.account_updated')
    else
      flash[:error] = "#{account_manager.error}"
    end

    redirect_to navigation.back(1)
  end

  private

    def account_manager
      @account_manager ||= AccountManager.new(request, params, user).perform
    end

    def set_user
      @user = current_user
    end
end
