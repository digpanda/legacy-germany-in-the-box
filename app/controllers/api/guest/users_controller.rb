class Api::Guest::UsersController < Api::ApplicationController
  before_action :missing_email_param?, :only => [:find_by_email, :unknown_by_email]

  # the structuration of #find_by_email and #unknown_by_email looks weird
  # it's to be used with the AJAX non obstrusive system installed previously
  # we should at some point get rid of it and manage via ONE method this kind of things.
  # the correct solution here is to use the RESTful scheme : /api/users/?email=something@mail.com
  # and process it.
  def find_by_email
    unless registered_email?
      render status: :not_found,
             json: throw_error(:resource_not_found).to_json
    else
      render status: :ok,
             json: {success: true}.to_json
    end
  end

  def unknown_by_email
    if registered_email?
      render status: :unprocessable_entity,
             json: throw_error(:resource_found).to_json
    else
      render status: :ok,
             json: {success: true}.to_json
    end
  end

  private

    def missing_email_param?
      if email_param.nil?
        render status: :unprocessable_entity,
               json: throw_error(:bad_format).to_json
        return
      end
    end

    def registered_email?
      User.where(email: email_param).first
    end

    def email_param
      params["shop_application"]["email"]
    end
end
