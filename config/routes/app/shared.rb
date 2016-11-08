# Shared related
namespace :shared do

  resources :products do
  end
  
  resources :orders do
    get   :label
    get   :bill
    patch :cancel
  end
  resources :notifications do
  end

end
