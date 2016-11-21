module Helpers
  module Features
    module Login

      module_function

      def login!(account)
        visit new_user_session_path
        fill_in 'user[email]', :with => account.email
        fill_in 'user[password]', :with => '12345678'
      end

    end
  end
end
