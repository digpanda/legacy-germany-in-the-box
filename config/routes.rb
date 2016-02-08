Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: "registrations", sessions: "sessions" }

  devise_scope :user do
    match '/users/sign_out',  via: [:delete],   to: 'sessions#destroy',             as: :signout
    match '/cancel_login',    via: [:delete],   to: 'sessions#cancel_login',        as: :cancel_login
    match '/cancel_signup',   via: [:get] ,     to: 'registrations#cancel_signup',  as: :cancel_signup
  end

  captcha_route

  mount ChinaCity::Engine => '/china_city'

  root to: 'pages#home'

  resources :brands

  resources :collections do
    match 'remove_product/:product_id', via: [:patch],  to: :remove_product,        as: :remove_product_from,       :on => :member
    match 'add_product/:product_id',    via: [:patch],  to: :add_product,           as: :add_product_to,            :on => :member
    match :remove_all_products,         via: [:patch],  to: :remove_all_products,   as: :remove_all_products_from,  :on => :member
    match :remove_products,             via: [:patch],  to: :remove_products,       as: :remove_products_from,      :on => :member
    match 'toggle_product/:product_id', via: [:get],    to: :toggle_product,        as: :toggle_product_in,         :on => :member
    match :like_collection,             via: [:get],    to: :like_collection,       as: :like,                      :on => :member
    match :dislike_collection,          via: [:get],    to: :dislike_collection,    as: :dislike,                   :on => :member

    match 'is_collected/:product_id',   via: [:get],    to: :is_collected,          as: :is_collected,              :on => :collection
    match :create_and_add,              via: [:post],   to: :create_and_add,        as: :create_and_add,            :on => :collection
    match 'search/:keyword',            via: [:get],    to: :search,                as: :search,                    :on => :collection
    match :show_my_collections,         via: [:get],    to: :show_my_collections,   as: :show_my,                   :on => :collection
    match :show_liked_by_me,            via: [:get],    to: :show_liked_by_me,      as: :show_liked_by_me,          :on => :collection
  end

  resources :addresses

  resources :products, except: [:index] do
    match :autocomplete_product_name,   via: [:get],    to: :autocomplete_product_name,   as: :autocomplete_product_name,   :on => :collection
    match :search,                      via: [:post],   to: :search_products,             as: :search,                      :on => :collection
    match :popular_products,            via: [:get],    to: :indexr,                      as: :popular,                     :on => :collection
  end

  resources :users, except: [:destroy]

  resources :shops

  resources :orders, only: [:destroy, :show]

  
  get '/set_session_locale/:locale', to: 'application#set_session_locale', as: 'set_session_locale'

  get '/category/:category_id/products', to: 'products#show_products_in_category', as: 'show_products_in_category'

  get 'profile/:id', to: 'users#pshow', as: "profile"


  post '/orders/add_product/:product_id', to: 'orders#add_product', as: 'add_product_to_order'
  post '/orders/adjust_products_amount', to: 'orders#adjust_products_amount', as: 'adjust_products_amount_in_order'
  post '/orders/checkout', to: 'orders#checkout', as: 'checkout_order'

  get '/orders/cart/manage',to: 'orders#manage_cart', as: 'manage_cart'
  get '/orders/:id/continue', to: 'orders#continue', as: 'continue_order'
  get '/orders/checkout/set_address_payment', to: 'orders#set_address_payment', as: 'set_address_payment'

  get '/get_followers/:id', to: 'users#get_followers'
  get '/get_followings/:id', to: 'users#get_followings'

  get '/products/search/:products_search_keyword' => 'products#search_products'
  get '/users/search/:users_search_keyword' => 'users#search_users'

  post '/getuser', to: 'users#getuserbyemail'
  post '/follow/:id/:target_id', to: 'users#follow'
  post '/unfollow/:id/:target_id', to: 'users#unfollow'
  post '/savecol/:id/:col_id', to: 'users#savecol', as: 'savecoll'
  post '/likecol/:id/:col_id', to: 'users#likecol'
  post '/unsavecol/:id/:col_id', to: 'users#unsavecol', as: 'unsavecoll'
  post '/dislikecol/:id/:col_id', to: 'users#dislikecol'
  post '/saveprod/:id/:prod_id', to: 'users#saveprod', as: 'saveprod'
  post '/likeprod/:id/:prod_id', to: 'users#likeprod'
  post '/unsaveprod/:id/:prod_id', to: 'users#unsaveprod', as: 'unsaveprod'
  post '/dislikeprod/:id/:prod_id', to: 'users#dislikeprod'
  post '/joinprivatechat/:id/:chat_id', to: 'users#joinprivatechat'
  post '/joinpublicchat/:id/:chat_id', to: 'users#joinpublicchat'
  post '/leaveprivatechat/:id/:chat_id', to: 'users#leaveprivatechat'
  post '/leavepublicchat/:id/:chat_id', to: 'users#leavepublicchat'
  post '/addprodtocol/:col_id/:prod_id', to: 'users#addprodtocol'
  post '/getuserbyid/:parse_id', to: 'users#getuserbyid'

  get 'userssearch/:users_search_keyword' => 'users#search_users'

  get 'search/:keyword/:folds' => 'products#search'

  get 'user/openmailnoti' => 'users#openmailnoti'


  # proudcts
  post '/newprod/:owner_id' => 'products#create'
  get 'productsi/:num' => 'products#indexr', as: 'productsi'
  get 'productsi/:from/:to' => 'products#indexft'
  get 'similarproductsi/:id/:num' => 'products#similarproductsi'
  get 'prodsearch/:products_search_keyword' => 'products#search_products'
  get 'searchp/:searchtext' => 'products#search'
  get 'showindex/:col_id' => 'products#showindex', as: 'colprods'
  get 'savedprods/:owner_id' => 'products#savedprods'
  get 'searchprodcat/:keyword/:folds' => "products#prodsearchcat"
  get 'searchprodbrand/:keyword/:folds' => "products#prodsearchbrand"
  get 'getpostedprods/:owner_id' => "products#getpostedprods"


  #brands
  get '/getversion' => 'brands#getversion'

end

