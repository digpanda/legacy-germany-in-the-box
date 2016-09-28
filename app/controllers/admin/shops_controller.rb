class Admin::ShopsController < ApplicationController

  load_and_authorize_resource
  before_action :set_shop, :except => [:index, :emails]

  layout :custom_sublayout

  attr_accessor :shop, :shops

  def index
    @shops = Shop.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def emails
    shops = Shop.all
    shop_emails = shops.reduce([]) { |acc, shop| acc << shop.mail } # could be in model
    shopkeeper_emails = shops.map { |shop| shop.shopkeeper }.reduce([]) { |acc, user| acc << user.email } # could be in model
    @emails_list = (shop_emails + shopkeeper_emails).uniq
  end

  def approve
    @shop.approved = Time.now.utc
    unless @shop.save
      flash[:error] = "Can't approve the shop : #{@shop.errors.full_messages.join(', ')}"
    end
    redirect_to navigation.back(1)
  end

  def disapprove
    @shop.approved = nil
    unless @shop.save
      flash[:error] = "Can't disapprove the shop : #{@shop.errors.full_messages.join(', ')}"
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if shop.addresses.delete_all && shop.destroy
      flash[:success] = I18n.t(:delete_ok, scope: :edit_shops)
    else
      flash[:error] = @shop_application.errors.full_messages.first
    end
    redirect_to navigation.back(1)
  end
  
  private

  def set_shop
    @shop = Shop.find(params[:id] || params[:shop_id])
  end

end
