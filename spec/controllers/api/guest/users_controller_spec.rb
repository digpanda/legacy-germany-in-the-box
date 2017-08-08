describe Api::Guest::UsersController, type: :controller do

  render_views # jbuilder requirement

  describe '#unknown_by_email' do

    context 'existing email' do

      let(:current_user) { FactoryGirl.create(:customer) }

      it 'finds the email' do

        params = { 'shop_application' => { 'email' => current_user.email } }
        get :unknown_by_email, params

        expect(response).to have_http_status(:unprocessable_entity)
        expect_json(success: false)

      end

    end

    context 'unexisting email' do

      it 'does not find the email' do

        params = { 'shop_application' => { 'email' => 'random@email.com' } }
        get :unknown_by_email, params

        expect_json(success: true)

      end

    end

  end

  describe '#find_by_email' do

    context 'existing email' do

      let(:current_user) { FactoryGirl.create(:customer) }

      it 'finds the email' do

        params = { 'shop_application' => { 'email' => current_user.email } }
        get :find_by_email, params

        expect_json(success: true)

      end

    end

    context 'unexisting email' do

      it 'does not find the email' do

        params = { 'shop_application' => { 'email' => 'random@email.com' } }
        get :find_by_email, params

        expect(response).to have_http_status(:not_found)
        expect_json(success: false)

      end

    end

  end

end
