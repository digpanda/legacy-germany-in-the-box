class CategoriesController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :set_collection, except: [:index]


  def show_products_in_category
    @products = @category.products
    @categories_and_children, @categories_and_counters = get_category_values_for_left_menu(@products)

    respond_to do |format|
      format.html { render :index }
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