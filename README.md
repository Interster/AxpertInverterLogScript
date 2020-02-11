# Howto use the ruby scripts with the axpert

Installation from the following source:

https://github.com/jovandervyver/voltronic_power_interface

This entails the installation of the voltronic_power_interface ruby gem.

`gem install voltronic_power_interface`

Note this gem works best with ruby version 2.5.0.  Some syntax used in this gem is deprecated in later ruby versions.

You must sudo install the HIDRaw driver before anything will work.  This entails downloading the *.deb file if the operating system does not have HIDRaw in the package manager.

Then do the following setting by executing the following command line statement:

`echo 'ATTRS{idVendor}=="0665", ATTRS{idProduct}=="5161", SUBSYSTEMS=="usb", ACTION=="add", MODE="0666", GROUP="root", SYMLINK+="hidVoltronic"' > /etc/udev/rules.d/35-voltronic.rules`

This does not work on some computers.  So just add the stuff in the file manually by making the file using touch and putting the contents in the file after the echo command manually.




# Screenshot of how to use the ruby gem for controlling the Axpert

The POP00 command sets the inverter to line mode, while the POP01 command sets it to solar first.
The following text was captured from the command line to show how it works in interactive ruby:


    niel@asenna:~/inverter/AxpertInverterLogScript$ irb
    irb(main):001:0> require 'voltronic/protocol'
    => true
    irb(main):002:0> proto = Voltronic::Protocol.for_usb('/dev/hidVoltronic')
    => Protocol(IO)
    irb(main):003:0> proto.execute 'QPI'
    => "(NAK"
    irb(main):004:0> proto.execute 'QPIGS'
    => "(233.4 50.0 233.4 50.0 0513 0469 011 456 56.40 010 095 0048 0000 000.0 00.00 00000 01010101 00 00 00000 010"
    irb(main):005:0> proto.execute 'POP00'
    => "(ACK"
    irb(main):006:0> proto.execute 'POP01'
    => "(ACK"
    irb(main):007:0> proto.execute 'POP02'
    => "(ACK"
    irb(main):008:0> proto.execute 'POP00'
    => "(ACK"
    irb(main):009:0> 

# Scheduling

It is useful to schedule the logging task using the cron service in linux.

Type 

`crontab -e`

in the terminal to edit the scheduler.  Then add a line to start logging at for example 00:00 or 12o'clock at night:

`0 0 * * * ruby /home/AxpertInverterLogScript/inverterLog.rb`

Some installs require absolute paths for the ruby install.  An example is given here:

`# Skakel inverter aan om batterykrag eerste te gebruik
0 5 * * * /home/ubuntu/.rbenv/versions/2.5.0/bin/ruby /home/ubuntu/clones/AxpertInverterLogScript/inverterOn.rb
# Skakel inverter af en gebruik lyn eerste
0 16 * * * /home/ubuntu/.rbenv/versions/2.5.0/bin/ruby /home/ubuntu/clones/AxpertInverterLogScript/inverterOff.rb
# Log die inverter se aktwiteit vir 24 uur
0 0 * * * /home/ubuntu/.rbenv/versions/2.5.0/bin/ruby /home/ubuntu/clones/AxpertInverterLogScript/inverterLog.rb
`

# Inverter Control

The inverter can be switched to different modes, eg. solar first, utility first or SBU (battery first).  The inverterOn.rb and inverterOff.rb scripts are examples of this.  The command to switch the inverter to line first is:

`proto.execute 'POP00`

The command to switch the inverter to solar first is:

`proto.execute 'POP01`

The command to switch the inverter to battery first is:

`proto.execute 'POP02`





# Alternatiewe metodes om Axpert met python te beheer

Gebruik die volgende bronne om 'n python intervlak te maak vir die Axpert.  Moet dan die battery hierby integreer.



Webwerf waar hulle die Axpert logging bespreek:

 https://forums.aeva.asn.au/viewtopic.php?t=5830&start=100 

Repositories met logging sagteware:

 https://github.com/JosefKrieglstein/AxpertControl 

 https://github.com/jvandervyver/VoltronicLibJava 

 https://github.com/MindFreeze/hassio-axpert 