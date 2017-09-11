require 'keen'

# event appearing on the site which we want to use for statistical purpose
# be careful to always differenciate event data from entity data
# here we focus solely on the event ones
# NOTE : this was made in a fast way and is not perfect.
# Feel free to split it up into subclasses
class EventDispatcher
  attr_reader :stream, :params

  # NOTE HOW TO USE
  # EventDispatcher.new.user(User.first).with_geo(ip: '0.0.0.0').dispatch!
  def initialize
    @params = {}
    @addons = []
  end

  # for every first use of one of the projects
  # this is sample data to switch it on
  def activate!
    keen.publish(:signups, {
      :username => "lloyd",
      :referred_by => "harry"
    })
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
    @stream = :customer_authentications
    @params = user.as_json.slice('email', 'nickname', 'provider')
    @params.merge! user_id: user._id, referrer: user.referrer?, full_name: user.decorate.full_name
    self
  end

  # TODO : place it
  def order_was_paid(order)
    @stream = :order_payments
    # @params = order.as_json.slice('email', 'nickname', 'precreated', 'provider', 'role')
    # @params.merge! referrer: user.referrer?, registered_at: user.c_at, user_id: user._id, full_name: user.decorate.full_name
    self
  end

  def with_geo(ip: '')
    if IPAddress.valid? ip
      @addons << addon_ip_to_geo(ip)
    end
    self
  end

  private

  def addons
    {
      "keen": {
        "addons": @addons
      }
    }
  end

    def addon_ip_to_geo(ip)
      {
        "name": "keen:ip_to_geo",
        "input": {
          "ip": "#{ip}"
        },
        "output": "ip_to_geo_info"
      }
    end

    def addon_datetime(field)
      {
        "name": "keen:date_time_parser",
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
      if Rails.env.development? || Rails.env.test?
        keen.publish(stream, end_params)
      else
        keen.delay.publish(stream, end_params)
      end
    # geo may blow up because of some weird IP result
    # we ensure it does not block the system
    rescue Keen::HttpError => exception
    end

    # this will be thread-safe
    def keen
      @keen ||= Keen::Client.new(
        :project_id => ENV['keen_project_id'],
        :write_key => ENV['keen_write_key'],
        :read_key =>ENV['keen_read_key'],
      )
    end

end
