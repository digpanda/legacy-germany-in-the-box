describe Guest::LinksController, type: :controller do
  render_views

  let(:link) { FactoryGirl.create(:link) }
  let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }

  describe '#show' do
    subject { get :show, id: link.id }
    it { is_expected.to redirect_to(link.raw_url) }
  end

  describe '#weixin' do
    subject { get :weixin, link_id: link.id, reference_id: referrer.reference_id }
    it { is_expected.to redirect_to("https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9b33e28c238fd3fd&redirect_uri=https%3A%2F%2Flocal.dev%3A3333%2Fguest%2Flinks%2F#{link.id}%3Freference_id%3D#{referrer.reference_id}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect") }
  end
end
