describe Guest::CouponsController, type: :controller do
  render_views

  let(:not_found_image) { Magick::ImageList.new("#{Rails.root}/public/images/no_image_available.jpg").to_blob }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:wechat_referrer_qrcode).and_return(
      BaseService.new.return_with(:success, local_file: "/uploads/referrer/qrcode/test-qrcode.jpg", remote_call: false)
    )
  end

  describe '#flyer' do
    context 'coupon without referrer' do
      let(:coupon) { FactoryGirl.create(:coupon) }
      it 'renders a not found image' do
        get :flyer, coupon_id: coupon
        expect(response.content_type).to eq('image/jpeg')
        expect(response.body).to eq(not_found_image)
      end
    end

    context 'coupon with referrer' do
      let(:coupon) { FactoryGirl.create(:coupon, :with_referrer) }
      it 'renders a the qrcode flyer' do
        get :flyer, coupon_id: coupon
        expect(response.content_type).to eq('image/jpeg')
        expect(response.body).not_to eq(not_found_image)
      end
    end
  end
end
