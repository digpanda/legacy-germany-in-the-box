class ShopsController <  ApplicationController

  STRONG_PARAMS = [:shopname, :name, :desc, :logo, :banner, :seal0, :seal1, :seal2, :seal3, :seal4, :seal5, :seal6, :seal7, :philosophy, :stories, :german_essence, :uniqueness, :tax_number, :ustid, :eroi, :min_total, :status, :founding_year, :register, :website, :agb, :fname, :lname, :tel, :mobile, :mail, :function, sales_channels:[]]


  before_action :authenticate_user!, except: [:show]
  before_action :set_shop, :set_category, except: [:index]

  layout :custom_sublayout, only: [:index, :edit_setting, :edit_producer, :show_products]

  load_and_authorize_resource

  before_action :breadcrumb_home, only: [:show]
  before_action :breadcrumb_category, :breadcrumb_shop, only: [:show]

  attr_reader :shop, :shops

  def index
    @shops = Shop.in(shopkeeper: User.where(role: 'shopkeeper').map { |u| u.id} ).all;
  end

  def approve

    @shop.approved = Time.now
    if !@shop.save
      flash[:error] = "Can't approve the shop : #{@shop.errors.full_messages.join(', ')}"
    end

    redirect_to(:back) and return

  end

  def disapprove

    @shop.approved = nil
    if !@shop.save
      flash[:error] = "Can't disapprove the shop : #{@shop.errors.full_messages.join(', ')}"
    end

    redirect_to(:back) and return

  end

  def edit_setting
  end

  def edit_producer
    @producer = shop
  end

  def show_products
  end

  def show
  end

  def update
    sp = shop_params(@shop)

    if shop.agb && shop.update(sp)
      if params[:user_info_edit_part] == :edit_producer.to_s
        flash[:success] = I18n.t(:update_producer_ok, scope: :edit_shop)
      else
        flash[:success] = I18n.t(:update_ok, scope: :edit_shop)
      end

      redirect_to request.referer

    elsif (not shop.agb) && shop.update(sp)
      flash[:success] = I18n.t(:update_agb_ok, scope: :edit_shop)
      redirect_to edit_setting_shop_path(shop, :user_info_edit_part => :edit_shop)
    else
      flash[:error] = shop.errors.full_messages.first
      redirect_to request.referer
    end
  end

  def destroy

    if shop.addresses.delete_all && (shop.bank_account ? shop.bank_account.delete : true) && shop.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_shops)
    else
      flash[:error] = @shop_application.errors.full_messages.first
    end

    redirect_to request.referer
  end

  private

  def set_shop
    @shop = Shop.find(params[:id] || params[:shop_id]).decorate
  end

  def set_category
    @category = @shop.categories.first
  end

  def shop_params(shop)
    delocalize_config = { :min_total => :number }

    unless shop.agb
      params.require(:shop).permit(*STRONG_PARAMS).delocalize(delocalize_config)
    else
      params.require(:shop).permit(*STRONG_PARAMS).except(:agb).delocalize(delocalize_config)
    end
  end
end