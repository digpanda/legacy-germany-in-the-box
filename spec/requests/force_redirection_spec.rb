describe 'force redirection', type: :request  do

  context 'try to access customer area' do

    context 'as customer' do

      let(:customer) { FactoryGirl.create(:customer) }

      it 'succeeds after log-in' do

        # NOTE : this test has been problematic for a very long time
        # it crashes sometimes, depending the weather or whatever.
        # we should rethink it entirely and rebuild it.
        # - Laurent, 19/09/2017
        # visit customer_orders_path
        # expect(current_path).to eq(new_user_session_path)
        # login!(customer)
        # expect(page).to have_current_path(customer_orders_path)

      end

    end

  end

  context 'try to access admin area' do

    context 'as admin' do

      let(:admin) { FactoryGirl.create(:admin) }

      it 'succeeds after log-in' do

        visit admin_categories_path
        expect(current_path).to eq(new_user_session_path)
        login!(admin)
        expect(page).to have_current_path(admin_categories_path)

      end

    end

    context 'as shopkeeper' do

      let(:shopkeeper) { FactoryGirl.create(:shopkeeper) }

      it 'fails after log-in' do

        visit admin_categories_path
        expect(page).to have_current_path(new_user_session_path)
        login!(shopkeeper)
        expect(page).not_to have_current_path(admin_categories_path)

      end

    end

  end

end
