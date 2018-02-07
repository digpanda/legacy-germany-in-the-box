# with the code and other data
# we safely silent login wechat users
# we can then use the `redirection` method
# to redirect properly users
class WechatSilentLogin < BaseService
  include Rails.application.routes.url_helpers
  include Devise::Controllers::Helpers # sign_out, sign_in methods
  include

  attr_reader :request, :session, :navigation, :cart_manager, :code

  def initialize(request: nil, navigation: nil, cart_manager: nil, code: nil)
    @request = request
    @session = request.session # used by Devise Helpers
    @navigation = navigation
    @cart_manager = cart_manager
    @code = code
  end

  # we try to connect the user
  # via the code transmit (typicall in params)
  # if the login is successful we signin the customer
  # else we dispatch a notification to slack
  # NOTE : the redirect_url must be used for the final redirection
  # it won't be triggered with connect! which only return a boolean
  def connect!
    if wechat_api_connect_solver.success?
      signin! user
      true
    else
      failed! wechat_api_connect_solver.error
      false
    end
  end

  def user
    wechat_api_connect_solver.data[:customer]
  end

  # the redirection will use contextual data
  # it will actually refresh the same page in this case (silent login)
  # but remove the code params
  def redirect(*args)
    if wechat_api_connect_solver.success?
      after_signin_handler.solve(*args)
    end
  end

  private

    def signin!(user)
      handle_after_sign_up!(user)
      sign_in(:user, user)
    end

    def failed!(error)
      slack.message "[Wechat] Auth failed (`#{error}`)"
    end

    def handle_after_sign_up!(user)
      AfterSignupHandler.new(request, user).solve if user.freshly_created?
    end

    def wechat_api_connect_solver
      @wechat_api_connect_solver ||= WechatApiConnectSolver.new(code, local: cart_manager.local).resolve
    end

    def after_signin_handler
      @after_signin_handler ||= AfterSigninHandler.new(request, navigation, user, cart_manager)
    end

    def slack
      @slack ||= SlackDispatcher.new
    end
end
