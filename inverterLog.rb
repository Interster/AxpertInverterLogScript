# Log die Voltronic Axpert inverter
# Use the voltronic axpert library
require 'voltronic/protocol'
# Stel die inverter op
proto = Voltronic::Protocol.for_usb('/dev/hidVoltronic')

filenamelog = 'inverterlog_20190404.out'

# Aantal keer wat gelykrigter na mekaar uitskakel
aantalfoute = 0

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
            # Haal uit die linkerhakie wat in die logstring is
            logstring[0] = ""
            
            d = DateTime.now
            tydstring = d.strftime("%d/%m/%Y %H:%M:%S")

            totalestring = tydstring + " " + logstring
            f.puts totalestring
        rescue # optionally: `rescue Exception => ex`
            puts 'Timeout error from inverter'
            aantalfoute = aantalfoute + 1

            if aantalfoute > 10
                puts "Gelykrigter kommunikasie verloor"

                # Wag 5 minute voordat gelykrigter weer opgestel word
                wagbegin = Process.clock_gettime(Process::CLOCK_MONOTONIC)
                wageindig = Process.clock_gettime(Process::CLOCK_MONOTONIC)

                while wageindig - wagbegin < 300.0  do
                    wageindig = Process.clock_gettime(Process::CLOCK_MONOTONIC)
                end

                begin
                    # Stel weer gelykrigter op
                    proto = Voltronic::Protocol.for_usb('/dev/hidVoltronic')

                    puts 'Gelykrigter suksesvol inisialiseer'
                rescue
                    puts 'Kon nie gelykrigter weer inisialiseer nie'
                end

                # Stel foute terug na 0
                aantalfoute = 0
            end
        end 
        
        ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = ending - starting
     end

     puts "Logging finished"
}
