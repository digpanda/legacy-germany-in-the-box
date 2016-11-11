# focus on the variant (known as option at the database level)
# this is an embedded collection within the product model used on the skus
class Shopkeeper::Products::VariantsController < ApplicationController

  authorize_resource :class => false

  before_action :set_shop, :set_product
  before_action :set_variant, except: [:index]

  layout :custom_sublayout

  attr_reader :shop, :product, :variants, :variant

  def index
    @variants = product.options
  end

  # NOTE : we use the create method but it is actually an update one.
  # we should never recreate the variants because they are linked to skus and such in our system.
  # also the creation is systematically multiple so we use this method for everything.
  # we use the `create` route to avoid the `update` forces us to provide an id.
  # we cannot provide it because of the multiple-update.
  # there may be a better solution but this one does the work for now.
  def create
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

  # we did not put this destroy into a new controller
  # because this is the only method used to manipulate suboption directly so far
  # we might need to move it if more methods are made.
  def destroy_suboption
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
    end
  end

  def product_params
    params.require(:product).permit!
  end

  def set_shop
    @shop = current_user.shop
  end

  def set_product
    @product = Product.find(params[:product_id] || params[:id])
  end

  def set_variant
    @variant = product.options.find(params[:variant_id] || params[:id])
  end

end
