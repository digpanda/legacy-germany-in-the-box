module Application
  module Devise
    extend ActiveSupport::Concern

    included do
    end

    def after_sign_in_path_for(resource)
      AfterSigninHandler.new(request, navigation, resource, cart_manager).solve
    end
  end
end
