# Customer related
namespace :customer do

  resource :cart, :controller => 'cart' do
  end

  resource :checkout, :controller => 'checkout' do
    get :payment_method
    post :gateway
    post :processing
    post :success
    post :fail
    get :cancel
  end

  resource :account, :controller => 'account' do
  end

  resources :addresses do
  end

  resources :orders  do
    patch :continue

    resources :addresses, :controller => 'orders/addresses' do
    end
    
    resource :border_guru, :controller => 'orders/border_guru' do
      get :tracking_id
    end
    resource :coupons, :controller => 'orders/coupons' do
    end
  end

  resources :favorites  do
  end

end
