# Connection related
namespace :connect do
  devise_scope :user do
    get '/auth/silent_wechat', to: 'omniauth_callbacks#silent_wechat', as: :silent_wechat
    get '/auth/referrer', to: 'omniauth_callbacks#referrer', as: :referrer_registration
  end
end

# the devise routing system must be kept outisde the namespace
# otherwise it does not understand what model to use (`connect_user`)
devise_for :users, path: 'connect/', controllers: {
  # we have to repeat the namespace
  # because devise does not understand it
  registrations: 'connect/registrations',
  sessions: 'connect/sessions',
  passwords: 'connect/passwords',
  omniauth_callbacks: 'connect/omniauth_callbacks'
}
