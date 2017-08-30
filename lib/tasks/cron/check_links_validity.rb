require 'net/ping'

class Tasks::Cron::CheckLinksValidity
  attr_reader :links

  def initialize
    @links = Link.all
  end

  def perform
    puts 'We will check all the Links for validity ...'
    links.each do |link|
      if valid?(link)
        link.update(valid_url: true)
        puts "[VALID] Link `#{link.id}` is a valid URL `#{link.raw_url}`"
      else
        link.update(valid_url: false)
        Notifier::Admin.new.unvalid_link_detected(link)
        puts "[UNVALID] Link `#{link.id}` is not a valid URL `#{link.raw_url}` (Notification was sent to the administrators.)"
      end
    end
    puts 'End of process.'
  end

  private

    def valid?(link)
      Net::Ping::External.new(link.raw_url).ping
    end
end
