# Lees waarskuwings en foute vanaf die inverter
require 'voltronic/protocol'
# Stel die inverter op
proto = Voltronic::Protocol.for_usb('/dev/hidVoltronic')

logstring = proto.execute 'QPIWS'

puts 'Waarskuwings'
puts logstring