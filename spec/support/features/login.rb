module Helpers
  module Features
    module Login
      module_function

      def process_login(account)
        # visit new_user_session_path
        # screenshot!
        # fill_in 'user[email]', with: account.email
        # fill_in 'user[password]', with: '12345678'
        # sleep(0.6)
        # screenshot!
        # page.first('#sign_in').trigger('click')
        # sleep(0.6)
        # screenshot!
        # expect(page).not_to have_current_path(new_user_session_path)

        visit new_user_session_path
        fill_in 'user[email]', with: account.email
        fill_in 'user[password]', with: '12345678'
        page.first('#sign_in').trigger('click')
        expect(page).not_to have_current_path(new_user_session_path)
      end
    end
  end
end
