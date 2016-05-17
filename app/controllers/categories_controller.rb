require 'will_paginate/array'

class CategoriesController < ApplicationController

  include AppCache

  before_action :set_category, except: [:index]

  before_action :authenticate_user!, except: [:list_products, :show_products]

  load_and_authorize_resource

  layout :custom_sublayout, only: [:index]

  def index
    @root_categories = AppCache.get_root_level_categories_from_cache
    render :index
  end

  def show_products
    @products = @category.products.buyable.paginate( :pages => (params[:pages] ? params[:pages].to_i : 1), :per_page => Rails.configuration.limit_for_products_search)
    @categories_and_children, @categories_and_counters = AppCache.get_category_values_for_left_menu(@products)

    respond_to do |format|
      format.html { render 'products/index' }
    end
  end

  def list_products
    if @category
      respond_to do |format|
        format.json {
          render :list_products, :status => :ok
        }
      end
    else
      format.json { render json: { status: :ko }, status: :unprocessable_entity }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

end