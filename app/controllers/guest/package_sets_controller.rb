class Guest::PackageSetsController < ApplicationController
  attr_reader :package_set, :category, :brand

  before_filter do
    restrict_to :customer
  end

  before_action :set_package_set, :set_category, :set_brand

  before_action :breadcrumb_package_set, only: [:show]
  before_action :breadcrumb_package_sets, only: [:index]
  before_action :freeze_header

  def show
  end

  def categories
  end

  # we show the list of package by category
  # otherwise we redirect the user to the /categories area
  def index
    @query = PackageSet.active.order_by(position: :asc)

    # category querying
    if category
      @query = @query.with_category(category)
    # category was not defined because
    # it doesn't not match with any existing one
    elsif params[:category_slug] == 'all'
      @query = @query
    else
      redirect_to guest_package_sets_categories_path
      return
    end

    # brand querying
    if brand
      @query = @query.with_brand(brand)
    end

    @package_sets = @query.all
  end

  # we use the package set and convert it into an order
  def update
    # we first compose the whole order
    package_set.package_skus.each do |package_sku|
      # we also lock each order item we generate
      order_maker.add(package_sku.sku, package_sku.product, package_sku.quantity,
                      price: package_sku.price,
                      taxes: package_sku.taxes_per_unit,
                      shipping: package_set.shipping_cost, # total shipping cost of the order
                      locked: true,
                      package_set: package_sku.package_set)
    end
    # we first empty the cart manager to make it fresh
    # cart_manager.empty! <-- to avoid multiple package order
    cart_manager.store(order)
    redirect_to customer_cart_path
  end

  private

    # to be abstracted somewhere else
    def order_maker
      @order_maker ||= OrderMaker.new(order)
    end

    def order
      @order ||= cart_manager.order(shop: package_set.shop)
    end
    # end of abstraction

    def set_package_set
      @package_set = PackageSet.find(params[:id]) unless params[:id].nil?
    end

    # for filtering (optional)
    def set_category
      @category = Category.where(slug: params[:category_slug]).first if params[:category_slug]
    end

    # for filtering (optional)
    # NOTE : we avoid crashing it if not found
    def set_brand
      @brand = Brand.where(id: params[:brand_id]).first if params[:brand_id]
    end
end
