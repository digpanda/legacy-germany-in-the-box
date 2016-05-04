Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: "registrations", sessions: "sessions" }

  devise_scope :user do
    match 'users/sign_out', via: [:delete],   to: 'sessions#destroy',             as: :signout
    match :cancel_login,    via: [:get],      to: 'sessions#cancel_login',        as: :cancel_login
    match :cancel_signup,   via: [:get] ,     to: 'registrations#cancel_signup',  as: :cancel_signup
  end

  captcha_route

  mount ChinaCity::Engine => '/china_city'

  root to: 'pages#home'

  resource :page do
    match :agb,         via: [:get],    action: :agb,         as: :agb
    match :privacy,     via: [:get],    action: :privacy,     as: :privacy
    match :imprint,     via: [:get],    action: :imprint,     as: :imprint
    match :saleguide,   via: [:get],    action: :saleguide,   as: :saleguide
    match :fees,        via: [:get],    action: :fees,        as: :fees
    match :home,        via: [:get],    action: :home,        as: :home
  end

  get '/set_session_locale/:locale', to: 'application#set_session_locale', as: 'set_session_locale'

  resources :collections, except: [:new] do
    match 'remove_product/:product_id', via: [:patch],  action: :remove_product,        as: :remove_product_from,       :on => :member
    match 'add_product/:product_id',    via: [:patch],  action: :add_product,           as: :add_product_to,            :on => :member
    match :remove_all_products,         via: [:patch],  action: :remove_all_products,   as: :remove_all_products_from,  :on => :member
    match :add_products,                via: [:patch],  action: :add_products,          as: :add_products_to,           :on => :member
    match :remove_products,             via: [:patch],  action: :remove_products,       as: :remove_products_from,      :on => :member
    match 'toggle_product/:product_id', via: [:get],    action: :toggle_product,        as: :toggle_product_in,         :on => :member
    match :like_collection,             via: [:patch],  action: :like_collection,       as: :like,                      :on => :member
    match :dislike_collection,          via: [:patch],  action: :dislike_collection,    as: :dislike,                   :on => :member

    match 'is_collected/:product_id',         via: [:get],    action: :is_collected,            as: :is_collected,          :on => :collection
    match :create_and_add,                    via: [:post],   action: :create_and_add,          as: :create_and_add,        :on => :collection
    match 'search/:keyword',                  via: [:get],    action: :search,                  as: :search,                :on => :collection
    match :show_my_collections,               via: [:get],    action: :show_my_collections,     as: :show_my,               :on => :collection
    match :show_liked_by_me,                  via: [:get],    action: :show_liked_by_me,        as: :show_liked_by_me,      :on => :collection
    match 'show_user_collections/:user_id',   via: [:get],    action: :show_user_collections,   as: :show_user,             :on => :collection
  end

  namespace :wirecard do
    namespace :webhook do 
      post 'merchant_status_change', action: :merchant_status_change, as: :merchant_status_change
    end
  end

  namespace :admin do
    resources :payments do
    end
  end

  resources :addresses, except: [:new, :edit] do
  end

  resources :products, except: [:index, :new] do
    match 'remove_sku/:sku_id',                     via: [:delete], action: :remove_sku,                  as: :remove_sku,                  :on => :member
    match 'remove_variant/:variant_id',             via: [:delete], action: :remove_variant,              as: :remove_variant,              :on => :member
    match 'remove_option/:variant_id/:option_id',   via: [:delete], action: :remove_option,               as: :remove_option,               :on => :member
    match :get_sku_for_options,                     via: [:get],    action: :get_sku_for_options,         as: :get_sku_for_options,         :on => :member
    match :like,                                    via: [:patch],  action: :like,                        as: :like,                        :on => :member
    match :dislike,                                 via: [:patch],  action: :dislike,                     as: :dislike,                     :on => :member
    match :show_skus,                               via: [:get],    action: :show_skus,                   as: :show_skus,                   :on => :member
    match :skus,                                    via: [:get],    action: :skus,                        as: :skus,                        :on => :member
    match :new_sku,                                 via: [:get],    action: :new_sku,                     as: :new_sku,                     :on => :member
    match :edit_sku,                                via: [:get],    action: :edit_sku,                    as: :edit_sku,                    :on => :member
    match :clone_sku,                               via: [:get],    action: :clone_sku,                   as: :clone_sku,                   :on => :member

    match :autocomplete_product_name,               via: [:get],    action: :autocomplete_product_name,   as: :autocomplete_product_name,   :on => :collection
    match 'search',                                 via: [:get],    action: :search,                      as: :search,                      :on => :collection
    match :popular,                                 via: [:get],    action: :popular,                     as: :popular,                                  :on => :collection
  end

  resources :users do
    match 'search/:keyword',  via: [:get],    action: :search,            as: :search,              :on => :collection

    match :edit_account,      via: [:get],    action: :edit_account,      as: :edit_account,        :on => :member
    match :edit_personal,     via: [:get],    action: :edit_personal,     as: :edit_personal,       :on => :member
    match :edit_bank,         via: [:get],    action: :edit_bank,         as: :edit_bank,           :on => :member
    match :follow,            via: [:patch],  action: :follow,            as: :follow,              :on => :member
    match :unfollow,          via: [:patch],  action: :unfollow,          as: :unfollow,            :on => :member
    match :get_followers,     via: [:get],    action: :get_followers,     as: :get_followers,       :on => :member
    match :get_following,     via: [:get],    action: :get_following,     as: :get_following,       :on => :member

    match :show_orders,       via: [:get],    action: :show_orders,       :controller => :orders,             as: :show_orders,         :on => :member
    match :show_addresses,    via: [:get],    action: :show_addresses,    :controller => :addresses,          as: :show_addresses,      :on => :member
    match :show_collections,  via: [:get],    action: :show_collections,  :controller => :collections,        as: :show_collections,    :on => :member
    match :new_collection,    via: [:get],    action: :new,               :controller => :collections,        as: :new_collection,      :on => :member
    match :edit_collection,   via: [:get],    action: :edit,              :controller => :collections,        as: :edit_collection,     :on => :member
  end

  resources :shops, except: [:new, :edit, :create] do
    match :edit_setting,    via: [:get],    action: :edit_setting,    as: :edit_setting,    :on => :member
    match :edit_producer,   via: [:get],    action: :edit_producer,   as: :edit_producer,   :on => :member
    match :show_products,          via: [:get],    action: :show_products,          as: :show_products,          :on => :member
    match :apply_wirecard,   via: [:get],    action: :apply_wirecard,   as: :apply_wirecard,   :on => :member

    resources :products,    only: [:new]
  end

  resources :shop_applications, except: [:edit, :update] do
    match :is_registered,     via: [:get],  action: :registered?,         as: :is_registered,       :on => :collection
  end

  resources :orders, only: [:destroy, :show] do
    match :add_product,               via: [:patch],        action: :add_product,             as: :add_product_to,              :on => :collection
    match :adjust_products_amount,    via: [:patch],        action: :adjust_products_amount,  as: :adjust_products_amount_in,   :on => :collection
    match :checkout,                  via: [:post],         action: :checkout,                as: :checkout,                    :on => :collection
    match :checkout_success,          via: [:post],         action: :checkout_success,                as: :checkout_success,                    :on => :collection
    match :checkout_fail,             via: [:post],         action: :checkout_fail,                as: :checkout_fail,                    :on => :collection

    match :manage_cart,               via: [:get],          action: :manage_cart,             as: :manage_cart,                 :on => :collection
    match 'set_address/:shop_id/',    via: [:patch, :get],  action: :set_address,             as: :set_address,                 :on => :collection

    match :continue,                  via: [:get],          action: :continue,                as: :continue,                    :on => :member
  end

  resources :categories, only: [:show, :index] do
    match :list_products,   via: [:get],    action: :list_products,               as: :list_products,     :on => :member
    match :show_products,   via: [:get],    action: :show_products,               as: :show_products_in,  :on => :member
  end

end

