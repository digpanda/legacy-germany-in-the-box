class Shopkeeper::AddressesController < ApplicationController
  attr_reader :address

  authorize_resource class: false
  before_action :set_address, only: [:show, :update, :destroy]
  before_action :set_address_country, only: [:create, :update]

  layout :custom_sublayout, only: [:index]

  def index
    @addresses = current_user.shop.addresses
  end

  def show
  end

  def create
    @address = Address.new(address_params)
    address.shop = current_user.shop

    if address.save
      flash[:success] = I18n.t(:create_ok, scope: :edit_address)
      redirect_to navigation.back(1)
      return
    end

    flash[:error] = "#{I18n.t(:create_ko, scope: :edit_address)} (#{address.errors.full_messages.join(', ')})"
    redirect_to navigation.back(1)

  end

  def update
    if address.update(address_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_address)
      redirect_to navigation.back(1)
      return
    end

    flash[:error] = "#{I18n.t(:update_ko, scope: :edit_address)} (#{address.errors.full_messages.join(', ')})"
    redirect_to navigation.back(1)

  end

  def destroy
    address.delete
    redirect_to navigation.back(1)
  end

  def set_address
    @address = current_user.shop.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit!
  end

  def set_address_country
    address_params[:country] = 'DE'
  end
end
