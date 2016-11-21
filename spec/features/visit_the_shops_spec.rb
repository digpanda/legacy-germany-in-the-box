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
    is_shop_page?

  end

  let(:shop) { FactoryGirl.create(:shop) }

  scenario "add a product in the cart" do

    visit guest_shop_path(shop)
    is_shop_page?
    page.first('.shop-page-product__image').click
    is_product_page?
    page.first('.product-quantity button').click
    is_shop_page?
    expect(page).to have_css "#total-products", text: "1"

  end

end

def is_shop_page?
  # contains a shop-page header content
  expect(page).to have_css '.shop-page-header__content'
end

def is_product_page?
  # contains a product-page description
  expect(page).to have_css '.product-page__description'
end
