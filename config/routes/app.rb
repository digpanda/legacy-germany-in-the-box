#if Rails.env.production?
  concerns :shared_errors
#end

# We should improve this by putting it into a home_controller with index
root to: 'pages#home'

resources :languages, only: [:update] do
end

captcha_route
mount ChinaCity::Engine => '/china_city'
devise_for :users, :controllers => { registrations: "registrations", sessions: "sessions", omniauth_callbacks: "omniauth_callbacks"}

devise_scope :user do
  concerns :shared_user
end

resource :page do
  concerns :shared_page
end

namespace :admin do
  resources :orders do
  end
  resources :order_payments do
    post :refund
    post :check
    patch :transaction_id
  end
  resource :settings, only: [:show, :update] do
  end
end

namespace :shopkeeper do

  resources :orders do
    patch :process_order
    patch :shipped
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

  resources :order_items  do
  end

  resources :products  do
  end

  resources :shop_applications, :only => [:new, :create] do # maybe it will become shops/applications at some point
  end

end

# Customer related
namespace :customer do

    resources :orders  do
      resource :border_guru, :controller => 'orders/border_guru' do
        get :tracking_id
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

  match :checkout_success, via: [:post], action: :checkout_success, as: :checkout_success, :on => :collection
  match :checkout_fail, via: [:post], action: :checkout_fail, as: :checkout_fail, :on => :collection
  match :checkout_cancel, via: [:get], action: :checkout_cancel, as: :checkout_cancel, :on => :collection
  match :checkout_processing, via: [:post], action: :checkout_processing, as: :checkout_processing, :on => :collection

  match :download_label,  via: [:get],  action: :download_label,  as: :download_label,  :on => :member

end

resources :categories, only: [:show, :index] do
  concerns :shared_categories
end
