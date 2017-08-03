describe Connect::SessionsController, :type => :controller do

  describe "#create" do

    
    subject(:user) { FactoryGirl.create(:customer, :with_orders) }
    before(:each) { @request.env["devise.mapping"] = Devise.mappings[:user] }

    it "can sign-in with an empty order in his profile" do

      # we empty the last order to test
      # if it'll break when the cart recover it
      user.cart_orders.first.order_items.delete_all
      post :create, {"user" => {"email" => user.email, "password" => "12345678"}}
      expect { response }.not_to raise_error

    end

  end

end
