# Admin related
namespace :admin do

  resource :exchange_rate, controller: 'exchange_rate' do
  end

  match 'links/wechat' => 'links#wechat', :via => :get
  resources :links do
  end

  resources :duty_categories do
  end

  resources :charts do
  end

end
