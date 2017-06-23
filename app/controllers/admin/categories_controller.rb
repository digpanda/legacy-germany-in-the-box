class Admin::CategoriesController < ApplicationController

  include DestroyImage

  attr_accessor :category, :categories

  authorize_resource :class => false

  before_action :set_category, :except => [:index]

  before_action :breadcrumb_admin_categories, :except => [:index]
  before_action :breadcrumb_admin_category, only: [:edit]

  layout :custom_sublayout

  def index
    @categories = Category.order_by(:position => :asc).paginate(:page => current_page, :per_page => 10)
  end

  def edit
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

  def set_category
    @category = Category.find(params[:category_id] || params[:id])
  end

  def category_params
    params.require(:category).permit!
  end

end
