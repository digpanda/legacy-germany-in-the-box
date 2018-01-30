# Admin related
require 'sidekiq/web'

namespace :admin do

  resource :home, controller: 'home' do
  end

  resource :cache, controller: 'cache' do
  end

  resources :notifications do
  end

  resources :shipping_rates do
  end

  resources :categories do
  end

  resources :coupons do
    patch :cancel
    patch :approve
  end

  resources :banners do
  end

  resources :links do
    get :ping
  end

  resources :payment_gateways do
  end

  resources :notes do
  end

  resources :package_sets do
  end

  resources :brands do
  end

  resources :products do
  end

  resources :services do
    patch :active
    patch :unactive
  end

  resources :inquiries do
    post :setup_referrer_provision
  end

  resources :shops do
    get :emails, on: :collection
    patch :approve
    post :force_login
    patch :disapprove

    resources :package_sets, controller: 'shops/package_sets' do
      patch :active
      patch :unactive
    end

    resources :products, controller: 'shops/products' do
      patch :regular
      patch :highlight
      patch :approve
      patch :disapprove

      resources :variants, controller: 'shops/products/variants' do
        delete '/option/:option_id', action: :destroy_option, as: :destroy_option
      end

      resources :skus, controller: 'shops/products/skus' do
        patch :clone
      end

    end

  end

  resources :shop_applications do
  end

  match 'orders/ongoing' => 'orders#ongoing', :via => :get
  match 'orders/official_bills' => 'orders#official_bills', :via => :get

  resources :orders do
    patch :shipped
    patch :terminate
    resources :addresses, controller: 'orders/addresses' do
    end
    resources :order_trackings, controller: 'orders/order_trackings' do
      patch :refresh
      get :public_tracking
    end
  end

  resources :carts do
  end

  resources :order_items do
    patch :refresh_referrer_rate
  end

  resource :account, controller: 'account' do
  end

  resources :referrers do
    post :coupon

    resources :provision_operations, controller: 'referrers/provision_operations' do
    end

    resources :provisions, controller: 'referrers/provisions' do
      patch :refresh
    end

  end

  resources :referrer_groups do
  end

  resources :users do
    get :emails, on: :collection
    patch :set_as_referrer
    patch :banish
    post :force_login
  end

  resources :order_payments do
    post :refund
    post :check
    patch :transaction_id
  end

  resources :settings do
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
