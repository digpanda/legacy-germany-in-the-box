class Shopkeeper::ShopController < ApplicationController

  load_and_authorize_resource :class => false
  layout :custom_sublayout
  before_action :set_shop

  attr_reader :shop

  def show
  end

  private

  def set_shop
    @shop ||= current_user.shop
  end

end
