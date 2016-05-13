require 'rails_helper'
require 'border_guru'

class RecordedResponses
  class << self
    include FactoryGirl::Syntax::Methods

    @@initialization_state = :uninitialized

    def init
      if @@initialization_state == :uninitialized
        @@initialization_state = :ongoing

        @@shop = create :shop
        @@product = @@shop.products.first
        @@sku = @@product.skus.first
        @@sender_address = @@shop.sender_address

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
          cart.add @@sku, 2

          BorderGuru.calculate_quote(
            cart: cart,
            shop: @@shop,
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
            shop: @@shop,
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
            dispatcher: @@sender_address
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
            shipping_address: @sender_address,
            billing_address: @sender_address
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
describe 'BorderGuruTest' do
  it 'calculate_quote is success' do
    TestScheduler.on_ready do |response|
      assert response.calculate_quote.success?
    end
  end
end
