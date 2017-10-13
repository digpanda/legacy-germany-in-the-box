# Admin related
namespace :admin do

  match 'links/wechat' => 'links#wechat', :via => :get
  resources :links do
  end

  resources :duty_categories do
  end

  resources :charts do
  end

end
