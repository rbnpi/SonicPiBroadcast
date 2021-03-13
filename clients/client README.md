
This folder cotains 7 client programs. They are identical apart from the two configurations lines 

`computer = n`
`set_audio_latency! xxx`

The former must be different for each client computer. (normally computer = 1 would be used for the master machine, although it could have a differnt number of required)

Assigning latency numbers

First make sure the pythonscript `broadcastOSC.py` is running on the master computer in a terminal. NB you will need to install the python library python-osc for this to work using `pip3 install python-osc` (using `sudo` on a RASPBERRY PI)
Different computers will have differnt latency values. We want them all to play in sync. This is accomplished using the program `00-BroadcastSync.rb` This is played on the master computer, and the output channels are adjusted in turn, so that 2 computers at a time are receiving on channel 0. This plays a sequence of percussing plucked notes, and the idea is to adjust the latency settings of the computers so that they sound at the same time.
Start with the master computer and the computer with the poorest latency (i.e. the one where there is the biggest delay between a note being played, and it sounding). Arbitrarily set the latency setting correction for this machine to a low number like 30. (This allows some wiggle room. In my case this was on computer 8) The program `00-BroadcastSync.rb` is short enough to fit into a Sonic Pi buffer, so load it on your master computer. To aid the setting process make three temporary changes: no need to save them.
uncomment `line 25` and set an approximate value for the audo latency value for the computer. I suggest 230 for a Mac or windows PC and 50 for a Raspberry Pi
adjust lines 88 and 89 as suggested in their comments increasing the 10 to 100 and the 20 to 200. This gives a longer sequence in which to make the adjustment.
Now set line 15 so that the computers you want to play have channel 0 selected, and the others are all set to 1.
eg `osc "/triggerBroadcast",99,    0,     1,    1,    1,    1,    1,    1,    0`
would let machines 1 and 8 sound. 
Make sure the client machines are all running their program, then run the BroadcastSync program. You should hear two plucked notes. The aim is to get them sounding at exactly the same time. If the master computer sounds AFTER the slave one, then REDUCE the latency number in line 25, and re-run to try again. If the master machine sounds BEFORE the slave one, then INCREASE its latency number to delay it.
Once the master setting is complete, make a note of the number, which you will transfer to the set_audio_latency! line at the beginning of the `broadcastplaylist.rb` program.
Now keep the master computer selected and choose a differnt slave machine to accompany it. eg set line 15 to
eg `osc "/triggerBroadcast",99,    0,     1,    1,    1,    1,    1,    0,    1`
which selects machine 1 and machine 7. Run the BroadcastSync program again, but this time adjusty the latency setting directly on the `BroadcastSlave.rb` running on machine 7 until it sounds in sync with the master. Once again alter the number, reducing it if machine 7 sounds late, and increasing it if it sounds early.
The process is repeated until all the machines have been adjusted. Finally you can check by setting all available machines to play (in line 15) and they should all play in unison. 
Load in the `broadcastplaylist.rb` program to the master computer, and set the latency setting to the one you noted, and you can then resave this program to keep that setting.

You will get further insight into the program operation by viewing the video. There are some improvements that have been made to the programs since it was filmed but it is essentially the same as the code in this repository.