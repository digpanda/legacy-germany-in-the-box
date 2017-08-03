describe Admin::OrdersController, type: :controller do

  render_views

  describe '#index' do

    let(:current_user) { FactoryGirl.create(:admin) }
    before(:each) { login_admin current_user }
    subject(:orders) { FactoryGirl.create_list(:order, 10) }

    it 'can see CSV orders list' do

      get :index, format: :csv
      expect(response.header['Content-Type']).to have_content('text/csv')

    end

  end

  describe '#show' do

    context 'without customer attached' do

      subject(:order) { FactoryGirl.create(:order, :without_customer) }

      it 'shows the page' do

        get :show, id: order.id
        expect { response }.not_to raise_error

      end

    end

  end

end
