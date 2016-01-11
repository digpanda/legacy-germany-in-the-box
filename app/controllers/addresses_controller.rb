class AddressesController < ApplicationController

  def create
    @address = Address.create(set_params)
    @address.user = current_user
    @address.save!

    respond_to do |format|
      format.html {
        redirect_to request.referrer
      }
    end
  end


  def destroy
    Address.find(params[:id]).delete
    redirect_to request.referrer
  end

  def set_params
    params.require(:address).permit(:address1, :address2, :address3, :address4, :zip, :country)
  end

end