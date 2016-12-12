class Admin::Shops::Products::VariantsController < Shopkeeper::Products::VariantsController

  authorize_resource :class => false

  before_action :breadcrumb_admin_shops, :breadcrumb_admin_shop, :breadcrumb_admin_edit_product, :breadcrumb_admin_product_variants

  # NOTE : we inherit from the Shopkeeper side
  # because the methods are all the same for now
  # this is a very rare case.
  # we hook the way to setup variables and some redirections

  private

  def redirection_after_update
    redirect_to navigation.back(1)
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
