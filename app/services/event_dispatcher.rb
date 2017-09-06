require 'keen'

# event appearing on the site which we want to use for statistical purpose
# be careful to always differenciate event data from entity data
# here we focus solely on the event ones
class EventDispatcher
  attr_reader :stream, :params

  # NOTE HOW TO USE
  # EventDispatcher.new.user(User.first).with_geo(ip: '0.0.0.0').dispatch!
  def initialize
    config!
    @params = {}
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
    self
  end

  # TODO : place it
  def customer_signed_in(customer)
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
    @params.merge addon_ip_to_geo(ip)
    self
  end

  private

    def addon_ip_to_geo(ip)
      {
        "name": "keen:ip_to_geo",
        "input": {
          "ip": "#{ip}"
        },
        "output": "geo"
      }
    end

    def publish!
      if Rails.env.development?
        keen.publish(stream, params)
      else
        keen.delay.publish(stream, params)
      end
    end

    def keen
      @keen ||= Keen::Client.new(
        :project_id => ENV['keen_project_id'],
        :write_key => ENV['keen_write_key'],
        :read_key =>ENV['keen_read_key'],
      )
    end

end
