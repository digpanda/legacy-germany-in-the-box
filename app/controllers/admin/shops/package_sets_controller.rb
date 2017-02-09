class Admin::Shops::PackageSetsController < ApplicationController

  include DestroyImage

  attr_reader :shop, :package_set, :package_sets

  authorize_resource :class => false
  layout :custom_sublayout

  before_action :set_shop
  before_action :set_package_set, :except => [:index, :new, :create]

  before_action :breadcrumb_admin_shops, :breadcrumb_admin_shop_products

  def index
    @package_sets = shop.package_sets.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def new
    @package_set = PackageSet.new
    build_package_skus!
  end

  def create
    @package_set = shop.package_sets.build(package_set_params)
    if package_set.save
      flash[:success] = "Set was created"
      redirect_to admin_shop_package_sets_path(shop)
    else
      flash[:error] = package_set.errors.full_messages.join(', ')

      build_package_skus!
      render :new
    end
  end

  def edit
    build_package_skus!
  end

  def update
    if package_set.update(package_set_params)
      flash[:success] = "Set was updated"
    else
      flash[:error] = package_set.errors.full_messages.join(', ')
    end

    build_package_skus!
    render :edit
  end

  def destroy
    if package_set.destroy
      flash[:success] = "Set was destroyed"
    else
      flash[:error] = package_set.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def package_set_params
    params.require(:package_set).permit!
  end

  def build_package_skus!
    5.times { package_set.package_skus.build }
  end

  def set_shop
    @shop = Shop.find(params[:shop_id] || params[:id])
  end

  def set_package_set
    @package_set = PackageSet.find(params[:package_set_id] || params[:id])
  end

end
