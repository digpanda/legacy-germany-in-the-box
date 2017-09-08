describe Guest::CouponsController, type: :controller do
  render_views

  let(:coupon) { FactoryGirl.create(:coupon) }

  describe '#flyer' do
    subject { get :flyer, coupon_id: coupon }
    it { is_expected.to render_template('flyer') }
  end
end
NOTE : cancelled temporarily
