class Admin::SearchController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout

  def show
  end

  # TODO : could be refactored and better
  def create
    if params[:product_id].present?
      product = Product.where(id: params[:product_id]).first
      if product
        redirect_to edit_admin_shop_product_path(product.shop, product)
        return
      end
    end
    if params[:sku_id].present?
      Product.all.each do |product|
        sku = product.skus.where(id: params[:sku_id]).first
        if sku
          redirect_to edit_admin_shop_product_sku_path(product.shop, product, sku)
          return
        end
      end
    end
    flash[:error] = "We could not find the resource."
    redirect_to navigation.back(1)
  end

  private

end
