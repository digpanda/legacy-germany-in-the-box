# Shared related
namespace :shared do

  resources :orders do
    get :bill
    get :official_bill
    get :rendered_official_bill
    patch :cancel
  end
  resources :notifications do
  end

  resources :images do
  end

end
