require 'bcrypt'

class Api::Connect::TokenController < Api::ApplicationController

  # here we solve the connection from the token
  # or a send bad request message.
  # please use `token` params to make it work
  def create
    if user
      render json: user
    else
      render json: { error: 'Impossible to resolve user' }
    end
  end

  private

    def current_token
      BCrypt::Password.create(token_chain)
    end

    def token_chain
      "#{user.email}#{user.encrypted_password}#{Time.now}"
    end

    def user
      @user ||= User.where(token: token).first
    end

    def token
      params[:token]
    end
end
