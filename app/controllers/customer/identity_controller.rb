require 'net/http'

class Customer::IdentityController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout, only: [:edit]

  def edit
    if Setting.instance.logistic_partner == :xipost
      @identity_remote_url = Xipost.identity_remote_url
    else
      @identity_remote_url = "Partner does not require identity."
    end
  end

end
