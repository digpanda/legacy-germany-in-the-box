# Customer related
namespace :customer do

  resource :referrer, :controller => 'referrer' do
  end

  resource :cart, :controller => 'cart' do
  end

  namespace :checkout do
    namespace :callback do

      resource :wirecard, :controller => 'wirecard' do
        post :cancel
        post :processing
        post :success
        post :fail

        get :cancel
        get :processing
        get :success
        get :fail
      end

      resource :alipay, :controller => 'alipay' do
      end

    end
  end

  resource :checkout, :controller => 'checkout' do
    get :payment_method
    post :gateway
  end

  resource :account, :controller => 'account' do
  end


  resources :addresses do
  end

  resources :orders  do
    patch :continue

    resource :customer, :controller => 'orders/customer' do
    end

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
