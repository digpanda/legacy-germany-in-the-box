describe Customer::OrdersController, type: :controller do
  render_views

  let(:current_user) { FactoryGirl.create(:customer) }

  before(:each) do
    login_customer current_user
  end

  context '#index' do

    subject!(:orders) { FactoryGirl.create_list(:order, 5, user: current_user) }

    it 'can see the orders list' do

      get :index
      expect { response }.not_to raise_error
      expect(assigns(:orders).count).to eql(5)

    end

  end

  context '#show' do

    subject(:order) { FactoryGirl.create(:order, user: current_user) }

    it 'shows the page' do

      get :show, id: order.id
      expect { response }.not_to raise_error

    end

  end
end
