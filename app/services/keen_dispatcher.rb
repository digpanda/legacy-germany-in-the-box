require 'keen'

class KeenDispatcher
  attr_reader :stream, :params

  # NOTE HOW TO USE
  # KeenDispatcher.new.user(User.first).with_geo(ip: '0.0.0.0').dispatch!
  def initialize
    config!
    @params = {}
  end

  def dispatch!
    publish!
  end

  def user(user)
    @stream = :users
    @params = user.as_json.slice('email', 'nickname', 'precreated', 'provider', 'role')
    @params.merge! referrer: user.referrer?, registered_at: user.c_at, user_id: user._id, full_name: user.decorate.full_name
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
        Keen.publish(stream, params)
      else
        Keen.delay.publish(stream, params)
      end
    end

    def config!
      Keen.project_id = ENV['keen_project_id']
      Keen.write_key = ENV['keen_write_key']
    end

end
