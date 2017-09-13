describe Guest::OrderTrackingsController, type: :controller do
  render_views

  let(:order_tracking) { FactoryGirl.create(:order_tracking) }

  describe '#public_url' do
    subject { get :public_url, order_tracking_id: order_tracking.id }
    it { expect{response}.not_to raise_error }
  end
end
