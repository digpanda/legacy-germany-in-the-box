# # INVALID TESTS, DONT WRITE DOWN HERE
# describe Guest::ProductsController do
#
#   render_views # jbuilder requirement
#
#   context 'guest to the website' do
#
# =begin
#     it 'should get the popular products' do
#
#       get :popular, :format => :json
#       expect(response).to be_success
#
#       #json = JSON.parse(response.body)
#
#     end
#
#     it 'should get the detail of a specific product' do
#
#       get :show, id: product.id, :format => :json
#       expect(response).to be_success
#
#     end
# =end
#
#   end
#
#   context 'authenticated customer to the website' do
#
#     let(:customer) { FactoryGirl.create(:customer) }
#     #let(:product) { FactoryGirl.create(:product) }
#
#     before {
#       allow(controller).to receive(:current_user) { customer }
#       allow(request.env['warden']).to receive(:authenticate!).and_return(customer)
#       allow(controller).to receive(:current_user).and_return(customer)
#     }
#
#     let(:current_user) { customer }
#
#     it 'should like a product' do
#
#       # TODO : We should generate a new product from FactoryGirl here
#       #product = Product.first
#
#       #patch :like, id: product.id, :format => :json # TODO : Uncomment when translation fix is done
#       #expect(response).to be_success
#
#     end
#   end
#
# end
