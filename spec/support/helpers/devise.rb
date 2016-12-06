module Helpers
  module Devise

    module_function

    def login_admin(admin)
      @request.env["devise.mapping"] = ::Devise.mappings[:admin]
      sign_in admin # Using factory girl as an example
    end

    def login_customer(customer)
      @request.env["devise.mapping"] = ::Devise.mappings[:user]
      sign_in customer
      #allow(controller).to receive(:current_user) { customer }
      #allow(request.env['warden']).to receive(:authenticate!).and_return(customer)
    end

  end
end
