describe Api::Webhook::WechatController, type: :controller do

  render_views # jbuilder requirement

  describe '#create' do

    let(:referrer) { FactoryGirl.create(:customer, :with_referrer).referrer }
    let(:user) { FactoryGirl.create(:customer, :from_wechat) }

    before(:each) do
      # we fake the whole APIs calls
      allow_any_instance_of(WechatUserSolver).to receive(:resolve).and_return(service_success(customer: user))
      allow_any_instance_of(WechatApiMessenger::Image).to receive(:send).and_return(service_success)
      allow_any_instance_of(WechatApiMessenger::Rich).to receive(:send).and_return(service_success)
      allow_any_instance_of(WechatApiMessenger::Text).to receive(:send).and_return(service_success)
    end

    scenario 'confirm a qrcode scan and bind the user with the referrer' do

      post :create, wechat_valid_qrcode_scan_params(referrer).to_xml(root: :xml, skip_types: true)
      expect(response.body).to eq('success')
      # expect(response.body).to eq('success') # for now the system answers with that
      expect(user.parent_referrer).to eq(referrer) # binding successful ?

    end

    scenario 'receive a qrcode scan but cannot parse the meta data' do

      post :create, wechat_valid_qrcode_scan_wrong_params(referrer).to_xml(root: :xml, skip_types: true)
      expect_json(success: false)

    end

    scenario 'reply when the user writes something to the bot' do
      post :create, text_params.to_xml(root: :xml, skip_types: true)
      expect(response.body).to eq('success')
    end

    scenario 'reply when the user uses an action to the bot' do
      post :create, event_params.to_xml(root: :xml, skip_types: true)
      expect(response.body).to eq('success')
    end

  end

end

# the username linked data will be stubbed above
# so it doesn't matter if they are valid
def text_params
  {
    'ToUserName'   => 'FAKE_VALID_USERNAME',
    'FromUserName' => 'FAKE_VALID_FROMUSERNAME',
    'CreateTime'   => '1501489767',
    'MsgType'      => 'text',
    'Content'        => 'ping', # will send a pong
  }
end

# the username linked data will be stubbed above
# so it doesn't matter if they are valid
def event_params
  {
    'ToUserName'   => 'FAKE_VALID_USERNAME',
    'FromUserName' => 'FAKE_VALID_FROMUSERNAME',
    'CreateTime'   => '1501489767',
    'MsgType'      => 'event',
    'Event'        => 'click',
    'EventKey'        => 'ping', # will send a pong
  }
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

def wechat_valid_qrcode_scan_wrong_params(referrer)
  {
    'ToUserName'   => 'FAKE_VALID_USERNAME',
    'FromUserName' => 'FAKE_VALID_FROMUSERNAME',
    'CreateTime'   => '1501489767',
    'MsgType'      => 'event',
    'Event'        => 'SCAN',
    'EventKey'     => "\"referrer\":{\"reference_id\":\"#{referrer.reference_id}\"} }",
    'Ticket'       => 'gQH18DwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyUDNiRDF4R29ibC0xMDAwMDAwN04AAgR_jHhZAwQAAAAA'
  }
end
