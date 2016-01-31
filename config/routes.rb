Rails.application.routes.draw do
  captcha_route

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks',registrations: "registrations", sessions: "sessions" }

  devise_scope :user do
    delete '/users/sign_out', to: 'sessions#destroy', as: :signout
    get '/cancel_login', to: 'sessions#cancel_login', as: :cancel_login
    get '/cancel_signup', to: 'registrations#cancel_signup', as: :cancel_signup
  end

  resources :notifications
  resources :posts
  resources :brands
  resources :messages
  resources :chats
  resources :collections
  resources :addresses

  resources :products, except: [:index] do
    get :autocomplete_product_name, :on => :collection
  end

  resources :users, except: [:show, :destroy]
  resources :shops

  resources :orders, only: [:destroy, :show]

  mount ChinaCity::Engine => '/china_city'
  
  # user

  get '/',to: 'pages#home', as: 'home'

  get '/set_session_locale/:locale', to: 'application#set_session_locale', as: 'set_session_locale'

  get 'popular_products', to: 'products#indexr', as: 'popular_products'
  post 'products/search', to: 'products#search_products', as: 'search_products'
  get '/category/:category_id/products', to: 'products#show_products_in_category', as: 'show_products_in_category'

  get 'profile/:id', to: 'users#pshow', as: "profile"


  post 'orders/add_product/:product_id', to: 'orders#add_product', as: 'add_product_to_order'
  post 'orders/adjust_products_amount', to: 'orders#adjust_products_amount', as: 'adjust_products_amount_in_order'
  post 'orders/checkout', to: 'orders#checkout', as: 'checkout_order'

  get 'orders/cart/manage',to: 'orders#manage_cart', as: 'manage_cart'
  get 'orders/:id/continue', to: 'orders#continue', as: 'continue_order'
  get 'orders/checkout/set_address_payment', to: 'orders#set_address_payment', as: 'set_address_payment'

  get 'collections/:collection_id/toggle_product/:product_id', to: 'collections#toggle_product', as: 'toggle_product_in_collection'
  get 'collections/:collection_id/remove_product/:product_id', to: 'collections#remove_product', as: 'remove_product_from_collection'
  get 'collecionts/is_product_in_user_collections/:product_id', to: 'collections#is_product_in_user_collections', as: 'is_product_in_user_collections'
  post 'collections/create_and_add_to_colletion', to: 'collections#create_and_add_to_collection', as: 'create_and_add_to_collection'

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
  post '/removeprodtocol/:col_id/:prod_id', to: 'users#removeprodtocol'
  post '/getuserbyid/:parse_id', to: 'users#getuserbyid'

  get '/getfollowers/:id', to: 'users#get_followers'

  get '/getfollowings/:id', to: 'users#get_followings'

  get 'userssearch/:keyword/:folds' => 'users#userssearch'

  get 'search/:keyword/:folds' => 'products#search'

  get 'user/openmailnoti' => 'users#openmailnoti'


  # collection
  post '/newcol/:owner_id' => 'collections#create'
  get 'collectionsi/:from/:to' => 'collections#indexft'
  get '/userinit/:user_id' => 'collections#userinit'
  get 'similarcoli/:id/:num' => 'collections#similarcoli'
  get 'collection/:id' => 'collections#getinfo'
  get 'matchedcollections/:id/:num' => 'collections#matchedcollections'
  get 'mycolls/:owner_id' => 'collections#mycolls'
  get 'savedcolls/:owner_id' => 'collections#savedcolls'
  get 'likedcolls/:owner_id' => 'collections#likedcolls'
  get 'colsearch/:keyword/:folds' => 'collections#colsearch'

  get 'gsearch/' => 'collections#gsearch', as: "gsearch"


  # proudcts
  post '/newprod/:owner_id' => 'products#create'
  get 'productsi/:num' => 'products#indexr', as: 'productsi'
  get 'productsi/:from/:to' => 'products#indexft'
  get 'similarproductsi/:id/:num' => 'products#similarproductsi'
  get 'prodsearch/:keyword/:folds' => 'products#prodsearch'
  get 'searchp/:searchtext' => 'products#search'
  get 'showindex/:col_id' => 'products#showindex', as: 'colprods'
  get 'savedprods/:owner_id' => 'products#savedprods'
  get 'searchprodcat/:keyword/:folds' => "products#prodsearchcat"
  get 'searchprodbrand/:keyword/:folds' => "products#prodsearchbrand"
  get 'getpostedprods/:owner_id' => "products#getpostedprods"


  #brands
  get '/getversion' => 'brands#getversion'

  #chats
  post 'message/:chat_id' => 'messages#create'
  get 'chatmessages/:chat_id' => 'messages#index'
  get 'chatsearch/:keyword/:folds' => 'chats#chatsearch'
  get 'usernotifications/:user_id' => 'notifications#index'

  #messages
  get 'messagesi/:chat_id/:id' => 'messages#messages'

  #chats
  get 'privatechats' => 'chats#privatechats'
  get 'publicchats' => 'chats#publicchats'

end

