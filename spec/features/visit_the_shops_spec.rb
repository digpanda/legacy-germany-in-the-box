feature 'visits the shops', js: true  do

  before(:each) {
    create_categories!
    FactoryGirl.create_list(:product, 20)
  }

  scenario 'from the homepage' do

    visit root_path
    page.first('#food').trigger('click') # click on anything
    expect(page).to have_css 'h1', text: '食品佳酿' # we are now on the food category page
    first('.shop-block__container').first('.main-button__hollow').trigger('click')
    on_shop_page?

  end

  let(:shop) { FactoryGirl.create(:shop) }

  scenario 'add a product in the cart' do

    visit guest_shop_path(shop)
    on_shop_page?
    page.first('.shop-page-product__image').trigger('click')
    on_product_page?
    page.first('#js-add-to-cart').trigger('click')
    #show_total_products(1)

  end

  scenario 'add a few items of the same product in the cart' do

    visit guest_shop_path(shop)
    on_shop_page?
    page.first('.shop-page-product__image').trigger('click')
    on_product_page?
    2.times { page.first('#quantity-plus').trigger('click') } # click 2 times to make 3
    page.first('#js-add-to-cart').trigger('click')
    #show_total_products(3)

  end

end
