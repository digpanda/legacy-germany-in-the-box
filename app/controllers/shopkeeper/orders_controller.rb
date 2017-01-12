require 'csv'
require 'net/ftp'

class Shopkeeper::OrdersController < ApplicationController

  attr_accessor :order

  authorize_resource :class => false
  before_action :set_order, :except => [:index]
  before_filter :is_shop_order, :except => [:index]

  layout :custom_sublayout, only: [:index]

  def index
    @orders = current_user.shop.orders.bought_or_unverified.order_by(:c_at => :desc).paginate(:page => current_page, :per_page => 10)
  end

  def shipped

    if order.decorate.shippable?
      order.status = :shipped
      order.save
      EmitNotificationAndDispatchToUser.new.perform({
                                                        :user => order.user,
                                                        :title => "来因盒通知：付款成功，已通知商家准备发货 （订单号：#{order.id})",
                                                        :desc => "你好，你的订单#{order.id}已成功付款，已通知商家准备发货。若有疑问，欢迎随时联系来因盒客服：customer@germanyinthebox.com。"
                                                    })
    end

    flash[:success] = I18n.t(:order_sent, scope: :notice)
    redirect_to navigation.back(1)

  end

  def process_order # can't just put `process` it seems to be reserved term in Rails

    unless order.decorate.processable?
      flash[:error] = I18n.t(:order_not_processable, scope: :notice)
      redirect_to(:back)
      return
    end

    # we don't forget to change status of orders and such
    # only if everything was a success
    order.status = :custom_checkable
    order.save

    # we go back now
    flash[:success] = I18n.t(:order_processing, scope: :notice)
    redirect_to(:back)
    return

  end

  private

  def set_order
    @order = Order.find(params[:id] || params[:order_id])
  end

  def is_shop_order
    order.shop.id == current_user.shop.id
  end

end
