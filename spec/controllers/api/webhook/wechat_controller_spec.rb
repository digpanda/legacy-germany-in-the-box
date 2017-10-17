describe Api::Webhook::WechatController, type: :controller do

  render_views # jbuilder requirement

  describe '#create' do

    let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }
    let(:user) { FactoryGirl.create(:customer) }

    scenario 'confirm a qrcode scan and bind the user with the referrer' do

      # we fake the whole WeChatUserSolver and API call
      allow_any_instance_of(WechatUserSolver).to receive(:resolve).and_return(service_success(customer: user))

      post :create, wechat_valid_qrcode_scan_params(referrer).to_xml(root: :xml, skip_types: true)
      expect(response.body).to eql?('success')
      # expect(response.body).to eq('success') # for now the system answers with that
      expect(user.parent_referrer).to eq(referrer) # binding successful ?

    end

  end

end

# the username linked data will be stubbed above
# so it doesn't matter if they are valid
def wechat_valid_qrcode_scan_params(referrer)
  {
    'ToUserName'   => 'FAKE_VALID_USERNAME',
    'FromUserName' => 'FAKE_VALID_FROMUSERNAME',
    'CreateTime'   => '1501489767',
    'MsgType'      => 'event',
    'Event'        => 'SCAN',
    'EventKey'     => "{\"referrer\":{\"reference_id\":\"#{referrer.reference_id}\"} }",
    'Ticket'       => 'gQH18DwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyUDNiRDF4R29ibC0xMDAwMDAwN04AAgR_jHhZAwQAAAAA'
  }
end
