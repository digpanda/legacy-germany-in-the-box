# Guest related
namespace :guest do

  resource :home, controller: 'home' do
    get :test
    get :weixin
  end

  resource :blank, controller: 'blank' do
  end

  resource :pages do
    get :business_model
    get :shipping_cost
    get :menu
    get :agb
    get :privacy
    get :imprint
    get :saleguide
    get :customer_guide
    get :customer_qa
    get :customer_agb
    get :customer_about
    get :fees
    get :home
    get :publicity
  end

  resources :services do
  end

  resources :inquiries do
  end

  resources :links do
    get :weixin # legacy code
  end

  resources :coupons do
    get :flyer
  end

  resources :referrers do
    get :service_qrcode
    get :customized_qrcode
  end

  resources :order_trackings do
    get :public_url
  end

  resources :order_items  do
  end

  match 'package_sets/categories' => 'package_sets#categories', :via => :get
  resources :package_sets do
    get :promote_qrcode
  end

  resources :brands do
    get :promote_qrcode
  end

  resources :categories do
  end

  resources :shops do
  end

  resources :products  do
  end

  resource :search, controller: 'search' do
  end

  # maybe it will become shops/applications at some point
  resources :shop_applications, only: [:new, :create] do
  end

end
