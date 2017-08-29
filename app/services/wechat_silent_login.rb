# with the code and other data
# we safely silent login wechat users
# we can then use the `redirection` method
# to redirect properly users
class WechatSilentLogin < BaseService

  def initialize(request, navigation, user, cart_manager)
    @request = request
    @navigation = navigation
    @user = user
    @cart_manager = cart_manager
  end

  # we try to connect the user
  # via the code transmit (typicall in params)
  # if the login is successful we signin the customer
  # else we dispatch a notification to slack
  # NOTE : the redirect_url must be used for the final redirection
  # it won't be triggered with connect! which only return a boolean
  def connect!(code)
    wechat_api_connect_solver = WechatApiConnectSolver.new(code).resolve!
    if wechat_api_connect_solver.success?
      signin! wechat_api_connect_solver.data[:customer]
      true
    else
      failed! wechat_api_connect_solver.error
      false
    end
  end

  # the redirection will use contextual data
  # it will actually refresh the same page in this case (silent login)
  # but remove the code params
  def redirect_url
    after_signin_handler.solve!(refresh: true)
  end

  private

    def signin!(user)
      sign_out
      sign_in(:user, user)
      slack.message "[Wechat] Customer automatically logged-in (`#{user&.id}`)", url: admin_user_path(user)
    end

    def failed!(error)
      slack.message "[Wechat] Auth failed (`#{error}`)"
    end

    def after_signin_handler
      @after_signin_handler ||= AfterSigninHandler.new(request, navigation, user, cart_manager)
    end
end
