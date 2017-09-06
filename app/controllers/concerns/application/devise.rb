module Application
  module Devise
    extend ActiveSupport::Concern

    included do
    end

    def after_sign_up_path_for(resource)
      AfterSignupHandler.new(request, current_user).solve!
      super
    end

    def after_sign_in_path_for(resource)
      AfterSigninHandler.new(request, navigation, current_user, cart_manager).solve!
    end
  end
end
