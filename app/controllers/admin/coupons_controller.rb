class Admin::CouponsController < ApplicationController

  attr_accessor :coupon, :coupons

  authorize_resource :class => false
  before_action :set_coupon, :except => [:index, :create, :new]

  before_action :breadcrumb_admin_coupons, :except => [:index]
  before_action :breadcrumb_admin_coupon, only: [:show, :edit]
  before_action :breadcrumb_admin_coupon_new, only: [:new]
  before_action :breadcrumb_admin_coupon_edit, only: [:edit]

  layout :custom_sublayout

  def index
    @coupons = Coupon.order_by(:c_at => :desc).full_text_search(params[:query], match: :all, allow_empty_search: true).paginate(:page => current_page, :per_page => 10)
  end

  def new
    @coupon = Coupon.new
  end

  def show
  end

  def create
    @coupon = Coupon.create(coupon_params)
    if coupon.errors.empty?
      flash[:success] = "The coupon was created."
      redirect_to admin_coupons_path
    else
      flash[:error] = "The coupon was not created (#{coupon.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def edit
  end

  def update
    clean_referrer!
    clean_shop!
    if coupon.update(coupon_params)
      flash[:success] = "The coupon was updated."
      redirect_to admin_coupons_path
    else
      flash[:error] = "The coupon was not updated (#{coupon.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def cancel
    coupon.cancelled_at = Time.now
    if coupon.save
      flash[:success] = "The coupon was cancelled"
    else
      flash[:error] = "The coupon was not cancelled (#{coupon.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def approve
    coupon.cancelled_at = nil
    if coupon.save
      flash[:success] = "The coupon was approved"
    else
      flash[:error] = "The coupon was not approved (#{coupon.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def destroy
    if coupon.destroy
      flash[:success] = "The coupon account was successfully destroyed."
    else
      flash[:error] = "The coupon was not destroyed (#{coupon.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id] || params[:coupon_id])
  end

  def clean_referrer!
    coupon_params[:referrer] = nil if coupon_params[:referrer].empty?
  end

  def clean_shop!
    coupon_params[:shop] = nil if coupon_params[:shop].empty?
  end

  def coupon_params
    params.require(:coupon).permit!
  end

end
