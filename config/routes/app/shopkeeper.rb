# Shopkeeper related
namespace :shopkeeper do

  resources :products do

    resources :variants, controller: 'products/variants' do
      delete '/option/:option_id', action: :destroy_option, as: :destroy_option
    end

    resources :skus, controller: 'products/skus' do
      patch :clone
    end
  end

  resources :orders do
    patch :process_order
    patch :shipped
  end

  resource :account, controller: 'account' do
  end

  resources :settings do
  end

  resource :shop, controller: 'shop' do
  end

  resources :addresses do
  end

  resources :payments do
  end

  resources :supports do
  end

end
