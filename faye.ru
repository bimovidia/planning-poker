require 'faye'

Faye::WebSocket.load_adapter('thin')

bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run bayeux