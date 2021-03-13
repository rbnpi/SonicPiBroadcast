#Sonic Pi Broadcast Orchestra playlist
#by Robin Newman, March 2021
#requires additional slave computers set up on the same local network, running BroadcastSlave.rb
#also script broadcastOSC.py to be running on this computer

set :attenuate,  0.8 #set global volume attentuation (0->1) affects volume of ALL computers
set :computer,1 #set the computer number for this computer (usually 1)
set_audio_latency! 234 #for THIS computer. #adjust with aid of program 1
pathToFiles="~/Desktop/SonicPiBroadcast/broadcast/" #point to folder where files are stored

define :detectend do |val| #used to handle end of program timing before next one starts
  b = sync "/osc*/playnext"
  stop if b[0]!=val
  cue val.to_sym
end

#All other computers in the orchestra should be runningg before starting this

#list of pieces follows. You can commnet out ones you don;t wnat to hear
#you can reorder by moving order of 4 line sections around, but do not rename

run_file pathToFiles+"00-BroadcastSync.rb"
detectend "finished00" #detect finished from this program
sync :finished00 #cue to start nect program
sleep 2 #this sleep is necessary. Can be longer, but shouldn't be less than 2

run_file pathToFiles+"01-BroadcastBachOrchestralSuite2.rb"
detectend "finished01"
sync :finished01
sleep 2

run_file pathToFiles+"02-BroadcastHassler.rb"
detectend "finished02"
sync :finished02
sleep 2

run_file pathToFiles+"/03-BroadcastBachCanzonaInDminor.rb"
detectend "finished03"
sync :finished03
sleep 2

run_file pathToFiles+"04-BroadcastBachContrapunctus1.rb"
detectend "finished04"
sync :finished04
sleep 2

run_file pathToFiles+"05-BroadcastBachContrapunctus9.rb"
detectend "finished05"
sync :finished05
sleep 2

run_file pathToFiles+"06-BroadcastBachFantasia.rb"
detectend "finished06"
sync :finished06
sleep 2

run_file pathToFiles+"07-BroadcastBeatusVir.rb"
detectend "finished07"
sync :finished07
sleep 2

run_file pathToFiles+"08-BroadcastDanserey.rb"
detectend "finished08"
sync :finished08
sleep 2

run_file pathToFiles+"09-BroadcastPraetoriusSpringtanz6.rb"
detectend "finished09"
sync :finished09
sleep 2

run_file pathToFiles+"10-BroadcastPraetoriusVeniteExsultamus.rb"
detectend "finished10"
sync :finished10
sleep 2

run_file pathToFiles+"11-BroadcastFrereJaques.rb"
detectend "finished11"
sync :finished11
sleep 2

run_file pathToFiles+"12-BroadcastScales.rb"
detectend "finished12"
sync :finished12
sleep 2

run_file pathToFiles+"13-BroadcastVivaldiBachConcerto.rb"
detectend "finished13"
sync :finished13
sleep 2

run_file pathToFiles+"14-BroadcastThemeFromSchindlersList.rb"
detectend "finished14"
sync :finished14
sleep 2

run_file pathToFiles+"15-BroadcastSalomoneRossiBergamasca.rb"
detectend "finished15"
sync :finished15


