class Admin::HomeController < ApplicationController
  authorize_resource class: false
  layout :custom_sublayout

  def show
  end
end
