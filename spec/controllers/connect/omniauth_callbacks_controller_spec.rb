describe Connect::OmniauthCallbacksController, type: :controller do

  describe '#referrer' do

    subject(:user) { FactoryGirl.create(:customer) }
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      # fake omniauth callback
      request.env['omniauth.auth'] = valid_wechat_omniauth_callback
    end

    it 'creates a new referrer and redirects him to fulfil his informations' do

      allow_any_instance_of(WechatApiConnectSolver).to receive(:resolve!).and_return(service_success(customer: user))

      get :referrer, 'code' => 'wechat-code'
      # miss some info from the creation
      # it adds a "?" because it contained get code before
      expect(response).to redirect_to "#{missing_info_customer_account_path}?"
      expect(user.referrer?).to eq(true)

    end

  end

end
