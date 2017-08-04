class Admin::Shops::ProductsController < ApplicationController
  CSV_ENCODE = "UTF-8".freeze

  attr_reader :shop, :products, :product

  authorize_resource class: false

  before_action :set_shop
  before_action :set_product, except: [:index, :new, :create]
  before_action :breadcrumb_admin_shops, :breadcrumb_admin_shop_products
  before_action :breadcrumb_admin_edit_product, only: [:edit]
  before_action :recover_categories_from_ids, :recover_duty_category_from_code, only: [:create, :update]

  layout :custom_sublayout

  def index
    respond_to do |format|
      format.html do
        @products = shop.products.order_by(c_at: :desc).full_text_search(query, match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10)
      end
      format.csv do
        @products = shop.products.order_by(c_at: :desc)
        render text: ProductSkusFormatter.new(products).to_csv.encode(CSV_ENCODE),
               type: "text/csv; charset=#{CSV_ENCODE}; header=present",
               disposition: 'attachment'
      end
    end
  end

  def new
    @product = shop.products.build
  end

  def create
    @product = shop.products.build(product_params)
    if product.save
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
    else
      flash[:error] = product.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def edit
  end

  def update
    if product.update(product_params)
      flash[:success] = I18n.t(:update_ok, scope: :edit_product)
    else
      flash[:error] = product.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if product.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_product)
    else
      flash[:error] = product.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def highlight
    product.highlight = true
    product.save
    redirect_to navigation.back(1)
  end

  def regular
    product.highlight = false
    product.save
    redirect_to navigation.back(1)
  end

  def approve
    product.approved = Time.now.utc
    product.save
    redirect_to navigation.back(1)
  end

  def disapprove
    product.approved = nil
    product.save
    redirect_to navigation.back(1)
  end

  private

    def query
      params.require(:query) if params[:query].present?
    end

    def product_params
      params.require(:product).permit!
    end

    # we basically get an array of ids and replace it by the entire model
    # this is to go well with the automatic update provided by rails
    def recover_categories_from_ids
      product_params.require(:categories).map! do |category_id|
        Category.where(_id: category_id).first
      end.compact
    end

    def recover_duty_category_from_code
      product_params.require(:duty_category).tap do |duty_category_code|
        product_params[:duty_category] = DutyCategory.where(code: duty_category_code).where(tax_rate: {'$gt': 0.0}).first
      end
    end

    def set_shop
      @shop = Shop.find(params[:shop_id] || params[:id])
    end

    def set_product
      @product = Product.find(params[:product_id] || params[:id])
    end
end
