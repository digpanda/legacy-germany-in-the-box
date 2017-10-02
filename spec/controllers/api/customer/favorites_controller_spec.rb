describe Api::Customer::FavoritesController, type: :controller do
  render_views

  describe '#update' do

    context 'customer without favorite' do

      let(:current_user) { FactoryGirl.create(:customer) }
      before(:each) { login_customer current_user }
      let(:shop) { FactoryGirl.create(:shop) }

      it 'adds a favorite' do

        put :update, id: shop.products.first.id
        expect_json(success: true)
        current_user.reload
        expect(current_user.favorites.count).to eq(1)

      end

      it 'keeps the same number of favorites when adding the same product' do

        shop.products[0..4].each do |product|
          put :update, id: product.id
        end

        put :update, id: shop.products.first.id

        current_user.reload
        expect(current_user.favorites.count).to eq(5)

      end

      it 'tries to add a wrong favorite' do

        put :update, id: 'wrong-id'
        expect_json(success: false, code: 6)
        current_user.reload
        expect(current_user.favorites.count).to eq(0)

      end

    end

    context 'customer with favorites' do

      let(:current_user) { FactoryGirl.create(:customer, :with_favorites) }
      before(:each) { login_customer current_user }
      let(:shop) { FactoryGirl.create(:shop) }
      let!(:favorites_original_count) { current_user.favorites.count }

      it 'adds a favorite' do

        put :update, id: shop.products.first.id
        expect_json(success: true)
        current_user.reload
        expect(current_user.favorites.count).to eq(favorites_original_count + 1)

      end

    end

    context 'unauthorized person' do

      let(:shop) { FactoryGirl.create(:shop) }

      it 'adds a favorite' do

        put :update, id: shop.products.first.id
        expect_json(success: false, code: 7)

      end

    end

  end

  describe '#destroy' do

    context 'customer with favorites' do

      let(:current_user) { FactoryGirl.create(:customer, :with_favorites) }
      before(:each) { login_customer current_user }
      let(:shop) { FactoryGirl.create(:shop) }

      it 'deletes a favorite' do

        num_favorites = current_user.favorites.count
        put :destroy, id: current_user.favorites.sample.id
        expect_json(success: true)
        current_user.reload
        expect(current_user.favorites.count).to eq(num_favorites - 1)

      end

      it 'tries to delete a wrong favorite' do

        put :update, id: 'wrong-id'
        expect_json(success: false, code: 6)

      end

    end

    context 'unauthorized person' do

      let(:shop) { FactoryGirl.create(:shop) }

      it 'delete a favorite' do

        put :destroy, id: shop.products.first.id
        expect_json(success: false, code: 7)

      end

    end
  end
end
