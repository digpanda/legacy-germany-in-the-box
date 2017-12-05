# NOTE : while on checkout process the customer will pass by customer/orders/addresses
class Customer::AddressesController < ApplicationController
  attr_reader :address

  authorize_resource class: false
  layout :custom_sublayout
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    @addresses = current_user.addresses
  end

  # NOTE : i'm not sure this is currently in use within our system.
  # - Laurent, 15/09/2017
  def show
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    address.user = current_user

    if address.save
      flash[:success] = I18n.t('edit_address.create_ok')
      redirect_to navigation.back(1)
      return
    end

    current_user.reload
    @addresses = current_user.addresses

    flash[:error] = "#{I18n.t('edit_address.create_ko')} (#{address.errors.full_messages.join(', ')})"
    render :new
  end

  def edit
  end

  def update
    if address.update(address_params)
      flash[:success] = I18n.t('edit_address.update_ok')
      redirect_to navigation.back(1)
      return
    end

    flash[:error] = I18n.t('edit_address.update_ko')
    redirect_to :edit
  end

  def destroy
    address.delete
    redirect_to navigation.back(1)
  end

  private

    def set_address
      @address = current_user.addresses.find(params[:id])
    end

    def address_params
      params.require(:address).permit!
    end

end
