require 'net/http'

class Customer::IdentityController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout, only: [:edit]

  def edit
    @identity_form = Xipost.identity_form
  end

end
