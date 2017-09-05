require 'keen'

class KeenDispatcher
  attr_reader :stream, :params

  def initialize
    config!
    @params = {}
  end

  def dispatch!
    publish!
  end

  def user(user)
    @stream = :users
    binding.pry
    @params = user
    @params.merge! full_name: user.decorate.full_name
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
          "ip" : "#{ip}"
        },
        "output": "geo"
      }
    end

    def publish!
      Keen.publish(stream, params)
    end

    def config!
      Keen.project_id = "59ae91bbc9e77c0001f1863b"
      Keen.write_key = "1B0FC1BF5C98F8B92942F174F11AD35162B7188812277F52271F092E0BB9584D91B81F54CA267EEF27B306C8ACD3C4D43B742CFCA40166FFD65BB5FBEA5B35C455458CF53ED7DD4537F4B0FE5262BA6707EAB0BBC34ACD6EFB4173B9EB19E70B"
    end

end
