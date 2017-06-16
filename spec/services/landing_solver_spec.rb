describe LandingSolver do

  # to compare paths
  include Rails.application.routes.url_helpers

  context "#setup!" do

    # let(:request) { ActionController::TestRequest.new(session: ) )}
    let(:empty_request) { ActionController::TestRequest.new }


    it "should setup package sets from URL recognition" do
      request = double('request', url: guest_package_sets_url, session: {}, params: {})
      solver = LandingSolver.new(request).setup!
      expect(solver.request.session[:landing]).to eq(:package_sets)
    end

    it "should setup products from URL recognition" do
      request = double('request', url: root_url, session: {}, params: {})
      solver = LandingSolver.new(request).setup!
      expect(solver.request.session[:landing]).to eq(:products)
    end

    it "should setup package sets from forced param" do
      request = double('request', url: root_url, session: {}, params: { landing: "package_sets" })
      solver = LandingSolver.new(request).setup!
      expect(solver.request.session[:landing]).to eq(:package_sets)
    end

    it "should setup products from forced param" do
      request = double('request', url: guest_package_sets_url, session: {}, params: { landing: "products" })
      solver = LandingSolver.new(request).setup!
      expect(solver.request.session[:landing]).to eq(:products)
    end

  end

  context "#recover" do

    it "should recover the package set origin" do
      request = double('request', url: guest_package_sets_url, session: {}, params: {})
      solver = LandingSolver.new(request).setup!
      expect(solver.recover).to eq(guest_package_sets_path)
    end

    it "should recover the products origin" do
      request = double('request', url: root_url, session: {}, params: {})
      solver = LandingSolver.new(request).setup!
      expect(solver.recover).to eq(root_path)
    end

  end

end
