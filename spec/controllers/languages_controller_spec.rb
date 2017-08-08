describe LanguagesController, type: :controller  do
  render_views # jbuilder requirement

  context 'guest to the website' do

    it 'set the language to chinese' do

      put :update, id: 'zh-CN'
      expect(session[:locale]).to eq('zh-CN')
      expect(response).to redirect_to root_url

    end

    it 'set the language to german' do

      put :update, id: 'de'
      expect(session[:locale]).to eq('de')
      expect(response).to redirect_to root_url

    end

    it 'set a wrong language' do

      put :update, id: 'wrong'
      expect(session[:locale]).not_to eq('wrong')
      expect(response).to have_http_status(:bad_request)

    end
  end
end
