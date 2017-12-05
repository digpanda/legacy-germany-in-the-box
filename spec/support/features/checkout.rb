module Helpers
  module Features
    module Checkout
      WAIT_FOR_THE_PAGE = '支付宝 - 网上支付 安全快速！'.freeze
      STREET = '华江里'.freeze
      IDENTITY = '收件人信息'.freeze
      CHOOSE_EXISTING = '请从以下地址中选择'.freeze

      # fill the complete chinese address
      def fill_in_checkout_address!
        expect(page).to have_content(IDENTITY)

        fill_in 'address[fname]', with: '薇'
        fill_in 'address[lname]', with: '李'
        fill_in 'address[mobile]', with: '13802049742'
        fill_in 'address[pid]', with: '11000019790225207X'

        # loop until page.all(:css, '#address_province option')[1]
        # page.all(:css, '#address_province option')[1].select_option
        # loop until page.all(:css, '#address_city option')[1]
        # page.all(:css, '#address_city option')[1].select_option
        # loop until page.all(:css, '#address_district option')[1]
        # page.all(:css, '#address_district option')[1].select_option

        fill_in 'address[full_address]', with: STREET

        # fill_in 'address[zip]', with: '300222'

        page.first('input[type=submit]').trigger('click')

        expect(page).to have_content(CHOOSE_EXISTING)
      end

      # fill in new checkout addresses even if one exists
      def fill_in_with_multiple_addresses!
        expect(page).to have_content(CHOOSE_EXISTING)
        page.first('#button-new-address').trigger('click')
        fill_in_checkout_address!
        page.first('.addresses__address-use a').trigger('click')
      end

      def pay_with_alipay!(mode: :success)

        # WebMock.stub_request(:any, /mapi.alipay.com/).
        # with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        # to_return(status: 200, body: 'fake body', headers: {})

        page.first('.addresses__address-use a').trigger('click')
        on_payment_method_page?
        page.first('a[id=alipay]').trigger('click')
        # NOTE : we use sleep - which is usually evil - because we have to wait the redirection
        # the order payment will be created after the click.
        sleep(0.1)
        # NOTE : we now longer call external services as it is used in acceptance test
        # please make controller tests in parallel of that
        # to make it a more complete testing cycle
        # expect(page).to have_current_path(/alipaydev\.com/, url: true)
        mock_payment!(mode, OrderPayment.first)
      end

      def pay_with_wechatpay!(mode: :success)
        page.first('.addresses__address-use a').trigger('click')
        on_payment_method_page?
        page.first('a[id=wechatpay]').trigger('click')
        # expect(page).to have_css("#order-payment-live-refresh") # wechat qrcode <-- this does not work on test anymore but solely in production
        mock_payment!(mode, OrderPayment.first)
      end

      def mock_payment!(mode, order_payment)
        if mode == :success
          mock_payment_success!(order_payment)
        else
          mock_payment_failure!(order_payment)
        end
      end

      def mock_payment_success!(order_payment)
        order_payment.status = :success
        order_payment.transaction_type = :purchase
        order_payment.order.refresh_status_from(order_payment)
        order_payment.save
      end

      def mock_payment_failure!(order_payment)
        order_payment.status = :failed
        order_payment.transaction_type = :purchase
        order_payment.order.refresh_status_from(order_payment)
        order_payment.save
      end

      # access the manual logistic tracking
      def manual_partner_confirmed?
        visit customer_orders_path
        expect(page).to have_content('创建于')
      end
    end
  end
end
