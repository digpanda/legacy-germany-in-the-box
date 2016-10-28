concerns :shared_errors

root to: 'guest/home#show'

# we load the different routes depending on subsections
draw :app, :admin
draw :app, :customer
draw :app, :guest
draw :app, :shared
draw :app, :shopkeeper

resources :languages, only: [:update] do
end

captcha_route
mount ChinaCity::Engine => '/china_city'
devise_for :users, :controllers => { registrations: "registrations", sessions: "sessions", passwords: "passwords", omniauth_callbacks: "omniauth_callbacks"}

devise_scope :user do
  match 'users/sign_out', via: [:delete],   to: 'sessions#destroy',             as: :signout
  match :cancel_login,    via: [:get],      to: 'sessions#cancel_login',        as: :cancel_login
  match :cancel_signup,   via: [:get] ,     to: 'registrations#cancel_signup',  as: :cancel_signup
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
