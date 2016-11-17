# Connection related
namespace :connect do

end

# the devise routing system must be kept outisde the namespace
# otherwise it does not understand what model to use (`connect_user`)
devise_for :users, :path => 'connect/', :controllers => {

  # we have to repeat the namespace
  # because devise does not understand it
  registrations: "connect/registrations",
  sessions: "connect/sessions",
  passwords: "connect/passwords",
  omniauth_callbacks: "connect/omniauth_callbacks"

}
