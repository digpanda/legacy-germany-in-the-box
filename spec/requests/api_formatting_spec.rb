describe 'api formatting', type: :request  do

  context 'errors rendering' do

    it 'page not found' do

      get '/api/anything'
      expect(response).to have_http_status(:not_found)
      expect_json(success: false, code: 11)

    end

    it 'not authorized' do

      get api_admin_duty_category_path(0)
      expect(response).to have_http_status(:unauthorized)
      expect_json(success: false, code: 7)

    end

  end

end
