# Connection related
devise_for :users, :path => 'connect/', :controllers => {

  # we have to repeat the namespace
  # because devise does not understand it
  registrations: "connect/registrations",
  sessions: "connect/sessions",
  passwords: "connect/passwords",
  omniauth_callbacks: "connect/omniauth_callbacks"

}
namespace :connect do


  #devise_for :users #, :path => 'users/' #, :skip => :all

  # devise_for :users, :controllers => {
  #
  #   # we have to repeat the namespace
  #   # because devise does not understand it
  #   registrations: "connect/registrations",
  #   sessions: "connect/sessions",
  #   passwords: "connect/passwords",
  #   omniauth_callbacks: "connect/omniauth_callbacks"
  #
  # }

  #
  # devise_scope :user do
  #  resources :sessions
  #  resources :registrations
  #  resources :passwords
  #  resources :omniauth_callbacks
  # end

  # it doesn't seem to be in used at all within the system.
  # devise_scope :user do
  #   # match 'users/sign_out', via: [:delete],   to: 'sessions#destroy',             as: :signout
  # end

end
