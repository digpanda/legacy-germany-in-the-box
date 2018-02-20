class Api::Guest::WechatController < Api::ApplicationController

  # here we solve the connection from wechat and send the customer
  # or a bad request message.
  # please use `code` params to make it work
  def create
    if connect_solver.success?
      render json: { customer: connect_solver.data[:customer] }
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
