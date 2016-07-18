class Api::Guest::UsersController < ApplicationController

  load_and_authorize_resource

  def find_by_email

    if missing_email_param? || registered_email?
      render status: :not_found,
             json: throw_error(:resource_not_found).to_json
    else
      render status: :ok, 
             json: {success: true}.to_json
    end

  end

  private

  def missing_email_param?
    email_param.nil?
  end

  def registered_email?
    User.where(email: email_param).first
  end

  def email_param
    params["shop_application"]["email"]
  end

end