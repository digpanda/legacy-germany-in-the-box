describe Guest::ReferrersController, type: :controller do
  render_views

  let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }

  describe '#qrcode' do

    before(:each) do
      allow_any_instance_of(described_class).to receive(:wechat_referrer_qrcode).and_return(
        BaseService.new.return_with(:success, local_file: "#{Rails.root}/public/uploads/referrer/qrcode/test-qrcode.jpg", remote_call: false)
      )
    end

    subject { get :qrcode, referrer_id: referrer.id }
    it { is_expected.to have_http_status(200) }
  end

end
