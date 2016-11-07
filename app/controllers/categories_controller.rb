require 'will_paginate/array'

class CategoriesController < ApplicationController

  before_action :set_category, except: [:index]

  before_action :authenticate_user!, except: [:list_products, :show_products]

  load_and_authorize_resource

  layout :custom_sublayout, only: [:index]

  # for shopkeepers and stuff (to move soon and then remove this shit controller)
  def list_products
  end

  def set_category
    @category = Category.find(params[:id])
    @shops = @category.can_buy_shops
    @featured_shop = @category.can_buy_shops.uniq.compact.first
    @casual_shops = @category.can_buy_shops.uniq.compact # because it can fetch duplicate for no fucking reason.
    @casual_shops.shift
  end

end
