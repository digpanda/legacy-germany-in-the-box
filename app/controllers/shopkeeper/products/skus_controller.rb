class Shopkeeper::Products::SkusController < ApplicationController

  load_and_authorize_resource
  layout :custom_sublayout
  before_action :set_product

  attr_reader :products, :product

  def index
  end

  def show
  end

  def new
    setup_categories_options!
    @sku = Sku.new
  end

  def update
    setup_categories_options!
  end

  private

  def setup_categories_options!
    @customer_categories_options = DutyAndCustomerCategorySelectStore.new(Category.name)
    @duty_categories_options = DutyAndCustomerCategorySelectStore.new(DutyCategory.name)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

end
