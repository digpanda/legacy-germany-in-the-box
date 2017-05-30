# Guest related
namespace :guest do

  # china city related (for the address system)
  mount ChinaCity::Engine => '/china_city'

  resources :translations  do
  end

  resource :navigation, :controller => 'navigation' do
  end

  resources :order_items  do
  end

  resource :cart, :controller => 'cart' do
    get :total
  end


  resources :products  do
    resources :skus, :controller => 'products/skus' do
    end
  end

  namespace :users do
    get :find_by_email
    get :unknown_by_email
  end

  resources :package_sets do
  end

end
