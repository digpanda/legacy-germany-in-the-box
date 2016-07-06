
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

    end

    resources :products  do
      
      resources :skus, :controller => 'products/skus' do
      end

    end

  end

  # Customer related
  namespace :customer do

    resources :favorites  do
    end

  end

  # Webhook related
  namespace :webhook do

    namespace :wirecard do
      resource :merchant do
      end
    end

  end


  # TODO : SHOULD BE PUT SOMEWHERE + REFACTORED IN A BETTER WAT (RESTful)
  resources :products  do

    match :get_sku_for_options,                     via: [:get],    action: :get_sku_for_options,         as: :get_sku_for_options,         :on => :member

    concerns :shared_products
  end

end