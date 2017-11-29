require 'socket'
require 'geoip'

module NetworkHelper

  def client_country
    geoip = GeoIP.new("#{Rails.root}/vendor/geo/GeoIP.dat.gz")
    remote_ip = request.remote_ip
    unless ['127.0.0.1', '::1'].include? remote_ip
      location_location = geoip.country(remote_ip)
      if location_location != nil
        return location_location[2]
      end
    end
  end

  def server_ip
    unless Rails.env.development? || Rails.env.test?
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
      UDPSocket.open do |server|
        server.connect '64.233.187.99', 1
        server.addr.last
      end
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
end
