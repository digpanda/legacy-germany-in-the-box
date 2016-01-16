class AddressesController < ApplicationController

  def create
    num_addresses = current_user.addresses.count

    params = set_params
    params[:primary] = true if num_addresses == 0

    params[:district] = ChinaCity.get(params[:district])
    params[:city] = ChinaCity.get(params[:city])
    params[:province] = ChinaCity.get(params[:province])

    @address = Address.create(params)
    @address.user = current_user

    if @address.save
      if @address.primary and num_addresses > 0
        current_user.addresses.select { |a| a.primary and a != @address } .each do |a|
          a.primary = false
          a.save
        end
      end

      respond_to do |format|
        format.html {
          flash[:success] = 'Address was successfully created.'
          redirect_to request.referrer
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = @address.errors.full_messages.first
          redirect_to request.referrer
        }
      end
    end
  end

  def update
    address = Address.find(params[:id])

    params = set_params

    params[:district] = ChinaCity.get(params[:district])
    params[:city] = ChinaCity.get(params[:city])
    params[:province] = ChinaCity.get(params[:province])

    if address.update(params)
      if address.primary
        current_user.addresses.select { |a| a.primary and a != address } .each do |a|
          a.primary = false
          a.save
        end
      end

      respond_to do |format|
        format.html {
          flash[:success] = 'Address was successfully updated.'
          redirect_to request.referer
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = address.errors.full_messages.first
          redirect_to request.referer
        }
      end
    end
  end

  def destroy
    address = Address.find(params[:id])

    if address.primary
      candidate = current_user.addresses.detect { |a| a != address }
      candidate.primary = true
      candidate.save
    end

    address.delete

    redirect_to request.referrer
  end

  def set_params
    params.require(:address).permit(:street_building_room, :district, :city, :province, :zip, :country, :primary)
  end

end