
namespace :api, defaults: { format: 'json' }  do

  # Registration related
  devise_scope :user do
    
    match 'set_redirect_location', via: [:patch], to: 'sessions#set_redirect_location', as: :set_redirection_location
    match 'users/is_auth', via: [:get], to: 'sessions#is_auth', as: :is_auth

    concerns :shared_user
  end

  # Guest related
  namespace :guest do

    resources :order_items  do
      
      match :set_quantity, via: [:patch], action: :set_quantity, as: :set_quantity, :on => :member

      concerns :shared_guest_order_items
    end

    resources :products  do
      
      match :show_sku, via: [:get], action: :show_sku, as: :show_sku, :on => :member

      concerns :shared_guest_products
    end

  end

  # Customer related
  namespace :customer do

    resources :favorites  do
      concerns :shared_customer_favorites
    end

  end


  # Should be put somewhere
  resources :products  do

    match :get_sku_for_options,                     via: [:get],    action: :get_sku_for_options,         as: :get_sku_for_options,         :on => :member

    concerns :shared_products
  end

end