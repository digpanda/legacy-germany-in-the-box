class Shopkeeper::PaymentsController < ApplicationController

  authorize_resource :class => false
  layout :custom_sublayout, only: [:index]
  before_action :set_shop

  attr_reader :shop

  def index
  end

  private

  def set_shop
    @shop ||= current_user.shop
  end
end
