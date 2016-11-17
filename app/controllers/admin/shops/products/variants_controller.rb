class Admin::Shops::Products::VariantsController < Shopkeeper::Products::VariantsController

  # MAX_NEW_VARIANTS = 10.freeze
  # MAX_NEW_OPTIONS = 10.freeze

  authorize_resource :class => false

  # before_action :set_shop, :set_product
  # before_action :set_variant, except: [:index, :create]
  #
  # layout :custom_sublayout
  #
  # attr_reader :shop, :product, :variants, :variant

  # NOTE : we inherit from the Shopkeeper side
  # because the methods are pratically all the same
  # this is a very rare case.

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
