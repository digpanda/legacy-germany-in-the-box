class AccountManager < BaseService
  include Devise::Controllers::Helpers # sign_out, sign_in methods

  attr_reader :request, :session, :params, :user

  def initialize(request, params, user)
    @request = request
    @session = request.session
    @params = params
    @user = user
  end

  def perform
    if try_update
      sign_in(user, bypass: true)
      return_with(:success)
    else
      return_with(:error, user.errors.full_messages.join(','))
    end
  end

  private

    def try_update
      check_valid_password? && user.update(user_params)
    end

    def check_valid_password?
      if user.valid_password?(params[:user][:current_password])
        true
      else
        user.errors.add(:password, 'wrong')
        false
      end
    end

    def bypass_password
      if params[:user][:password].empty?
        params[:user][:password] = params[:user][:password_confirmation] = params[:user][:current_password]
      end
      params[:user].delete(:current_password)
    end

    def user_params
      bypass_password
      params.require(:user).permit!
    end
end
