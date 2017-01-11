require 'rails_helper'

describe CouponHandler do
  before :each do
    @order = Order.create(status: :new)
    @order_2 = Order.create(status: :new)
    @coupon = Coupon.create(code: 'code', discount: 10.0, unit: :percent, unique: true)
    @reusable_coupon = Coupon.create(code: 'code2', discount: 10.0, unit: :percent, unique: false)
  end

  it "should apply and remove the coupon from an order" do
    CouponHandler.new(@coupon, @order).apply
    expect(@order.coupon).to eq(@coupon)
    CouponHandler.new(@coupon, @order).unapply
    expect(@order.coupon).to be(nil)
  end

  it "shouldn't apply to more than one order when is unique" do
    CouponHandler.new(@coupon, @order).apply
    expect(@order.coupon).to eq(@coupon)
    CouponHandler.new(@coupon, @order_2).apply
    expect(@order_2.coupon).to be(nil)
  end

  it "should apply multiple times if it is not unique" do
    CouponHandler.new(@reusable_coupon, @order).apply
    expect(@order.coupon).to eq(@reusable_coupon)
    @coupon.update(last_used_at: Time.now)
    CouponHandler.new(@reusable_coupon, @order_2).apply
    expect(@order_2.coupon).to eq(@reusable_coupon)
  end

  it "should apply after one day of appliance without usage even if it is unique" do
    CouponHandler.new(@coupon, @order).apply
    expect(@order.coupon).to eq(@coupon)
    @coupon.update(last_applied_at: Time.now.yesterday)
    CouponHandler.new(@coupon, @order_2).apply
    expect(@order_2.coupon).to eq(@coupon)
  end

  it "should not apply after being used and being unique" do
    CouponHandler.new(@coupon, @order).apply
    expect(@order.coupon).to eq(@coupon)
    @coupon.update(last_applied_at: Time.now.yesterday, last_used_at: Time.now)
    CouponHandler.new(@coupon, @order_2).apply
    expect(@order_2.coupon).to be(nil)
  end
end
