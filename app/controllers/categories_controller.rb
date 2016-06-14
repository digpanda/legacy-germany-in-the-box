require 'will_paginate/array'

class CategoriesController < ApplicationController

  include AppCache

  before_action :set_category, except: [:index]

  before_action :authenticate_user!, except: [:show, :list_products, :show_products]

  load_and_authorize_resource

  layout :custom_sublayout, only: [:index]

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, only: [:show]

  def show
  end

  def index
    @root_categories = AppCache.get_root_level_categories_from_cache
    render :index
  end

  def show_products
  end

  def list_products
  end

  private

  def set_category
    @category = Category.find(params[:id])
    @shops = @category.shops
    @featured_shop = @category.shops.first
    @casual_shops = @category.shops
    @casual_shops.shift
  end

  def categories_path
    categories_path
  end

end