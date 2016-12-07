class Admin::CategoriesController < ApplicationController

  authorize_resource :class => false

  before_action :set_address, only: [:show]

  layout :custom_sublayout

  attr_accessor :address

  def index
  end

  def show
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

end
