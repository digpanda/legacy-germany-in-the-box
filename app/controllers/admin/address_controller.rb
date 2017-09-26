# NOTE : the controller itself isn't currently used but only the view.
class Admin::AddressController < ApplicationController
  attr_reader :address

  authorize_resource class: false

  before_action :set_address, only: [:show]

  layout :custom_sublayout

  def index
  end

  def show
  end

  private

    def set_address
      @address = Address.find(params[:id])
    end
end
