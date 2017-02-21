require 'socket'

module NetworkHelper

  def from_secondary_domain?
    identity_solver.secondary_domain?
  end

  def server_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
    UDPSocket.open do |server|
      server.connect '64.233.187.99', 1
      server.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

end
