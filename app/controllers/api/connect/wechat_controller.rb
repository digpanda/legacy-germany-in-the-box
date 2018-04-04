require 'bcrypt'

class Api::Connect::WechatController < Api::ApplicationController

  # here we solve the connection from wechat and redirect back the customer with its token
  # CYCLE EXPLANATION
  # in practice you can set URLS such as https://www.germanyinthebox.com/api/connect/wechat?callback=https://germanyinthebox.com
  # and it will go through the all process of wechat login and provide the callback URL with a specific token
  # you can then use the token for different API calls as the system has a connect system for tokens as well (/api/connect/token)
  def show


    # we can't go through wechat in dev or test so we have to fake a success
    # it's not ideal to put this code here but there's no much choices.
    if Rails.env.development? || Rails.env.test?
      fake_user = User.where(email: 'guide@guide.com').first
      fake_user.token = BCrypt::Password.create(Time.now)
      fake_user.save(validate: false)
      redirect_to UrlSolver.new(callback, app_type: :vuejs).insert_get(token: fake_user.token)
      return
    end

    # only wechat users can go through this process
    unless identity_solver.wechat_browser?
      render text: "Please use your Wechat Application."
      return
    end

    # if the code isn't defined by the system then we force the wechat gateway first
    unless code
      # we go through the weird looking URL system from wechat which will get back here afterwards
      redirect_to WechatUrlAdjuster.new(request.original_url).adjusted_url
      return
    end

    # now we can go through it with a code provided by wechat
    if connect_solver.success?
      user.token = current_token
      user.save(validate: false)
      # sign_in(:user, user)
      # we send the customer straight and it'll be processed on the front-end side
      redirect_to UrlSolver.new(callback, app_type: :vuejs).insert_get(token: current_token)
    else
      redirect_to UrlSolver.new(callback, app_type: :vuejs).insert_get(error: "Unable to log-in user")
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

    def callback
      params[:callback]
    end
end
