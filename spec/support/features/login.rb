module Helpers
  module Features
    module Login

      module_function

      def login!(account)
        visit new_user_session_path
        fill_in 'user[email]', :with => account.email
        fill_in 'user[password]', :with => '12345678'
        sleep(0.5)
        page.first("#sign_in").trigger('click')
        expect(page).not_to have_current_path(new_user_session_path)
      end

      def logout!
        # visit new_user_session_path
        # fill_in 'user[email]', :with => account.email
        # fill_in 'user[password]', :with => '12345678'
        # page.first("#sign_in").trigger('click')
      end

    end
  end
end
