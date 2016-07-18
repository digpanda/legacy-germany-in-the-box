class Api::Guest::UsersController < ApplicationController

  load_and_authorize_resource

  #
  # the behavior of this method isn't correct. it throws an error when we find the email to allow the remote=true automatic system to work.
  # we should globally refactor this.
  #
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