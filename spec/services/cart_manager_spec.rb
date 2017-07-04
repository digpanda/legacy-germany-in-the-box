describe CartManager do

  let(:current_user) { FactoryGirl.create(:customer) }
  let(:request) { double('request', url: nil, session: {}, params: {}) }
  let(:identity_solver) { IdentitySolver.new(request, current_user) }

  context "#order" do

  end

  context "#store" do
  end

  context "#empty!" do
  end

  context "#refresh!" do
  end

  context "#products_number" do
  end

  context "#in?" do
  end

  context "#out?" do
  end

end
