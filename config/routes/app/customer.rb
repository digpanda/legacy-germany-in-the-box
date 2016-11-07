# Customer related
namespace :customer do

  resource :cart, :controller => 'cart' do
  end

  resource :checkout, :controller => 'checkout' do
    get :payment_method
    post :gateway

    post :success
    post :fail
    post :processing
    get :cancel
  end

  resource :account, :controller => 'account' do
  end

  resources :addresses do
  end

  resources :orders  do
    patch :continue

    resource :border_guru, :controller => 'orders/border_guru' do
      get :tracking_id
    end
    resource :coupons, :controller => 'orders/coupons' do
    end
  end

  resources :favorites  do
  end

end
