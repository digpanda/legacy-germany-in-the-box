class Api::Guest::UsersController < ApplicationController

  load_and_authorize_resource

  def find_by_email

    # make protection and such ? -> this is pretty chaotic since it uses a weird pluggin to remotely check
    render status: :not_found,
    json: throw_error(:resource_not_found).to_json and return if params["shop_application"]["email"].nil?

    if User.where(email: params["shop_application"]["email"]).first.nil?
      render status: :ok, 
      json: {success: true}.to_json and return
    else
      render status: :not_found,
      json: throw_error(:resource_not_found).to_json and return if params["shop_application"]["email"].nil?
    end

  end

end