require 'keen'

# event appearing on the site which we want to use for statistical purpose
# be careful to always differenciate event data from entity data
# here we focus solely on the event ones
# NOTE : this was made in a fast way and is not perfect.
# Feel free to split it up into subclasses
class EventDispatcher
  attr_reader :stream, :params, :cache_id

  # NOTE HOW TO USE
  # EventDispatcher.new.user(User.first).dispatch!
  def initialize
    @params = {}
    @addons = []
  end

  # for every first use of one of the projects
  # this is sample data to switch it on
  def activate!
    keen.publish(:signups,
      username: 'lloyd',
      referred_by: 'harry'
    )
  end

  def dispatch!
    publish!
  end

  def customer_was_registered(user)
    @stream = :customer_registrations
    @params = user.as_json.slice('email', 'nickname', 'provider')
    @params.merge! user_id: user._id, referrer: user.referrer?, visited_our_site: (!user.precreated), registered_at: user.c_at, full_name: user.decorate.full_name
    @addons << addon_datetime(:registered_at)
    self
  end

  def customer_signed_in(user)
    SlackDispatcher.new.message("CUSTOMER SIGNED IN")
    @stream = :customer_authentications
    @params = user.as_json.slice('email', 'nickname', 'provider')
    @params.merge! user_id: user._id, referrer: user.referrer?, full_name: user.decorate.full_name
    self
  end

  def order_was_paid(order)
    @stream = :order_payments
    @cache_id = order.id
    @params = order.as_json.slice('status', 'desc', 'logistic_partner', 'bill_id', 'paid_at', 'marketing', 'shipping_cost', 'exchange_rate', 'coupon_applied_at', 'coupon_discount')
    @params.merge! order_id: order._id, order_items: order.order_items.count
    self
  end

  def already_cached?
    if cache_id
      EventCache.where(stream: stream, cache_id: cache_id).count > 0
    end
  end

  def cache!
    if cache_id
      EventCache.create(stream: stream, cache_id: cache_id)
    end
  end

  private

    def addons
      {
        "keen": {
          "addons": @addons
        }
      }
    end

    # NOTE : this add-on is extremely problematic ; used to crash everything so i removed it.
    # def addon_ip_to_geo(ip)
    #   {
    #     "name": 'keen:ip_to_geo',
    #     "input": {
    #       "ip": "#{ip}"
    #     },
    #     "output": 'ip_to_geo_info'
    #   }
    # end

    def addon_datetime(field)
      {
        "name": 'keen:date_time_parser',
        "input": {
          "date_time": "#{field}"
        },
        "output": "#{field}_info"
      }
    end

    def end_params
      params.merge(addons)
    end

    def publish!
      unless already_cached?
        if Rails.env.development? || Rails.env.test?
          result = EventWorker.new.perform(stream, end_params)
        else
          SlackDispatcher.new.message("ASYNC LAUNCHED")
          result = EventWorker.perform_async(stream, end_params)
        end
        cache!
        result
      end
    end

    def valid_ip?(ip)
      (ip != '::1') && IPAddress.valid?(ip)
    end
end
