class AddressesController < ApplicationController

  def create

  end

  def set_params
    params.require(:address).permit(:address1, :address2, :address3, :address4, :zip, :country)
  end

end