describe Guest::ReferrersController, type: :controller do
  render_views

  let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }

  describe '#qrcode' do
    subject { get :qrcode, referrer_id: referrer.id }
    it { is_expected.to have_http_status(200) }
  end

end
