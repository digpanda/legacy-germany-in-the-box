describe Order, :type => :model  do

  describe "with referrer" do

    subject { FactoryGirl.create(:order, :with_referrer_coupon) }

    it "gives a correct provision to referrer" do

      apply_coupon!(subject, subject.coupon)

      subject.status = :paid
      subject.save # this will generate a referrer provision since it's paid

      expect(subject.referrer.provisions.count).to eql(1)
      expect(subject.referrer.provisions.sum(:provision)).to be > 0

    end

    it "adjusts provision depending the order status" do

      apply_coupon!(subject, subject.coupon)

      subject.status = :paid
      subject.save # this will generate a referrer provision since it's paid

      expect(subject.referrer.provisions.count).to eql(1)

      subject.status = :cancelled
      subject.save # this will generate a referrer provision since it's paid

      expect(subject.referrer.provisions.count).to eql(0)

      subject.status = :paid
      subject.save # this will generate a referrer provision since it's paid

      expect(subject.referrer.provisions.count).to eql(1)

    end

  end

end

# we need to apply this library to make it work
# the fact to emulate the creation of a coupon and bind it with an order isn't enough
# there's a lot of calculations going on
# TODO : include the calculations inside the model when a coupon is first
# applied instead of manually launching it ?
def apply_coupon!(order, coupon)
  CouponHandler.new(nil, order.coupon, order).update_order!
  CouponHandler.new(nil, order.coupon, order).update_coupon!
end
