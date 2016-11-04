# Shopkeeper related
namespace :shopkeeper do

  resources :orders do
    patch :process_order
    patch :shipped
  end

  resource :account, :controller => 'account' do
  end

  resources :payments do
  end

  resources :supports do
  end

  resource :wirecard do
    get :apply, :on => :member
  end

end
