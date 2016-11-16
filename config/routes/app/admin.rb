# Admin related
namespace :admin do

  resources :categories do
  end

  resources :coupons do
    patch :cancel
    patch :approve
  end

  resources :payment_gateways do
  end

  resources :notes do
  end

  resources :shops do
    get :emails
    patch :approve
    patch :disapprove
    delete :destroy_image
  end

  resources :shop_applications do
  end

  resources :orders do
    patch :reset_border_guru_order
  end

  resource :account, :controller => 'account' do
  end

  resources :users do
  end

  resources :order_payments do
    post :refund
    post :check
    patch :transaction_id
  end

  resource :settings, only: [:show, :update] do
  end

end
