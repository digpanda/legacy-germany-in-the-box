#if Rails.env.production?
  concerns :shared_errors
#end

# We should improve this by putting it into a home_controller with index
root to: 'pages#home'

resources :languages, only: [:update] do
end

captcha_route
mount ChinaCity::Engine => '/china_city'
devise_for :users, :controllers => { registrations: "registrations", sessions: "sessions", passwords: "passwords", omniauth_callbacks: "omniauth_callbacks"}

devise_scope :user do
  concerns :shared_user
end

resource :page do
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

# Admin related
namespace :admin do
  resources :coupons do
    patch :cancel
    patch :approve
  end
  resources :payment_gateways do
  end
  resources :notes do
  end
  resources :shops do
    get :emails, on: :collection
    patch :approve
    patch :disapprove
  end
  resources :shop_applications do
  end
  resources :orders do
    patch :force_get_shipping
  end
  resource :account, :controller => 'account' do
  end
  resources :users do
  end
  resources :order_payments do
    post :refund
    post :check
    patch :transaction_id
  end
  resource :settings, only: [:show, :update] do
  end
end

# Shopkeeper related
namespace :shopkeeper do

  resources :orders do
    patch :process_order
    patch :shipped
  end

  resource :account, :controller => 'account' do
  end

  resources :payments do
  end

  resources :supports do
  end

  resource :wirecard do
    get :apply, :on => :member
  end

end

resources :addresses, except: [:new, :edit] do
end

resources :products, except: [:index, :new] do
  concerns :shared_products
end

resources :users do
  concerns :shared_users
end

resources :shops, except: [:new, :edit, :create] do
  concerns :shared_shops
end

resources :shop_applications, except: [:edit, :update] do
end

# Guest related
namespace :guest do

  resource :feedback, :controller => 'feedback' do
    get :product_suggestions
    get :payment_speed_report
    get :bug_report
    get :return_application
    get :overall_rate
  end

  resources :order_items  do
  end

  resources :products  do
  end

  resources :shop_applications, :only => [:new, :create] do # maybe it will become shops/applications at some point
  end

end

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

# Shared related
namespace :shared do
  resources :orders do
    get   :bill
    patch :cancel
  end
  resources :notifications do
  end

end

resources :orders, only: [:destroy, :show] do

  concerns :shared_orders

  # match :checkout_success, via: [:post], action: :checkout_success, as: :checkout_success, :on => :collection
  # match :checkout_fail, via: [:post], action: :checkout_fail, as: :checkout_fail, :on => :collection
  # match :checkout_cancel, via: [:get], action: :checkout_cancel, as: :checkout_cancel, :on => :collection
  # match :checkout_processing, via: [:post], action: :checkout_processing, as: :checkout_processing, :on => :collection

  match :download_label,  via: [:get],  action: :download_label,  as: :download_label,  :on => :member

end

resources :categories, only: [:show, :index] do
  concerns :shared_categories
end
