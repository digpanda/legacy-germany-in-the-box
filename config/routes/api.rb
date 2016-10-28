namespace :api, defaults: { format: :json }  do

  # we load the different routes depending on subsections
  draw :api, :customer
  draw :api, :guest
  draw :api, :webhook

  # Products related -> i don't think it's in use anymore
  # - Laurent, 28 October 2016
  # resources :products  do
  #   concerns :shared_products
  # end

end
