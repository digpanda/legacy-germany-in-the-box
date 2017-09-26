require 'csv'
require 'net/ftp'

class Shopkeeper::OrdersController < ApplicationController
  attr_reader :order

  authorize_resource class: false
  before_action :set_order, except: [:index]
  before_filter :is_shop_order, except: [:index]

  layout :custom_sublayout, only: [:index]

  def index
    @orders = current_user.shop.orders.bought_or_unverified.order_by(paid_at: :desc, c_at: :desc).paginate(page: current_page, per_page: 10)
  end

  def shipped
    if order.decorate.shippable?
      order.status = :shipped
      order.save
    end

    flash[:success] = I18n.t('notice.order_sent')
    redirect_to navigation.back(1)
  end

  def process_order # can't just put `process` it seems to be reserved term in Rails
    unless order.decorate.processable?
      flash[:error] = I18n.t('notice.order_not_processable')
      redirect_to(:back)
      return
    end

    order.status = :custom_checking
    order.save

    # we go back now
    Notifier::Customer.new(order.user).order_is_being_processed(order)
    flash[:success] = I18n.t('notice.order_processing')
    redirect_to navigation.back(1)
  end

  private

    def set_order
      @order = Order.find(params[:id] || params[:order_id])
    end

    def is_shop_order
      order.shop.id == current_user.shop.id
    end
end
