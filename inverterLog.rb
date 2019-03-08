# Log die Voltronic Axpert inverter
# Use the voltronic axpert library
require 'voltronic/protocol'
# Stel die inverter op
#proto = Voltronic::Protocol.for_usb('/dev/hidVoltronic')

filenamelog = 'inverterlog_20190101.out'

open(filenamelog, 'w') { |f|
    f.puts "Hello, world."
    timesteplog = 2.0
    numberlogs = 5

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
       
    elapsed = ending - starting

    f.puts "Logging starts"

    while elapsed < timesteplog*numberlogs  do
        puts("Log step" )

        startcycle = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        endcycle = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        stepelapsed = endcycle - startcycle

        while stepelapsed < timesteplog  do
            endcycle = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            stepelapsed = endcycle - startcycle
        end
        
        f.puts "Log measurement"
        # Log die meting
        #logstring proto.execute 'QPIGS'
        #f.puts logstring


        ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = ending - starting
     end

     f.puts "Logging finished"
}