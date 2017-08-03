require 'rails_helper'

describe SkuCloner do

  # TODO : don't forget to check the image and datas
  context 'inside of a product (admin / shopkeeper side)' do

    before(:each) do
      @product = FactoryGirl.create(:product)
      @sku = @product.skus.first
    end

    it 'clones a sku inside its product' do
      sku_cloner = SkuCloner.new(@product, @sku).process
      expect(sku_cloner.success?).to be(true)
      clone = sku_cloner.data[:clone]
      clone.reload
      @sku.attributes.except('_id', 'u_at', 'c_at').each do |name, value|
        #expect(clone.attributes[name]).to eql(value)
      end
    end

  end

  context 'inside of an order' do

    before(:each) do
      @order = FactoryGirl.create(:order)
      @order_item = @order.order_items.first
      @sku = @order_item.sku
    end

    it 'clones a sku into an order_item (while ordering)' do
      sku_cloner = SkuCloner.new(@order_item, @sku, :singular).process
      expect(sku_cloner.success?).to be(true)
      clone = sku_cloner.data[:clone]
      clone.reload
      @sku.attributes.except('_id', 'u_at', 'c_at').each do |name, value|
        #@expect(clone.attributes[name]).to eql(value)
      end
    end

  end

end
