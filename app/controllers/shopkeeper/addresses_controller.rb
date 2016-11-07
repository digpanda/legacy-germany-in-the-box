class Shopkeeper::AddressesController < ApplicationController

  attr_reader :address

  load_and_authorize_resource
  layout :custom_sublayout, only: [:index]
  before_action :set_address, only: [:show, :create, :update, :destroy]

  def index
    @addresses = current_user.addresses
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

    # this should be turned into a create
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
    if address.primary
      set_alternative_primary_address(address)
    end
    redirect_to navigation.back(1)
  end

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit!
  end

end
