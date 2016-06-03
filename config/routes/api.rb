
namespace :api, defaults: { format: 'json' }  do

  devise_scope :user do
    
    match 'set_redirect_location', via: [:patch], to: 'sessions#set_redirect_location', as: :set_redirection_location
    match 'users/is_auth', via: [:get], to: 'sessions#is_auth', as: :is_auth

    concerns :shared_user
  end

  resources :products  do

    match :get_sku_for_options,                     via: [:get],    action: :get_sku_for_options,         as: :get_sku_for_options,         :on => :member
    match :like,                                    via: [:patch],  action: :like,                        as: :like,                        :on => :member
    match :unlike,                                 via: [:patch],  action: :unlike,                     as: :unlike,                     :on => :member

    concerns :shared_products
  end

end