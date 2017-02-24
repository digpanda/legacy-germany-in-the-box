class Guest::CouponsController < ApplicationController

  attr_accessor :coupon, :coupons

  authorize_resource :class => false
  before_action :set_coupon

  def flyer
    send_data Flyer.new.process_steps(coupon).image.to_blob, :stream => "false", :filename => "test.jpg", :type => "image/jpeg", :disposition => "inline"
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id] || params[:coupon_id])
  end

end
