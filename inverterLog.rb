# Log die Voltronic Axpert inverter
# Use the voltronic axpert library
require 'voltronic/protocol'
# Stel die inverter op
proto = Voltronic::Protocol.for_usb('/dev/hidVoltronic')

filenamelog = 'inverterlog_20190402.out'

open(filenamelog, 'w') { |f|
    timesteplog = 10.0
    numberlogs = 6000

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
        
        #measurenum = "Log measurement" + elapsed.to_s
        measurenum = "Log measurement #{elapsed.round(2)}"

        # Print the measurement number
        puts measurenum

        begin  # "try" block
            # Log die meting
            logstring = proto.execute 'QPIGS'

            d = DateTime.now
            tydstring = d.strftime("%d/%m/%Y %H:%M:%S")

            totalestring = tydstring + " " + logstring
            f.puts logstring
        rescue # optionally: `rescue Exception => ex`
            puts 'Timeout error from inverter'
        end 
        
        ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = ending - starting
     end

     puts "Logging finished"
}
