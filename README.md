*Sonic Pi Broadcast Orchestra Overview*

This repository contains files in the broadcast folder
which enable Sonic Pi to synchronise several slave machines
so that they can all participate in playing a multi part piece of music. It is intended for linear pieces, but could be adapted to send cues to enable remote live_loops to be started or stopped.

The computers concernedc should be on the same local network, and connected directly via an ethernet cable, not by wireless, for accurate timing.

It depends on a python script broadcastOSC.py which enables a Sonic Pi master machine to send broadcast OSC messages to any other computer on teh same local network. It is self configuring, in that it sends an initial message which tells each slave computer which "parts" or sequences of messages to respond to. It is possible to have several compugters playing the same part, or for a computer to be configured to play several parts. The development system utilised 8 computers, (two Macs, one Windows PC laptop, 5 Raspberry Pi computers {including Pi4, Pi400 and Pi3B+} ) all of which were running Sonic Pi 3.3.1.

The slave computers run indetical programs (contained in the clients folder), each with two configuration lines. One specifies the computer number 1,2,3,4...... and the second specifies the `set_audio_latecy!` setting for each machine. The value for this varies with the computer, and in particular for the audio interface that Sonic Pi is utilising. A setup program `00-BroadcastSync.rb` is used to allow the value to be adjusted on two computers at a time so that they are synchronised in playing a stream of percussive notes. This is a one off process to set up the "orchestra"

The python script is run in a terminal window on the master computer, and normally does not require paramaters. It is set to listen on the localhost for incoming messages on port 8000 addressed to
/triggerBroadcast These can contain up to 10 pieces of data in the form of numbers or strings. The script reconstitutes the message and sends it to the network broadcast address (supplied configured for 192.168.1.255) to port 4560, the cue listening port on Sonic Pi.

The master computer will normally run the program `broadcastplaylist.rb`
This is because most of the programs will be too long to fit into a Sonic Pi buffer and need to be executed using the Sonic Pi run_file command. The system at present has 16 playable files, numbered from 00 to 15. This includes file `00-BroadcastSync.rb` already mentioned above. It also supplies four configuration settings.
`set :attenuate` which will set a global volume attenuator in the range 0 to 1 which eanbles you automatically to scale the volume at which a piece is played. Secondly  the `set :computer` line specifies the number assigned to the master computer (normally 1) Third, the `set_audio_latency!` setting for the master computer. This obviates having to change this setting for each of the 16 playing programs if you alter the master machine. YOu only have to change it here. Finally the `path` to where the program broadcast folder is located on your system.

You can select which of the programs you want to play by commenting out the block of four lines associated with the ones you do not wish to run. You can also alter the order if you wish, by cutting and pasting the four line blocks into the order you prefer, but should not alter the names.

Some programs are quite long. If they have tempo changes, then it is possible to start playing from one of the tempo changes by adjusting the variable `st` (usually set to 0). Thus setting `st = 3` would start playing the program from the third tempo change, omitting the first two sections.

A separate document describe the setup process for adjusting the audio sync, and there is a 54 minute video showing the program in use which will be helpful. https://youtu.be/6Vxcw9I77fY