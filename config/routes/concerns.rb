concern :shared_errors do
  get '404', to: 'errors#page_not_found'
  get '422', to: 'errors#server_error'
  get '500', to:  'errors#server_error'
end

concern :shared_user do
  match 'users/sign_out', via: [:delete],   to: 'sessions#destroy',             as: :signout
  match :cancel_login,    via: [:get],      to: 'sessions#cancel_login',        as: :cancel_login
  match :cancel_signup,   via: [:get] ,     to: 'registrations#cancel_signup',  as: :cancel_signup
end

concern :shared_page do
  match :demo,        via: [:get],    action: :demo,         as: :demo
  match :menu,        via: [:get],    action: :menu,         as: :menu
  match :agb,         via: [:get],    action: :agb,         as: :agb
  match :privacy,     via: [:get],    action: :privacy,     as: :privacy
  match :imprint,     via: [:get],    action: :imprint,     as: :imprint
  match :saleguide,   via: [:get],    action: :saleguide,   as: :saleguide
  match :fees,        via: [:get],    action: :fees,        as: :fees
  match :home,        via: [:get],    action: :home,        as: :home
end

concern :shared_products do
  match :approve, via: [:patch], action: :approve, as: :approve
  match :disapprove, via: [:patch], action: :disapprove, as: :disapprove
  match 'remove_sku/:sku_id',                     via: [:delete], action: :remove_sku,                  as: :remove_sku,                  :on => :member
  match 'remove_variant/:variant_id',             via: [:delete], action: :remove_variant,              as: :remove_variant,              :on => :member
  match 'remove_option/:variant_id/:option_id',   via: [:delete], action: :remove_option,               as: :remove_option,               :on => :member
  match :show_skus,                               via: [:get],    action: :show_skus,                   as: :show_skus,                   :on => :member
  match :skus,                                    via: [:get],    action: :skus,                        as: :skus,                        :on => :member
  match :new_sku,                                 via: [:get],    action: :new_sku,                     as: :new_sku,                     :on => :member
  match :edit_sku,                                via: [:get],    action: :edit_sku,                    as: :edit_sku,                    :on => :member
  match :clone_sku,                               via: [:get],    action: :clone_sku,                   as: :clone_sku,                   :on => :member
  match :autocomplete_product_name,               via: [:get],    action: :autocomplete_product_name,   as: :autocomplete_product_name,   :on => :collection
  match :search,                                 via: [:get],    action: :search,                      as: :search,                      :on => :collection
  match :popular,                                 via: [:get],    action: :popular,                     as: :popular,                                  :on => :collection
end

concern :shared_users do
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

concern :shared_shops do
  match :approve, via: [:patch], action: :approve, as: :approve
  match :disapprove, via: [:patch], action: :disapprove, as: :disapprove
  match :edit_setting,    via: [:get],    action: :edit_setting,    as: :edit_setting,    :on => :member
  match :edit_producer,   via: [:get],    action: :edit_producer,   as: :edit_producer,   :on => :member
  match :show_products,   via: [:get],    action: :show_products,   as: :show_products,   :on => :member
  resources :products,    only: [:new]
end

concern :shared_shop_applications do
  match :is_registered,     via: [:get],  action: :registered?,         as: :is_registered,       :on => :collection
end

concern :shared_orders do
  match :add_product,               via: [:patch],        action: :add_product,             as: :add_product_to,              :on => :collection
  match :checkout,                  via: [:post],         action: :checkout,                as: :checkout,                    :on => :collection
  match :checkout_success,          via: [:post],         action: :checkout_success,        as: :checkout_success,            :on => :collection
  match :checkout_fail,             via: [:post],         action: :checkout_fail,           as: :checkout_fail,               :on => :collection
  match :manage_cart,               via: [:get],          action: :manage_cart,             as: :manage_cart,                 :on => :collection
  match 'set_address/:shop_id/',          via: [:patch, :get],  action: :set_address,             as: :set_address,           :on => :collection
  match 'adjust_skus_amount/:shop_id/',   via: [:patch],        action: :adjust_skus_amount,      as: :adjust_skus_amount,    :on => :collection
  match :continue,                        via: [:get],    action: :continue,                as: :continue,                    :on => :member
end

concern :shared_categories do
  match :list_products,   via: [:get],    action: :list_products,               as: :list_products,     :on => :member
  match :show_products,   via: [:get],    action: :show_products,               as: :show_products_in,  :on => :member
end