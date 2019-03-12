# Log die Voltronic Axpert inverter
# Use the voltronic axpert library
require 'voltronic/protocol'
# Stel die inverter op
proto = Voltronic::Protocol.for_usb('/dev/hidVoltronic')

filenamelog = 'inverterlog_20190312.out'

open(filenamelog, 'w') { |f|
    timesteplog = 2.0
    numberlogs = 3600

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
       
    elapsed = ending - starting

    puts "Logging starts"

    while elapsed < timesteplog*numberlogs  do
        startcycle = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        endcycle = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        stepelapsed = endcycle - startcycle

        while stepelapsed < timesteplog  do
            endcycle = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            stepelapsed = endcycle - startcycle
        end
        
        puts "Log measurement"
        # Log die meting
        logstring = proto.execute 'QPIGS'
        f.puts logstring


        ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = ending - starting
     end

     puts "Logging finished"
}
