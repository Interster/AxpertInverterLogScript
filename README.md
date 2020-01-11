# Howto use the ruby scripts with the axpert

Installation from the following source:

https://github.com/jovandervyver/voltronic_power_interface

This entails the installation of the voltronic_power_interface ruby gem.

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

# Inverter Control

The inverter can be switched to different modes, eg. solar first, utility first or SBU (battery first).  The inverterOn.rb and inverterOff.rb scripts are examples of this.  The command to switch the inverter to line first is:

`proto.execute 'POP00`

The command to switch the inverter to solar first is:

`proto.execute 'POP01`

The command to switch the inverter to battery first is:

`proto.execute 'POP02`
