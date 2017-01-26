class Customer::AddressesController < ApplicationController

  attr_reader :address

  authorize_resource :class => false
  layout :custom_sublayout, only: [:index]
  before_action :set_address, only: [:show, :update, :destroy]

  def index
    @addresses = current_user.addresses
  end

  def show
  end

  def create

    num_addresses = current_user.addresses.count

    if num_addresses >= Rails.configuration.achat[:max_num_addresses]
      flash[:error] = I18n.t(:create_ko, scope: :edit_address)
      redirect_to redirect_to navigation.back(1)
      return
    end

    # this should be turned into a create
    address_params[:primary] = true if num_addresses == 0
    address_params[:district] = ChinaCity.get(address_params[:district])
    address_params[:city] = ChinaCity.get(address_params[:city])
    address_params[:province] = ChinaCity.get(address_params[:province])
    address_params[:country] = 'CN'

    address = Address.new(address_params)
    address.user = current_user

    if address.save
      if address.primary && (num_addresses > 0)
        reset_primary_address!(address)
      end
      flash[:success] = I18n.t(:create_ok, scope: :edit_address)
      redirect_to navigation.back(1)
      return
    end

    flash[:error] = I18n.t(:create_ko, scope: :edit_address)
    redirect_to navigation.back(1)

  end

  def update

    # TODO : this should be changed and the update
    # should occur in a row without changing the params like this
    address_params[:district] = ChinaCity.get(address_params[:district])
    address_params[:city] = ChinaCity.get(address_params[:city])
    address_params[:province] = ChinaCity.get(address_params[:province])
    address_params[:country] = 'CN'

    if address.update(address_params)
      if address.primary
        reset_primary_address!(address)
      end
      flash[:success] = I18n.t(:update_ok, scope: :edit_address)
      redirect_to navigation.back(1)
      return
    end

    flash[:error] = I18n.t(:update_ko, scope: :edit_address)
    redirect_to navigation.back(1)

  end

  def destroy
    address.delete
    if address.primary
      set_alternative_primary_address(address)
    end
    redirect_to navigation.back(1)
  end

  private

  def set_alternative_primary_address(address)
    candidate = current_user.addresses.not.where(:id => address.id).first
    if candidate
      candidate.primary = true
      candidate.save
    end
  end

  def reset_primary_address!(address)
    # TODO : we refresh the primary address
    # This should be put into model
    current_user.addresses.select do |current_address|
      if (current_address.primary && (current_address != address))
        current_address.primary = false
        current_address.save
      end
    end
  end

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit!
  end

end
