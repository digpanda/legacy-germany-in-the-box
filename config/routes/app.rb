# http error output
get '404', to: 'errors#page_not_found'
get '422', to: 'errors#server_error'
get '500', to:  'errors#server_error'

# base route
root to: 'guest/home#show'

# we load the different routes depending on subsections
draw :app, :admin
draw :app, :shopkeeper
draw :app, :customer
draw :app, :shared
draw :app, :connect
draw :app, :guest

resources :languages, only: [:update] do
end
