# Customer related
namespace :customer do

  resource :referrer, :controller => 'referrer' do
    get :provision
    get :coupons
  end

  resource :cart, :controller => 'cart' do
  end

  namespace :checkout do
    namespace :callback do

      resource :wirecard, :controller => 'wirecard' do
        post :processing
        post :success
        post :fail
        get :cancel
      end

      resource :alipay, :controller => 'alipay' do
      end

      resource :wechatpay, :controller => 'wechatpay' do
        get :fail
        get :cancel
      end

    end
  end

  resource :checkout, :controller => 'checkout' do
    get :payment_method
    get '/gateways/:payment_method', to: "checkout#gateway", as: "gateway"
    # get :gateway

    # TODO : to remove
    post :processing
    post :success
    post :fail
    get :cancel
    # END REMOVE

  end

  resource :account, :controller => 'account' do
    get :menu
  end

  resource :identity, :controller => 'identity' do
    get :xipost_remote
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
