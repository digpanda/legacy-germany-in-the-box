# Shopkeeper related
namespace :shopkeeper do

  resources :products do
    # TODO : this should be refactored and maybe put into individual controllers
    # delete '/destroy_variant/:variant_id', action: :destroy_variant, as: :destroy_variant
    # delete '/destroy_option/:variant_id/:option_id', action: :destroy_option, as: :destroy_option
    # TODO : put the one above in `variants`

    resources :variants, :controller => 'products/variants' do
      delete '/option/:option_id', action: :destroy_option, as: :destroy_option
    end

    resources :skus, :controller => 'products/skus' do
      delete :destroy_image
      patch :clone
    end
  end

  resources :orders do
    patch :process_order
    patch :shipped
  end

  resource :account, :controller => 'account' do
  end

  resources :settings do
  end

  resource :shop, :controller => 'shop' do
    delete :destroy_image

  end

  resources :addresses do
  end

  resources :payments do
  end

  resources :supports do
  end

  resource :wirecard do
    get :apply, :on => :member
  end

end
