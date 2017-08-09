class Admin::BrandsController < ApplicationController
  attr_reader :brand, :brands

  authorize_resource class: false
  before_action :set_brand, except: [:index, :new, :create]

  before_action :breadcrumb_admin_brands, except: [:index]
  before_action :breadcrumb_admin_brand, only: [:edit, :show]
  before_action :breadcrumb_admin_brand_edit, only: [:edit]

  layout :custom_sublayout

  def index
    @brands ||= Brand.order_by(position: :asc).all
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.create(brand_params)
    if brand.errors.empty?
      flash[:success] = 'The brand was created.'
      redirect_to admin_brands_path
    else
      flash[:error] = "The brand was not created (#{brand.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def edit
  end

  def update
    if brand.update(brand_params)
      flash[:success] = 'The brand was updated.'
      redirect_to admin_brands_path
    else
      flash[:error] = "The brand was not updated (#{brand.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def destroy
    if brand.destroy
      flash[:success] = 'The brand account was successfully destroyed.'
    else
      flash[:error] = "The brand was not destroyed (#{brand.errors.full_messages.join(', ')})"
    end
    redirect_to admin_brands_path
  end

  private

    def set_brand
      @brand ||= Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit!
    end
end
