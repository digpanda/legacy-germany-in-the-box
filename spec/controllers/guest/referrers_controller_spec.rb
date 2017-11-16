describe Guest::ReferrersController, type: :controller do
  render_views

  let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }

  describe '#qrcode' do

    before(:each) do
      allow_any_instance_of(WeixinReferrerQrcode).to receive(:local_file).and_return("#{Rails.root}/public/samples/images/random/rectangle.png")
    end

    subject { get :qrcode, referrer_id: referrer.id }
    it { is_expected.to have_http_status(200) }
  end

end
