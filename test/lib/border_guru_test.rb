require 'test_helper'
require 'border_guru'

class RecordedResponses
  class << self
    include FactoryGirl::Syntax::Methods

    @@initialization_state = :uninitialized

    def init
      if @@initialization_state == :uninitialized
        @@initialization_state = :ongoing

        calculate_quote
        get_shipping
        # from get_shipping order has a shipment identifier that we can use to get a label
        get_label
        # from get_shipping order has a shipment identifier that we can use to cancel the order
        cancel_order
        # from get_shipping order has a merchant order id (order_number), that is now used:
        announce_dispatch
        @@initialization_state = :initialized
      end

      if @@initialization_state == :initialized
        yield
      end
    end

    def forget_all
      @@calculate_quote = @@get_shipping = @@get_shipping = @@cancel_order =
        @@announce_dispatch = @@order = @@cart = nil
      @@initialization_state = :uninitialized
    end

    def calculate_quote
      @@calculate_quote ||=
        begin
          product = create :product
          cart.add product, 2

          BorderGuru.calculate_quote(
            cart: cart,
            shop: create(:shop),
            country_of_destination: ISO3166::Country.new('CN'),
            currency: 'EUR'
          )
        end
    end

    def get_shipping
      @@get_shipping ||=
        begin
          BorderGuru.get_shipping(
            order: order,
            shop: create(:shop),
            country_of_destination: ISO3166::Country.new('CN'),
            currency: 'EUR'
          )
        end
    end

    def get_label
      @@get_label ||=
        begin
          BorderGuru.get_label(
            border_guru_shipment_id: order.border_guru_shipment_id
          )
        end
    end

    def cancel_order
      @@cancel_order ||=
        begin
          BorderGuru.cancel_order(
            border_guru_shipment_id: order.border_guru_shipment_id
          )
        end
    end

    def announce_dispatch
      @@announce_dispatch ||=
        begin
          BorderGuru.announce_dispatch(
            order: order,
            dispatcher: build(:dispatcher)
          )
        end
    end

    def cart
      @@cart ||= create :cart
    end

    def order
      @@order ||=
        begin
          calculate_quote
          order = cart.create_order(
            shipping_address: build(:address),
            billing_address: build(:address),
            order_number: "Test-order-number#{rand}"
          )
          order
        end
    end
  end
end

module TestScheduler
  @@scheduled_tests = []

  def self.on_ready(&block)
    @@scheduled_tests << block
    RecordedResponses.init do
      exec_scheduled_tests
    end
  end

  def self.exec_scheduled_tests
    until @@scheduled_tests.empty? do
      @@scheduled_tests.shift.call(RecordedResponses)
    end
  end
end

# These tests are a bit special: they rely on responses from BorderGuru, and we
# dont want to execute tons of requests anew for each test, so the approach
# taken is to get all responses once and then test them. That means shared state
# among the tests. That again means asynchrony issues. To make sure that all tests
# are executed only when their shared state is set up, the tests are queued and
# bulk-executed as soon as RecordedResponses.init is done initialising and yields.
class BorderGuruTest < ActiveSupport::TestCase
  test 'calculate_quote is success' do
    TestScheduler.on_ready do |response|
      assert response.calculate_quote.success?
    end
  end

  test 'calculate_quote echos input request data' do
    TestScheduler.on_ready do |response|
      {
        :sku=>"MyBrand-123456",
        :short_description=>"My Product",
        :price=>1.23,
        :weight=>1.5,
        :weight_scale=>"kg",
        :quantity=>2
      }.each do |key, value|
        assert_equal response.calculate_quote.line_items.first[key.to_s], value
      end
    end
  end

  test 'calculate_quote has line items with tax and duty' do
    TestScheduler.on_ready do |response|
      assert_kind_of ::Numeric, response.calculate_quote.line_items.first['tax']
      assert_kind_of ::Numeric, response.calculate_quote.line_items.first['duty']
    end
  end

  test 'calculate_quote summarises line items tax and duty costs' do
    TestScheduler.on_ready do |response|
      assert_kind_of ::Numeric, response.calculate_quote.tax_and_duty_cost
    end
  end

  test 'calculate_quote returns shipping cost' do
    TestScheduler.on_ready do |response|
      assert_kind_of ::Numeric, response.calculate_quote.shipping_cost
    end
  end

  test 'calculate_quote returns quote currency' do
    TestScheduler.on_ready do |response|
      assert_kind_of ::String, response.calculate_quote.quote_currency
    end
  end

  test 'calculate_quote has totals' do
    TestScheduler.on_ready do |response|
      assert_kind_of ::Numeric, response.calculate_quote.quote_subtotal
      assert_kind_of ::Numeric, response.calculate_quote.total
    end
  end

  test "calculate_quote saves BorderGuru's quoteIdentifier with cart" do
    TestScheduler.on_ready do |response|
      assert_kind_of ::String, response.calculate_quote.quote_identifier
      assert_equal response.calculate_quote.quote_identifier, response.cart.border_guru_quote_id
    end
  end

  test "calculate_quote saves BorderGuru's tax and duty cost with cart" do
    TestScheduler.on_ready do |response|
      assert_kind_of ::Numeric, response.calculate_quote.tax_and_duty_cost
      assert_equal response.calculate_quote.tax_and_duty_cost, response.cart.tax_and_duty_cost
    end
  end

  test "calculate_quote saves BorderGuru's shipment cost with cart" do
    TestScheduler.on_ready do |response|
      assert_kind_of ::Numeric, response.calculate_quote.shipping_cost
      assert_equal response.calculate_quote.shipping_cost, response.cart.shipping_cost
    end
  end

  test 'get_shipping is success' do
    TestScheduler.on_ready do |response|
      assert response.get_shipping.success?
    end
  end

  test 'get_shipping saves shipment identifier with order' do
    TestScheduler.on_ready do |response|
      assert_kind_of ::String, response.get_shipping.shipment_identifier
      assert_equal response.get_shipping.shipment_identifier, response.order.border_guru_shipment_id
    end
  end

  test 'get_shipping saves tracking link with order' do
    TestScheduler.on_ready do |response|
      assert_kind_of ::String, response.get_shipping.link_tracking
      assert_equal response.get_shipping.link_tracking, response.order.border_guru_link_tracking
    end
  end

  test 'get_label is success' do
    TestScheduler.on_ready do |response|
      assert response.get_label.success?
    end
  end

  test 'get_label is a PDF' do
    TestScheduler.on_ready do |response|
      assert_match /PDF/, response.get_label.bindata
    end
  end

  test 'cancel_order is success' do
    TestScheduler.on_ready do |response|
      assert response.cancel_order.success?
    end
  end

  test 'cancel_order has a reason' do
    TestScheduler.on_ready do |response|
      assert response.cancel_order.reason
    end
  end

  test 'announce_dispatch is success' do
    TestScheduler.on_ready do |response|
      assert response.announce_dispatch.success?
    end
  end

end
