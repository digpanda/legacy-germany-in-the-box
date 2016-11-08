# Guest related
namespace :guest do

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
    get :fees
    get :home
  end

  resource :home, :controller => 'home' do
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

  resources :categories do
  end

  resources :shops do
  end

  resource :products_highlight, :controller => 'products_highlight' do
  end

  resources :products  do
  end

  resources :shop_applications, :only => [:new, :create] do # maybe it will become shops/applications at some point
  end

end
