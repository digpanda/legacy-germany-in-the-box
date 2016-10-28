namespace :api, defaults: { format: 'json' }  do

  draw :api, :customer
  draw :api, :guest
  draw :api, :webhook

  # Products related -> i don't think it's in use anymore
  # resources :products  do
  #   concerns :shared_products
  # end

end
