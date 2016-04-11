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
  
  get '/pages/agb', to: 'pages#agb'
  get '/pages/privacy', to: 'pages#privacy'
  get '/pages/imprint', to: 'pages#imprint'
  get '/pages/saleguide', to: 'pages#saleguide'
  get '/pages/fees', to: 'pages#fees'


  get '/set_session_locale/:locale', to: 'application#set_session_locale', as: 'set_session_locale'

  resources :collections, except: [:new] do
    match 'remove_product/:product_id', via: [:patch],  to: :remove_product,        as: :remove_product_from,       :on => :member
    match 'add_product/:product_id',    via: [:patch],  to: :add_product,           as: :add_product_to,            :on => :member
    match :remove_all_products,         via: [:patch],  to: :remove_all_products,   as: :remove_all_products_from,  :on => :member
    match :add_products,                via: [:patch],  to: :add_products,          as: :add_products_to,           :on => :member
    match :remove_products,             via: [:patch],  to: :remove_products,       as: :remove_products_from,      :on => :member
    match 'toggle_product/:product_id', via: [:get],    to: :toggle_product,        as: :toggle_product_in,         :on => :member
    match :like_collection,             via: [:patch],  to: :like_collection,       as: :like,                      :on => :member
    match :dislike_collection,          via: [:patch],  to: :dislike_collection,    as: :dislike,                   :on => :member

    match 'is_collected/:product_id',         via: [:get],    to: :is_collected,            as: :is_collected,          :on => :collection
    match :create_and_add,                    via: [:post],   to: :create_and_add,          as: :create_and_add,        :on => :collection
    match 'search/:keyword',                  via: [:get],    to: :search,                  as: :search,                :on => :collection
    match :show_my_collections,               via: [:get],    to: :show_my_collections,     as: :show_my,               :on => :collection
    match :show_liked_by_me,                  via: [:get],    to: :show_liked_by_me,        as: :show_liked_by_me,      :on => :collection
    match 'show_user_collections/:user_id',   via: [:get],    to: :show_user_collections,   as: :show_user,             :on => :collection
  end

  resources :addresses, except: [:new, :edit] do
    match :index_customer,      via: [:get],    to: :index_customer,      as: :index_customer,      :on => :member
    match :index_shopkeeper,    via: [:get],    to: :index_shopkeeper,    as: :index_shopkeeper,    :on => :member
  end

  resources :products, except: [:index, :new, :edit] do
    match 'remove_sku/:sku_id',                     via: [:delete], to: :remove_sku,                  as: :remove_sku,                  :on => :member
    match 'remove_variant/:variant_id',             via: [:delete], to: :remove_variant,              as: :remove_variant,              :on => :member
    match 'remove_option/:variant_id/:option_id',   via: [:delete], to: :remove_option,               as: :remove_option,               :on => :member
    match :get_sku_for_options,                     via: [:get],    to: :get_sku_for_options,         as: :get_sku_for_options,         :on => :member
    match :like_product,                            via: [:patch],  to: :like_product,                as: :like_product,                :on => :member
    match :dislike_product,                         via: [:patch],  to: :dislike_product,             as: :dislike_product,              :on => :member

    match :autocomplete_product_name,               via: [:get],    to: :autocomplete_product_name,   as: :autocomplete_product_name,   :on => :collection
    match 'search',                                 via: [:get],    to: :search,                      as: :search,                      :on => :collection
    match 'list_popular_products',                  via: [:get],    to: :list_popular_products,       as: :list_popular,                :on => :collection
  end

  resources :users, except: [:destroy] do
    match 'search/:keyword',  via: [:get],    to: :search,            as: :search,              :on => :collection
    match :reset_password,    via: [:patch],  to: :reset_password,    as: :reset_password,      :on => :collection

    match :edit_account,      via: [:get],    to: :edit_account,      as: :edit_account,        :on => :member
    match :edit_personal,     via: [:get],    to: :edit_personal,     as: :edit_personal,       :on => :member
    match :follow,            via: [:patch],  to: :follow,            as: :follow,              :on => :member
    match :unfollow,          via: [:patch],  to: :unfollow,          as: :unfollow,            :on => :member
    match :get_followers,     via: [:get],    to: :get_followers,     as: :get_followers,       :on => :member
    match :get_following,     via: [:get],    to: :get_following,     as: :get_following,       :on => :member
  end

  resources :shops, except: [:new, :edit, :create, :destroy] do
    match :edit_setting,    via: [:get],    to: :edit_setting,    as: :edit_setting,    :on => :member
    match :edit_producer,   via: [:get],    to: :edit_producer,   as: :edit_producer,   :on => :member
  end

  resources :shop_application, except: [:destroy] do
    match :is_registered,     via: [:get],    to: :registered?,       as: :is_registered,       :on => :collection
  end

  resources :orders, only: [:destroy, :show] do
    match :add_product,               via: [:patch],        to: :add_product,             as: :add_product_to,              :on => :collection
    match :adjust_products_amount,    via: [:patch],        to: :adjust_products_amount,  as: :adjust_products_amount_in,   :on => :collection
    match :checkout,                  via: [:post],         to: :checkout,                as: :checkout,                    :on => :collection
    match :manage_cart,               via: [:get],          to: :manage_cart,             as: :manage_cart,                 :on => :collection
    match 'set_address/:shop_id/',    via: [:patch, :get],  to: :set_address,             as: :set_address,                 :on => :collection

    match :continue,                  via: [:get],          to: :continue,                as: :continue,                    :on => :member
  end

  resources :category, only: [:show, :index] do
    match :list_products,   via: [:get],    to: :list_products,               as: :list_products,     :on => :member
    match :show_products,   via: [:get],    to: :show_products,               as: :show_products_in,  :on => :member
  end

  #resources :docs, only: :show do
 #   get "/docs/:doc" => "docs#show"

end

