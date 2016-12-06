describe Shopkeeper::Products::SkusController, :type => :controller do

  describe "#clone" do

    let(:current_user) { FactoryGirl.create(:shopkeeper) }
    before(:each) { login_shopkeeper current_user }
    let(:product) { FactoryGirl.create(:product) }
    subject(:sku) { product.skus.first }

    it "clone successfully the sku" do

      patch :clone, sku_id: sku.id, product_id: sku.product.id
      product.reload # refresh the data after its been cloned
      similar_skus = product.skus.where(option_ids: sku.option_ids)
      expect(similar_skus.count).to eql(2) # we effectively have 2 skus no
      new_sku = similar_skus.last # last one created is the new one
      expect(new_sku.img0 == sku.img0).to eql(false) # we duplicated the images, they are not the same

    end

  end

end
