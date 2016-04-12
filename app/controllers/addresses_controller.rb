class AddressesController < ApplicationController

  before_action :authenticate_user!

  load_and_authorize_resource

  def show_addresses
    @address = Address.new
    render "show_#{current_user.role.to_s}_addresses", layout: "#{current_user.role.to_s}_sublayout"
  end

  def index
    if current_user.role == :customer
      @addresses = current_user.addresses
      render :index, :status => :ok
    end
  end

  def create
    if current_user.role == :customer
      num_addresses = current_user.addresses.count

      if num_addresses >= Rails.configuration.max_num_addresses
        respond_to do |format|
          format.html {
            flash[:error] = I18n.t(:create_ko, scope: :edit_address)
            redirect_to request.referrer
          }

          format.json {
            render :json => { msg: I18n.t(:maximal_number_of_addresses, scope: :edit_address, num: Rails.configuration.max_num_addresses ) }.to_json, :status => :unprocessable_entity
          }
        end
      end

      ap = address_params
      ap[:primary] = true if num_addresses == 0

      ap[:district] = ChinaCity.get(ap[:district])
      ap[:city] = ChinaCity.get(ap[:city])
      ap[:province] = ChinaCity.get(ap[:province])

      address = Address.new(ap)
      address.user = current_user

      if (flag = address.save)
        if address.primary and num_addresses > 0
          current_user.addresses.select { |a| a.primary and a != address } .each do |a|
            a.primary = false
            flag &&= a.save
          end
        end
      end
    elsif current_user.role == :shopkeeper
      num_addresses = current_user.shop.addresses.count
      max_num_addresses = Rails.configuration.max_num_shop_billing_addresses + Rails.configuration.max_num_shop_sender_addresses

      if num_addresses >= max_num_addresses
        respond_to do |format|
          format.html {
            flash[:error] = I18n.t(:create_ko, scope: :edit_address)
            redirect_to request.referrer
          }

          format.json {
            render :json => { msg: I18n.t(:maximal_number_of_addresses, scope: :edit_address, num: max_num_addresses) }.to_json, :status => :unprocessable_entity
          }
        end
      end

      address = Address.new(address_params)
      address.shop = current_user.shop
      flag = address.save
    end

    if flag
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:create_ok, scope: :edit_address)
          redirect_to request.referrer
        }

        format.json {
          render :json => { :status => :ok }, :status => :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = I18n.t(:create_ko, scope: :edit_address)
          redirect_to request.referrer
        }

        format.json {
          render :json => { :status => :ko, :msg => address.errors.full_messages.first }, :status => :unprocessable_entity
        }
      end
    end

  end

  def update
    if current_user.role == :customer
      if (address = current_user.addresses.find(params[:id]))
        ap = address_params

        ap[:district] = ChinaCity.get(ap[:district])
        ap[:city] = ChinaCity.get(ap[:city])
        ap[:province] = ChinaCity.get(ap[:province])

        if (flag = address.update(ap))
          if address.primary
            current_user.addresses.select { |a| a.primary and a != address } .each do |a|
              a.primary = false
              flag &&= a.save
            end
          end
        end
      end
    elsif current_user.role == :shopkeeper
      address = current_user.shop.addresses.find(params[:id])
      flag = address.update(address_params)
    end

    if flag
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:update_ok, scope: :edit_address)
          redirect_to request.referer
        }

        format.json {
          render :json => { :status => :ok }, :status => :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = I18n.t(:update_ko, scope: :edit_address)
          redirect_to request.referer
        }

        format.json {
          render :json => { :status => :ko, :msg => address.errors.full_messages.first }, :status => :unprocessable_entity
        }
      end
    end
  end

  def destroy
    if current_user.role == :customer
      if (address = current_user.addresses.find(params[:id]))
        flag = address.delete

        if address.primary
          candidate = current_user.addresses.not.where(:id => address.id).first

          if candidate
            candidate.primary = true
            flag &&= candidate.save
          end
        end
      end
    elsif current_user.role == :shopkeeper
      address = current_user.shop.addresses.find(params[:id])
      flag = address.delete
    end


    if flag
      respond_to do |format|
        format.html {
          flash[:success] = I18n.t(:delete_ok, scope: :edit_address)
          redirect_to request.referer
        }

        format.json {
          render :json => { :status => :ok }, :status => :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = I18n.t(:delete_ko, scope: :edit_address)
          redirect_to request.referer
        }

        format.json {
          render :json => { :status => :ko, :msg => address.errors.full_messages.first }, :status => :unprocessable_entity
        }
      end
    end
  end

  private

  def address_params
    if current_user.role == :customer
      params.require(:address).permit(:number,
                                      :street,
                                      :additional,
                                      :district,
                                      :city,
                                      :province,
                                      :zip,
                                      :country,
                                      :primary)
    else
      params.require(:address).permit(:number,
                                      :street,
                                      :additional,
                                      :district,
                                      :city,
                                      :province,
                                      :zip,
                                      :country,
                                      :type,
                                      :email,
                                      :mobile,
                                      :tel,
                                      :fname,
                                      :lname)
    end
  end

end