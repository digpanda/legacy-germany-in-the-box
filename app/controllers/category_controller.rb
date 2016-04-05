require 'will_paginate/array'

class CategoryController < ApplicationController

  include FunctionCache

  before_action :set_category, except: [:index]

  before_action :authenticate_user!, except: [:list_products, :show_products]

  load_and_authorize_resource

  def show_products
    @products = @category.products.paginate( :page => (params[:page] ? params[:page].to_i : 1), :per_page => Rails.configuration.limit_for_products_search)
    @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@products)

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