#run_file "/Users/rbn/Documents/SPfromXML/MasterBroadcastScales.rb"
#Broadcast Skeleton for Sonic Pi
#coded by Robin Newman,Feb 2021
#utilises script broadcastOSC.py
use_debug false
use_cue_logging false
use_osc_logging false
titlecode="24 Scales"
use_osc "localhost",8000
computer=get(:computer) #this computer number
computer = 1 if computer == nil #use 1 if computer: not specified

#qt is scale factor for amplitude. Set using :attentuate value
qt=get(:attenuate)
qt=1 if (qt == nil ) #in case attenuate has not been set
qt=[[qt,0].max,1].min

st=0 #start section of multi tempo music
#set_audio_latency! 234 #adjust for latency of computer relative to the others #this value for Mac
#play data sustain and release fracions and synth for each part
s=(ring 1);r=(ring 1);synth=(ring "piano") #parameters for the run. (s,r sustain release fractions)
 
amp=(ring 1)

define :decode do |dl|#return selected channels in an integer array
  puts "entry",dl #print current entry
  if dl.is_a? Numeric
    return Array(dl)
  else
    return dl[1..-2].split(",").map {|str| str.to_i}
  end
end

define :bosc do |num,nv,dv,s,r,synth,tempo,amp,cueval,tr=0| #cueval used to separate tempo sections
  nv.length.times do
    tick
    if nv.look.respond_to?(:each) #deal with chords (played without gap between notes)
      nv.look.each do |v|
        osc "/triggerBroadcast", num, note(v)+tr,  (dv.look),s,r,synth,tempo,amp
      end
    else
      if nv.look!=:r #ignore rests
        osc "/triggerBroadcast", num, note(nv.look)+tr,(dv.look),s,r,synth,tempo,amp
      end
    end
    with_bpm tempo do;sleep dv.look;end
  end
  cue cueval
end

with_fx :reverb,room: 0.8,mix: 0.6 do #add some reverb to playback
  
  live_loop :pl do
    use_real_time
    b = sync"/osc*/broadcast"
    if b[0]==99 #99 is channel code to receive channel data lists
      op=[] #start output list
      b.each do |x| #check each element and process using decode
        op << (decode x)
      end
      #op now contains all machine channel list with array elements for each machine
      op[computer]=["none found"] if op[computer]==nil
      set :channel,op[computer]
    elsif b[0]==10
      sleep 2
      osc_send "localhost",4560,"/playnext",b[1] #send info back to calling buffer
      sleep 0.2
      stop
    end
    channel=get(:channel)
    puts "title code #{titlecode}: tempo #{b[6]}"
    puts "channels for computer no #{computer} #{channel}"
    if channel.include? b[0]
      use_synth b[5].to_sym
      use_bpm b[6]
      play b[1],sustain: b[2]*b[3],release: b[2]*b[4],amp: b[7]
    end
  end
end

########## Allocate channels to be played by each computer here
#computer number               1      2     3     4     5     6     7    8
osc "/triggerBroadcast",99,    0,     1,    2,    3,    4,    5,    6,   7
#osc "/triggerBroadcast",99,    "[0,2,4,6]",     9,    9,    9,    "[1,3,5,7]"#,    5,    6,   7

a1=[:c3,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:c3]
b1=[1]*16
a2=[:r,:d3,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:d3,:r]
b2=[1]*16
a3=[:r,:r,:e3,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:e3,:r,:r]
b3=[1]*16
a4=[:r,:r,:r,:f3,:r,:r,:r,:r,:r,:r,:r,:r,:f3,:r,:r,:r]
b4=[1]*16
a5=[:r,:r,:r,:r,:g3,:r,:r,:r,:r,:r,:r,:g3,:r,:r,:r,:r]
b5=[1]*16
a6=[:r,:r,:r,:r,:r,:a3,:r,:r,:r,:r,:a3,:r,:r,:r,:r,:r]
b6=[1]*16
a7=[:r,:r,:r,:r,:r,:r,:b3,:r,:r,:b3,:r,:r,:r,:r,:r,:r]
b7=[1]*16
a8=[:r,:r,:r,:r,:r,:r,:r,:c4,:c4,:r,:r,:r,:r,:r,:r,:r]
b8=[1]*16

 c=(ring 390,400,410,420,430,440,450,460,470,480,490,500,510,520,530,540,550,560,570,580,590,600,610,620)
 in_thread do
     24.times do |i|
     in_thread do
       bosc 0,a1,b1,s[0],r[0],synth[0],c[i],amp[0]*qt,:cont0,i
     end
     in_thread do
       bosc 1,a2,b2,s[1],r[1],synth[1],c[i],amp[1]*qt,:cont1,i   
     end
      in_thread do
       bosc 2,a3,b3,s[2],r[2],synth[2],c[i],amp[2]*qt,:cont2 ,i  
     end
     in_thread do
       bosc 3,a4,b4,s[3],r[3],synth[3],c[i],amp[3]*qt,:cont3 ,i  
     end
     in_thread do
       bosc 4,a5,b5,s[4],r[4],synth[4],c[i],amp[4]*qt,:cont4 ,i  
     end
     in_thread do
       bosc 5,a6,b6,s[5],r[5],synth[5],c[i],amp[5]*qt,:cont5  ,i 
     end
     in_thread do
       bosc 6,a7,b7,s[6],r[6],synth[6],c[i],amp[6]*qt,:cont6 ,i  
     end
     in_thread do
       bosc 7,a8,b8,s[7],r[7],synth[7],c[i],amp[7]*qt,:cont7  ,i 
     end
     sync :cont7
   end
sleep 0.2
   osc "/triggerBroadcast",10,"finished12" #kill player for first part in program above
 end
