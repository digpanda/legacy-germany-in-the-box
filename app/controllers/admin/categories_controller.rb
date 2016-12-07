class Admin::CategoriesController < ApplicationController

  authorize_resource :class => false

  layout :custom_sublayout

  attr_accessor :category, :categories

  def index
    @categories = Category.order_by(:position => :asc).paginate(:page => current_page, :per_page => 10)
  end

  def show
  end

  def update
    if category.update(category_params)
      flash[:success] = "The category was updated."
      redirect_to admin_categories_path
    else
      flash[:error] = "The category was not updated (#{category.errors.full_messages.join(', ')})"
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit!
  end

end
