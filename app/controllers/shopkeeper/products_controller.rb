class Shopkeeper::ProductsController < ApplicationController

  load_and_authorize_resource

  before_action :set_shop
  before_action :set_product, except: [:index, :new, :create]

  layout :custom_sublayout

  attr_reader :shop, :products, :product

  def index
    @products = current_user.shop.products.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def new
    @product = shop.products.build
  end

  def create
    @product = shop.products.build(product_params)

    if product.save
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to shopkeeper_products_path
      return
    end

    flash[:error] = product.errors.full_messages.join(', ')
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
    # we split up the update into two to avoid conflict
    # on updating the options and suboptions at the same time
    if product.update(product_params_without_option) && product.update(product_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      redirect_to edit_shopkeeper_product_path(product)
      return
    end

    flash[:error] = product.errors.full_messages.first
    redirect_to navigation.back(1)
  end

  def destroy
    if product.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_product)
      redirect_to shopkeeper_shop_path
      return
    end
    flash[:error] = product.errors.full_messages.first
    redirect_to shopkeeper_shop_path
  end

  # TODO : to refactor
  def destroy_variant
    variant = @product.options.find(params[:variant_id])

    ids = variant.suboptions.map { |o| o.id.to_s }

    if @product.skus.detect { |s| s.option_ids.to_set.intersect?(ids.to_set) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      if variant.delete && @product.save
        flash[:success] = I18n.t(:delete_variant_ok, scope: :edit_product_variant)
      else
        flash[:error] = variant.errors.full_messages.first
        flash[:error] ||= @product.errors.full_messages.first
      end
    end
    redirect_to navigation.back(1)
  end

  # TODO : to refactor
  def destroy_option
    if @product.skus.detect { |s| s.option_ids.to_set.include?(params[:option_id]) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      variant = @product.options.find(params[:variant_id])
      option = variant.suboptions.find(params[:option_id])

      if option.delete && variant.save && @product.save
        flash[:success] = I18n.t(:delete_option_ok, scope: :edit_product_variant)
      else
        flash[:error] = option.errors.full_messages.first
        flash[:error] ||= @product.errors.full_messages.first
      end
    end
    redirect_to navigation.back(1)
  end

  private

  # we convert to a hash to avoid to keep the params class even we cloned
  # then we remove the `suboptons_attributes` to have a clean `product_params`
  # this doesn't affect the original object
  # NOTE : since it's converted to an hash, we cannot use symbols anymore
  def product_params_without_option
    product_params.to_h.tap do |product_param|
      product_param.delete("options_attributes")
      # product_param["options_attributes"].each do |key, option_attribute|
      #   unless option_attribute["suboptions_attributes"].nil?
      #     option_attribute.delete("suboptions_attributes")
      #   end
      # end
    end
  end

  # def product_params_without_suboptions
  #   product_params.dup.copy.tap do |product_param|
  #      product_param[:options_attributes] = option_without_suboptions
  #   end
  # end

  def product_params
    # NOTE TODO : THIS WILL BE PLACED WHEN WE DO THE ADMIN SECTION OF PRODUCTS
    # NOTE 2 : THIS LOOKS ACTUALLY COMPLETELY USELESS AT THE END.
    # if current_user.decorate.admin?
    #   params.require(:product)[:category_ids] = [params.require(:product)[:category_ids]] unless params.require(:product)[:category_ids].nil?
    #   shopkeeper_strong_params += [:duty_category, category_ids:[]]
    # end
    params.require(:product).permit!
  end

  def set_shop
    @shop = current_user.shop
  end

  def set_product
    @product = Product.find(params[:product_id] || params[:id])
  end

end
