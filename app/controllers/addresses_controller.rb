class AddressesController < ApplicationController
  def create
    num_addresses = current_user.addresses.count

    params = set_params
    params[:primary] = true if num_addresses == 0

    @address = Address.create(params)
    @address.user = current_user

    if @address.save
      if @address.primary and num_addresses > 0
        current_user.addresses.each do |a|
          if a != @address and a.primary
            a.primary = false
            a.save!
          end
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

    respond_to do |format|
      if address.update(set_params)
        if address.primary
          current_user.addresses.each do |a|
            if a != address and a.primary
              a.primary = false
              a.save!
            end
          end
        end

        format.html {
          flash[:success] = 'Address was successfully updated.'
          redirect_to request.referer
        }
      else
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
      current_user.addresses.each do |a|
        if a != address
          a.primary = true
          a.save!
          break
        end
      end
    end

    address.delete

    redirect_to request.referrer
  end

  def set_params
    params.require(:address).permit(:street_building_room, :district, :city, :province, :zip, :country, :primary)
  end

end