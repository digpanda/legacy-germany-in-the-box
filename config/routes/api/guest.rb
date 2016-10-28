# Guest related
namespace :guest do

  resources :translations  do
  end

  resource :navigation, :controller => 'navigation' do
  end

  resources :order_items  do
    patch :set_quantity
  end

  resources :products  do
    resources :skus, :controller => 'products/skus' do
    end
  end

  namespace :users do
    get :find_by_email
    get :unknown_by_email
  end

end
