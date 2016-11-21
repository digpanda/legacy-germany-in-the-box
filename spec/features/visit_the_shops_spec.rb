feature "visits the shops", :js => true  do

  before(:each) {
    create_ui_categories!
    FactoryGirl.create_list(:product, 20)
  }

  scenario "from the homepage" do

    visit root_path
    page.first('#food').click # click on anything
    expect(page).to have_css 'h2', text: "食品佳酿" # we are now on the food category page
    page.first('h3').click
    on_shop_page?

  end

  let(:shop) { FactoryGirl.create(:shop) }

  scenario "add a product in the cart" do

    visit guest_shop_path(shop)
    on_shop_page?
    page.first('.shop-page-product__image').click
    on_product_page?
    page.first('.product-quantity button').click
    on_shop_page?
    expect(page).to have_css "#total-products", text: "1"

  end

  scenario "add a few items of the same product in the cart" do

    visit guest_shop_path(shop)
    on_shop_page?
    page.first('.shop-page-product__image').click
    on_product_page?
    2.times { page.first('#quantity-plus').click } # click 2 times to make 3
    page.first('.product-quantity button').click
    on_shop_page?
    expect(page).to have_css "#total-products", text: "3"

  end

end

def on_shop_page?
  # contains a shop-page header content
  expect(page).to have_css '.shop-page-header__content'
end

def on_product_page?
  # contains a product-page description
  expect(page).to have_css '.product-page__description'
end
