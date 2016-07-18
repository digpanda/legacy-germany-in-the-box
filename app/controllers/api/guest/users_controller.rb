class Api::Guest::UsersController < ApplicationController

  load_and_authorize_resource

  def find_by_email

    if missing_email_param?
      render status: :not_found,
             json: throw_error(:resource_not_found).to_json and return
    end

    if unregistered_email?
      render status: :ok, 
             json: {success: true}.to_json and return
    end

    render status: :not_found,
           json: throw_error(:resource_not_found).to_json and return
           
  end

  private

  # make protection and such ? -> this is pretty chaotic since it uses a weird pluggin to remotely check
  def missing_email_param?
    email_param.nil?
  end

  def unregistered_email?
    User.where(email: email_param).first
  end

  def email_param
    params["shop_application"]["email"]
  end

end