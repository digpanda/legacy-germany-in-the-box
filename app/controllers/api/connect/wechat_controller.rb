class Api::Connect::WechatController < Api::ApplicationController

  # here we solve the connection from wechat and send the customer
  # or a bad request message.
  # please use `code` params to make it work
  def create
    if connect_solver.success?
      # we store the session
      # TODO : we have to update and generate a new token here
      # NOTE : working with tokens would be better for the API.
      # this part might be useless afterwards
      sign_in(:user, connect_solver.data[:customer])
      # we send the customer straight and it'll be processed on the front-end side
      render json: connect_solver.data[:customer]
    else
      render json: { error: 'Impossible to resolve customer' }
    end
  end

  private

    def connect_solver
      @connect_solver ||= WechatApi::ConnectSolver.new(code).resolve
    end

    def code
      params[:code]
    end
end
