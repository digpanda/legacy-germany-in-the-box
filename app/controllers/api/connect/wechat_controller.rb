require 'bcrypt'

class Api::Connect::WechatController < Api::ApplicationController

  # here we solve the connection from wechat and send the customer
  # or a bad request message.
  # please use `code` params to make it work
  def create
    if connect_solver.success?
      user.token = current_token
      user.save(validate: false)
      # sign_in(:user, user)
      # we send the customer straight and it'll be processed on the front-end side
      render json: user
    else
      render json: { error: 'Impossible to resolve customer' }
    end
  end

  private

    def current_token
      BCrypt::Password.create(token_chain)
    end

    def token_chain
      "#{user.email}#{user.encrypted_password}#{Time.now}"
    end

    def connect_solver
      @connect_solver ||= WechatApi::ConnectSolver.new(code).resolve
    end

    def user
      @user ||= connect_solver.data[:customer]
    end

    def code
      params[:code]
    end
end
