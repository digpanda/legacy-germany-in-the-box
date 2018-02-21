namespace :api, defaults: { format: :json }  do

  # we load the different routes depending on subsections
  draw :api, :admin
  draw :api, :customer
  draw :api, :guest
  draw :api, :connect
  draw :api, :webhook

end
