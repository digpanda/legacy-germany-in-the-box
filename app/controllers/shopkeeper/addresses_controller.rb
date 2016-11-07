class Shopkeeper::AddressesController < ApplicationController

  attr_reader :address

  load_and_authorize_resource
  layout :custom_sublayout, only: [:index]
  before_action :set_address, only: [:show, :update, :destroy]

  def index
    @addresses = current_user.shop.addresses
  end

  def show
  end

  def create

    num_addresses = current_user.addresses.count

    if num_addresses >= (Rails.configuration.max_num_shop_billing_addresses + Rails.configuration.max_num_shop_sender_addresses)
      flash[:error] = I18n.t(:create_ko, scope: :edit_address)
      redirect_to redirect_to navigation.back(1)
      return
    end

    # this should be tackled differently
    address_params[:country] = 'DE'

    address = Address.new(address_params)
    address.shop = current_user.shop

    if address.save
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
    address_params[:country] = 'DE'

    if address.update(address_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_address)
      redirect_to navigation.back(1)
      return
    end

    flash[:error] = I18n.t(:update_ko, scope: :edit_address)
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

end
