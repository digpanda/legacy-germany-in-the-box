require 'rails_helper'

describe CouponHandler, :type => :request do

  let(:order) { FactoryGirl.create(:order, status: :new) }
  let(:second_order) { FactoryGirl.create(:order, status: :new) }

  let(:request) { double('request', url: nil, session: {}, params: {}) }

  let(:identity) { IdentitySolver.new(request, order.user) }
  let(:second_identity) { IdentitySolver.new(request, second_order.user) }

  let(:unique_coupon) { Coupon.create(code: 'code', discount: 10.0, unit: :percent, unique: true) }
  let(:reusable_coupon) { Coupon.create(code: 'code2', discount: 10.0, unit: :percent, unique: false) }

  it "should apply and remove the coupon from an order" do
    CouponHandler.new(identity, unique_coupon, order).apply
    expect(order.coupon).to eq(unique_coupon)
    CouponHandler.new(identity, unique_coupon, order).unapply
    expect(order.coupon).to be(nil)
  end

  it "shouldn't apply to more than one order when is unique" do
    CouponHandler.new(identity, unique_coupon, order).apply
    expect(order.coupon).to eq(unique_coupon)
    CouponHandler.new(second_identity, unique_coupon, second_order).apply
    expect(second_order.coupon).to be(nil)
  end

  it "should apply multiple times if it is not unique" do
    CouponHandler.new(identity, reusable_coupon, order).apply
    expect(order.coupon).to eq(reusable_coupon)
    unique_coupon.update(last_used_at: Time.now)
    CouponHandler.new(second_identity, reusable_coupon, second_order).apply
    expect(second_order.coupon).to eq(reusable_coupon)
  end

  it "should apply after one day of appliance without usage even if it is unique" do
    CouponHandler.new(identity, unique_coupon, order).apply
    expect(order.coupon).to eq(unique_coupon)
    unique_coupon.update(last_applied_at: Time.now.yesterday)
    CouponHandler.new(second_identity, unique_coupon, second_order).apply
    expect(second_order.coupon).to eq(unique_coupon)
  end

  it "should not apply after being used and being unique" do
    CouponHandler.new(identity, unique_coupon, order).apply
    expect(order.coupon).to eq(unique_coupon)
    unique_coupon.update(last_applied_at: Time.now.yesterday, last_used_at: Time.now)
    CouponHandler.new(second_identity, unique_coupon, second_order).apply
    expect(second_order.coupon).to be(nil)
  end
end
