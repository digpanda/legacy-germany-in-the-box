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
    get :emails, on: :collection
    patch :approve
    patch :disapprove
    delete :destroy_image

    resources :products, :controller => 'shops/products' do
      patch :regular
      patch :highlight
      patch :approve
      patch :disapprove


      resources :variants, :controller => 'shops/products/variants' do
        delete '/option/:option_id', action: :destroy_option, as: :destroy_option
      end

      # resources :skus, :controller => 'products/skus' do
      #   delete :destroy_image
      #   patch :clone
      # end

    end


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
