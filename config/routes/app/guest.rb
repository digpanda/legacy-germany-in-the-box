# Guest related
namespace :guest do

  resource :home, :controller => 'home' do
    get :wechat_test
  end

  resource :static, :controller => 'static' do
    get :xipost
  end

  resource :pages do
    get :business_model
    get :shipping_cost
    get :sending_guide
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

  resources :coupons do
    get :flyer
  end

  resources :referrers do
    get :qrcode
  end

  resource :feedback, :controller => 'feedback' do
    get :product_suggestions
    get :payment_speed_report
    get :bug_report
    get :return_application
    get :overall_rate
  end

  resources :order_items  do
  end

  match 'package_sets/categories' => 'package_sets#categories', :via => :get
  resources :package_sets do
  end

  resources :categories do
  end

  resources :shops do
  end

  resources :products  do
  end

  resource :search, :controller => 'search' do
  end

  # maybe it will become shops/applications at some point
  resources :shop_applications, only: [:new, :create] do
  end

end
