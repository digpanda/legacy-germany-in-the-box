class Admin::Shops::Products::VariantsController < ApplicationController

  MAX_NEW_VARIANTS = 10.freeze
  MAX_NEW_OPTIONS = 10.freeze

  attr_reader :shop, :product, :variants, :variant

  authorize_resource class: false
  before_action :set_shop, :set_product
  before_action :set_variant, except: [:index, :create]
  before_action :breadcrumb_admin_shops, :breadcrumb_admin_shop_products, :breadcrumb_admin_edit_product, :breadcrumb_admin_product_variants

  layout :custom_sublayout

  def index
    MAX_NEW_VARIANTS.times { product.options.build }
    @variants = product.options
    variants.map do |variant|
      MAX_NEW_OPTIONS.times { variant.suboptions.build }
    end
  end

  # NOTE : we use the create method but it is actually an update one.
  # we should never recreate the variants because they are linked to skus and such in our system.
  # also the creation is systematically multiple so we use this method for everything.
  # we use the `create` route to avoid the `update` forces us to provide an id.
  # we cannot provide it because of the multiple-update.
  # there may be a better solution but this one does the work for now.
  def create
    remove_empty_options_from_params!
    remove_empty_variants_from_params!
    # we split up the update into two to avoid conflict
    # on updating the options and suboptions at the same time
    if product.update(product_params_without_option) && product.update(product_params)
      ensure_suboption_saved!
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
      # if the user didn't add any sku yet, we redirect him automatically
      # to add some after creating those
      redirection_after_update
      return
    end

    flash[:error] = product.errors.full_messages.first
    redirect_to navigation.back(1)
  end

  def destroy
    ids = variant.suboptions.map { |o| o.id.to_s }

    if product.skus.detect { |s| s.option_ids.to_set.intersect?(ids.to_set) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      if variant.delete && product.save
        flash[:success] = I18n.t(:delete_variant_ok, scope: :edit_product_variant)
      else
        flash[:error] = variant.errors.full_messages.first
        flash[:error] ||= product.errors.full_messages.first
      end
    end
    redirect_to navigation.back(1)
  end

  # we did not put this destroy into a new controller
  # because this is the only method used to manipulate suboption directly so far
  # we might need to move it if more methods are made.
  # we turned the `suboption` into `option` because the new differenciation between option / suboption
  # is actually variant / option which's more logical.
  def destroy_option
    if product.skus.detect { |s| s.option_ids.to_set.include?(params[:option_id]) }
      flash[:error] = I18n.t(:sku_dependent, scope: :edit_product_variant)
    else
      variant = product.options.find(params[:variant_id])
      option = variant.suboptions.find(params[:option_id])

      if option.delete && variant.save && @product.save
        flash[:success] = I18n.t(:delete_option_ok, scope: :edit_product_variant)
      else
        flash[:error] = option.errors.full_messages.join(', ')
        flash[:error] ||= product.errors.full_messages.join(', ')
      end
    end
    redirect_to navigation.back(1)
  end

  private

  def redirection_after_update
    redirect_to navigation.back(1)
  end

  # for some reason mongoid struggle to update / save the suboptions
  # when it's updated in the attributes
  # we make sure it occurs by saving each one manually
  def ensure_suboption_saved!
    product.options.each do |option|
      option.suboptions.each do |suboption|
        suboption.save
      end
    end
  end

  # we convert to a hash to avoid to keep the params class even we cloned
  # then we remove the `suboptons_attributes` to have a clean `product_params`
  # this doesn't affect the original object
  # NOTE : since it's converted to an hash, we cannot use symbols anymore
  def product_params_without_option
    product_params.to_h.tap do |product_param|
      product_param.delete("options_attributes")
    end
  end

  # remove any empty option from the parameters
  # there will be some which are systematically empty because of the hide / show in front-end
  def remove_empty_options_from_params!
    params.require(:product).require(:options_attributes).each do |key, option|
      option.require(:suboptions_attributes).each do |suboption_key, suboption|
        if suboption[:name]&.empty?
          option.require(:suboptions_attributes).delete(suboption_key)
        end
      end
    end
  end

  # remove any empty variant from the parameters
  # there will be some which are systematically empty because of the hide / show in front-end
  def remove_empty_variants_from_params!
    params.require(:product).require(:options_attributes).each do |key, option|
      if option[:name]&.empty?
        params.require(:product).require(:options_attributes).delete(key)
      end
    end
  end

  def product_params
    params.require(:product).permit!
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
