class Shopkeeper::WirecardsController < ApplicationController

  load_and_authorize_resource :class => false
  before_action :set_shop

  attr_reader :shop, :wirecard

  def apply
    @wirecard = Wirecard::Merchant.new(shop)
  end

  private

  def set_shop
    @shop ||= current_user.shop
  end
end

