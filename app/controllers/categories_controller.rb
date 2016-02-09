class CategoriesController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :set_collection, except: [:index]

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