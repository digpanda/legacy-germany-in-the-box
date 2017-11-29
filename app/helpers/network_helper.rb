require 'socket'

module NetworkHelper

  def client_country
    request&.location&.data&.[]("country_name")
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
