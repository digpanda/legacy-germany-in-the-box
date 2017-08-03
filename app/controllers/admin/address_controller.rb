# NOTE : this controller is actually used to get the address of the customer
# from the admin side.
# NOTE 2 : the controller itself isn't currently used but only the view.
class Admin::AddressController < ApplicationController

  attr_accessor :address

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
