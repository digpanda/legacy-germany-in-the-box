require 'net/http'

class Customer::IdentityController < ApplicationController
  authorize_resource class: false
  layout :custom_sublayout, only: [:edit]

  def edit
    if Setting.instance.logistic_partner == :xipost
      @identity_remote_url = xipost.identity_remote_url
      # @identity_form = xipost.identity_form
    else
      @identity_remote_url = ''
      # @identity_form = "Partner does not require identity."
    end
  end

  private

    # redirect straight to xipost whatever the settings are
    def xipost_remote
      redirect_to xipost.identity_remote_url
    end

    def xipost
      @xipost ||= Xipost.new(current_user)
    end
end
