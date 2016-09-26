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

  private

  def set_shop
    @shop = Shop.find(params[:id] || params[:shop_id])
  end

end
