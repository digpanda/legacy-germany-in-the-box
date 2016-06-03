class AddressesController < ApplicationController

  before_action :authenticate_user!

  load_and_authorize_resource

  layout :custom_sublayout, only: [:show_addresses]

  def show_addresses
    @address = Address.new
    render "show_#{current_user.role.to_s}_addresses"
  end

  def index
    if current_user.is_customer?
      @addresses = current_user.addresses
      render :index, :status => :ok
    end
  end

  def create
    if current_user.is_customer?
      num_addresses = current_user.addresses.count

      if num_addresses >= Rails.configuration.max_num_addresses

        flash[:error] = I18n.t(:create_ko, scope: :edit_address)
        redirect_to request.referrer
        return

      else
        ap = address_params
        ap[:primary] = true if num_addresses == 0

        ap[:district] = ChinaCity.get(ap[:district])
        ap[:city] = ChinaCity.get(ap[:city])
        ap[:province] = ChinaCity.get(ap[:province])
        ap[:country] = ISO3166::Country.find_by_name(ap[:country])[0]

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
      end
    elsif current_user.is_shopkeeper?
      num_addresses = current_user.shop.addresses.count
      max_num_addresses = Rails.configuration.max_num_shop_billing_addresses + Rails.configuration.max_num_shop_sender_addresses

      if num_addresses >= max_num_addresses

        flash[:error] = I18n.t(:create_ko, scope: :edit_address)
        redirect_to request.referrer

      else
        ap = address_params
        ap[:country] = ISO3166::Country.find_by_name(ap[:country])[0]

        address = Address.new(ap)
        address.shop = current_user.shop

        flag = address.save
      end
    end

    if flag
      flash[:success] = I18n.t(:create_ok, scope: :edit_address)
      redirect_to request.referrer
    else
      flash[:error] = I18n.t(:create_ko, scope: :edit_address)
      redirect_to request.referrer
    end
  end

  def update
    if current_user.is_customer?
      if (address = current_user.addresses.find(params[:id]))
        ap = address_params

        ap[:district] = ChinaCity.get(ap[:district])
        ap[:city] = ChinaCity.get(ap[:city])
        ap[:province] = ChinaCity.get(ap[:province])
        ap[:country] = ISO3166::Country.find_by_name(ap[:country])[0]

        if (flag = address.update(ap))
          if address.primary
            current_user.addresses.select { |a| a.primary and a != address } .each do |a|
              a.primary = false
              flag &&= a.save
            end
          end
        end
      end
    elsif current_user.is_shopkeeper?
      address = current_user.shop.addresses.find(params[:id])
      ap = address_params
      ap[:country] = ISO3166::Country.find_by_name(ap[:country])[0]
      flag = address.update(ap)
    end

    if flag
      flash[:success] = I18n.t(:update_ok, scope: :edit_address)
      redirect_to request.referer
    else
      flash[:error] = I18n.t(:update_ko, scope: :edit_address)
      redirect_to request.referer
    end
  end

  def destroy
    if current_user.is_customer?
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
    elsif current_user.is_shopkeeper?
      address = current_user.shop.addresses.find(params[:id])
      flag = address.delete
    end


    if flag
      flash[:success] = I18n.t(:delete_ok, scope: :edit_address)
      redirect_to request.referer
    else
      flash[:error] = I18n.t(:delete_ko, scope: :edit_address)
      redirect_to request.referer
    end
  end

  private

  def address_params
    if current_user.is_customer?
      params.require(:address).permit(:number,
                                      :street,
                                      :additional,
                                      :district,
                                      :city,
                                      :province,
                                      :zip,
                                      :country,
                                      :primary,
                                      :mobile,
                                      :tel,
                                      :fname,
                                      :lname)
    elsif current_user.is_shopkeeper?
      params.require(:address).permit(:number,
                                      :street,
                                      :additional,
                                      :district,
                                      :city,
                                      :province,
                                      :zip,
                                      :country,
                                      :type,
                                      :mobile,
                                      :tel,
                                      :fname,
                                      :lname,
                                      :company)
    end
  end

end