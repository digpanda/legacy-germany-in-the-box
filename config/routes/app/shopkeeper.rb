# Shopkeeper related
namespace :shopkeeper do

  resources :products do
  end
  
  resources :orders do
    patch :process_order
    patch :shipped
  end

  resource :account, :controller => 'account' do
  end

  resource :shop, :controller => 'shop' do
    delete :destroy_image
    # TODO : this part of the system is actually semantically incorrect
    # we should totally split up the shop into sections linked with producer, history, etc.
    resource :producer, :controller => 'shop/producer' do
    end
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
