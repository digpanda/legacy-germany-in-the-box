class Shopkeeper::WirecardsController < ApplicationController

  authorize_resource :class => false
  before_action :set_shop

  attr_reader :shop, :wirecard

  def apply
    @checkout_portal = Wirecard::Merchant.checkout_portal(shop)
  end

  private

  def set_shop
    @shop ||= current_user.shop
  end
end
