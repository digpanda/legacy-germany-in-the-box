# Shared related
namespace :shared do

  resources :orders do
    get   :label
    get   :bill
    patch :cancel
  end
  resources :notifications do
  end

  resources :images do
  end

end
