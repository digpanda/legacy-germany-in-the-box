class Admin::CategoriesController < ApplicationController

  load_and_authorize_resource

  before_action :set_address, only: [:show]

  layout :custom_sublayout

  attr_accessor :address

  # TODO : this section has to be done in its integrality
  # we should use the same strategy as we used
  # for coupons and such

  def index
  end

  def show
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

end
