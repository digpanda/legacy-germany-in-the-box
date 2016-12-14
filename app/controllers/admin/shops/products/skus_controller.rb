class Admin::Shops::Products::SkusController < Shopkeeper::Products::SkusController

  authorize_resource :class => false

  skip_before_action :breadcrumb_shopkeeper_products, :breadcrumb_shopkeeper_edit_product,
                     :breadcrumb_shopkeeper_product_skus, :breadcrumb_shopkeeper_product_edit_sku
  before_action :set_shop
  before_action :breadcrumb_admin_shops, :breadcrumb_admin_shop_products, :breadcrumb_admin_edit_product, :breadcrumb_admin_product_skus
  before_action :breadcrumb_admin_product_edit_sku, only: [:edit]
  attr_reader :shop

  # NOTE : we inherit from the Shopkeeper side
  # because the methods are all the same for now
  # this is a very rare case.
  # we hook the way to setup variables and some redirections

  # for some unknown reason it couldn't get the super by itself
  # so we at the redclare this method
  def clone
    super
  end

  private

  def redirection_after_update
    redirect_to admin_shop_product_skus_path(shop, product)
  end

  def set_shop
    @shop = Shop.find(params[:shop_id] || params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id] || params[:id])
  end

  def set_variant
    @variant = product.options.find(params[:variant_id] || params[:id])
  end

end
