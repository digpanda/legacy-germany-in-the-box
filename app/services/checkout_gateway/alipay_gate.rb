# prepare an order to be transmitted to the Alipay server
class CheckoutGateway
  class AlipayGate < Base
    include Rails.application.routes.url_helpers

    attr_reader :base_url, :user, :order, :payment_gateway, :identity_solver

    def initialize(base_url, user, order, payment_gateway, identity_solver)
      @base_url = base_url
      @user  = user
      @order = order
      @payment_gateway = payment_gateway
      @identity_solver = identity_solver
    end

    # we access the Wirecard::Hpp library and generate the needed datas
    # make a new OrderPayment linked to the request which we will manipulate later on
    def checkout_url!
      prepare_order_payment!
      url
    end

    private

      def raw_url
        @raw_url ||= begin
          if identity_solver.wechat_customer?
            slack.message("[Alipay] TRADE WAP params : #{forex_trade_wap_params}")
            ::Alipay::Service.create_forex_trade_wap_url(forex_trade_wap_params)
          else
            slack.message("[Alipay] TRADE params : #{forex_trade_params}")
            ::Alipay::Service.create_forex_trade_url(forex_trade_params)
          end
        end
      end

      def forex_trade_wap_params
        {
          out_trade_no: "#{order.id}",
          subject: "Order #{order.id}",
          currency: 'EUR',
          rmb_fee: "#{order.end_price.in_euro.to_yuan(exchange_rate: order.exchange_rate).display_raw}",
          return_url: "#{base_url}#{customer_checkout_callback_alipay_path}",
          notify_url: "#{base_url}#{api_webhook_alipay_customer_path}", # "http://alipay.digpanda.ultrahook.com"
        }
      end

      def forex_trade_params
        {
          out_trade_no: "#{order.id}",
          subject: "Order #{order.id}",
          currency: 'EUR',
          rmb_fee: "#{order.end_price.in_euro.to_yuan(exchange_rate: order.exchange_rate).display_raw}",
          return_url: "#{base_url}#{customer_checkout_callback_alipay_path}",
          notify_url: "#{base_url}#{api_webhook_alipay_customer_path}", # "http://alipay.digpanda.ultrahook.com"
        }
      end

      def url
        if Rails.env.production?
          raw_url
        else
          raw_url.gsub('https://mapi.alipay.com/gateway.do?', 'https://openapi.alipaydev.com/gateway.do?')
        end
      end

      def slack
        @slack ||= SlackDispatcher.new
      end
  end
end
