class ActionDispatch::Routing::Mapper
  def draw(*routes_names)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_names.join('/')}.rb")))
  end
end

require 'sidekiq/web'

Rails.application.routes.draw do

  draw :concerns
  draw :app
  draw :api

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
