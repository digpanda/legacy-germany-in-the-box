# Customer related
namespace :customer do

  resource :account, controller: 'account' do
  end
  
  resource :referrer, controller: 'referrer' do
    get :group_insight
    get :children_insight
    # get :provision
    get :brands_rates
    get :services_rates
    # get :coupons
    get :qrcode
    # post :claim
    # get :agb
    #
    # resource :customization, controller: 'referrer/customization' do
    # end
    #
    # resources :links, controller: 'referrer/links' do
    #   get :share
    # end
  end

  resources :favorites do
  end

  resources :orders do
  end

  resources :order_payments do
  end

end
