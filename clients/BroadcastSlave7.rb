
#Broadcast receiver for slave Sonic Pi computer
#written by Robin Newman, March 2021
#user must set set next two lines for this computer

#YOU MUST RUN THIS PROGRAM BEFORE STARTING THE MASTER SONIC PI COMPUTER PROGRAM
#OR YOU WILL SEE NONE FOUND FOR THE CHANNELS FOR THIS COMPUTER REPEATEDLY IN ThE LOG WINDOW
#AND YOU WILL HEAR NOTHING FROM IT


computer=7
set_audio_latency! 234
############################# nothing to alter after this line
set :channel,['none found'] #initialise value channel codes (none yet received)
use_debug false
use_cue_logging false

#function decode extracts channel codes from received OSC data
define :decode do |dl|
  puts  "entry",dl #print current entry
  if dl.is_a? Numeric #check if it is an integer
    return Array(dl) #is so output it as an array element: changes n to [n]
  else
    return dl[1..-2].split(",").map {|str| str.to_i}#changes an entry "[n1,n2,n3]" to [n1,n2,n3]
  end
end

with_fx :reverb,room: 0.8,mix: 0.6 do
  live_loop :pl do
    use_real_time
    b = sync"/osc*/broadcast"
    if b[0]==99 #99 is channel code to receive channel data lists.
      op=[] #start output list
      b.each do |x| #check each element and process using decode
        op << (decode x) #add decoded value to op list
      end
      puts op # show complete decoded list
      #op now contains all machine channel list with array elements for each machine
      op[computer]=['none found'] if op[computer]==nil #update entry for this computer if none found
      set :channel,op[computer]
    end
    channel=get(:channel) #retrieve channel(s) for this computer
    puts "channels for computer no #{computer}",channel
    #if b[0] is not 99 it contains a channel number
    if channel.include? b[0] #proceed if channel codes for this computer includes channel num in b[0]
      use_synth b[5].to_sym #set synth
      use_bpm b[6] #set bpm
      play b[1],sustain: b[2]*b[3],release: b[2]*b[4],amp: b[7] #play note with received settings
    end
  end
end
