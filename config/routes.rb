class ActionDispatch::Routing::Mapper
  def draw(*routes_names)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_names.join('/')}.rb")))
  end
end

Rails.application.routes.draw do

  draw :concerns
  draw :app
  draw :api

end
