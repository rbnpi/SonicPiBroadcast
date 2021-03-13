#03-BroadcastBachCanzonainDminor.rb
#Broadcast Version for Sonic Pi
#coded by Robin Newman,Feb 2021
#utilises script broadcastOSC.py
use_debug false
use_cue_logging false
use_osc_logging false
titlecode="03 Bach Canzona in D minor"
use_osc "localhost",8000
computer=get(:computer) #this computer number
computer = 1 if computer == nil #use 1 if computer: not specified


#qt is scale factor for amplitude. Set using :attentuate value
qt=get(:attenuate)
qt=1 if (qt == nil ) #in case attenuate has not been set
qt=[[qt,0].max,1].min

st=0 #start section of multi tempo music
#set_audio_latency! 234 #adjust for latency of computer relative to the others
#play data sustain and release fracions and synth for each part
s=(ring 0.95);r=(ring 0.05);synth=(ring "tri","tri","saw","saw") #parameters for the run. (s,r sustain release fractions)

amp=(ring 0.3,0.3,0.3,0.175)

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
#computer number               1     2     3     4     5     6     7     8
osc "/triggerBroadcast",99,    0,    0,    1,    1,    2,    2,    3,    3
#osc "/triggerBroadcast",99,    " [  0,1]",    9,    9,    9,    "[2,3]"#,    2,    3,    3
sleep 0.2#belt and braces: allow a short time to make sure received and procdssed

  a1=[]
  b1=[]
  a1[0]=[:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:A4,:D5,:D5,:F5,:E5,:D5,:C5,:D5,:E5,:D5,:C5,:B4,:Cs5,:D5,:A4,:D5,:C5,:B4,:C5,:B4,:A4,:B4,:A4,:Af4,:A4,:Af4,:A4,:B4,:Af4,:A4,:A4,:B4,:Cs5,:B4,:Cs5,:D5,:C5,:Bf4,:A4,:G4,:A4,:Bf4,:A4,:Bf4,:C5,:F5,:E5,:D5,:G5,:F5,:E5,:C5,:F5,:Ef5,:D5,:C5,:Bf4,:A4,:r,:r,:r,:D5,:Cs5,:C5,:B4,:Bf4,:A4,:G4,:A4,:D5,:G4,:A4,:G4,:Fs4,:E4,:D4,:G4,:Fs4,:E4,:Fs4,:G4,:r,:F5,:E5,:A5,:G5,:F5,:E5,:D5,:Bf5,:A5,:G5,:C6,:C6,:Bf5,:A5,:Bf5,:Bf5,:A5,:G5,:A5,:A4,:B4,:Cs5,:D5,:E5,:F5,:E5,:D5,:G5,:F5,:E5,:F5,:A5,:G5,:F5,:G5,:F5,:E5,:D5,:C5,:D5,:E5,:D5,:C5,:B4,:C5,:D5,:Cs5,:D5,:E5,:A4,:B4,:C5,:B4,:C5,:D5,:Af4,:Fs4,:E4,:A4,:G4,:Fs4,:Af4,:A4,:Af4,:D5,:C5,:B4,:C5,:D5,:E5,:F5,:E5,:D5,:E5,:D5,:Cs5,:D5,:Cs5,:C5,:B4,:Bf4,:A4,:C5,:A4,:D5,:F5,:D5,:G5,:A5,:Bf5,:D5,:D5]
  b1[0]=[4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,3.0,0.5,0.5,2.5,0.5,0.5,0.5,1.5,0.5,1.0,1.0,1.0,0.5,0.5,2.0,2.0,2.0,2.0,1.0,1.0,1.0,0.5,0.5,1.0,0.5,0.5,1.0,0.5,0.5,0.5,0.5,2.0,1.0,2.0,2.0,4.0,2.0,2.0,4.0,2.0,2.0,2.0,2.0,2.0,1.0,0.5,0.5,3.0,1.0,3.0,0.5,0.5,1.0,0.5,0.5,3.0,0.5,0.5,2.0,2.0,1.0,1.0,2.0,0.5,0.5,0.5,0.5,2.5,0.5,0.5,0.5,2.5,0.5,0.5,0.5,2.0,0.5,0.5,1.0,0.5,0.5,0.5,0.5,0.25,0.25,0.5,0.5,0.5,3.0,0.5,0.5,1.0,0.5,0.5,0.5,0.5,0.5,0.5,1.0,0.5,0.5,1.0,0.5,0.5,1.5,0.5,0.5,0.5,0.5,0.5,1.0,0.5,0.5,1.0,0.5,0.5,1.0,0.5,0.5,1.5,0.5,1.0,0.5,0.5,1.0,2.0,0.5,0.5,1.0,2.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,2.0,2.0,2.0,2.0,2.0,3.0,0.5,0.5,1.0,0.5,0.5,1.0,0.5,0.5,1.5,0.5]
  a1[1]=[:D5,:E5,:F5,:G5]
  b1[1]=[1.0,0.5,0.25,0.25]
  a1[2]=[:Cs5,:D5,:D5]
  b1[2]=[1.5,0.5,2.0]
  c1=[120,90,70]
amp1=[0.8,0.9,1]
in_thread do
  for i in st..a1.length-1
    in_thread do
      bosc 0,a1[i],b1[i],s[0],r[0],synth[0],c1[i],amp[0]*qt,:cont0
    end
    sync :cont0
  end
    sleep 0.2
  osc "/triggerBroadcast",10,"finished03"
end

a2=[]
  b2=[]
  a2[0]=[:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:G4,:D5,:D5,:Ef5,:D5,:C5,:Bf4,:C5,:D5,:C5,:Bf4,:A4,:Bf4,:C5,:G4,:C5,:Bf4,:A4,:Bf4,:A4,:G4,:A4,:D4,:G4,:A4,:Bf4,:A4,:Bf4,:C5,:D5,:D5,:Cs5,:C5,:B4,:Bf4,:A4,:G4,:A4,:D5,:Bf4,:A4,:A4,:Af4,:A4,:G4,:Fs4,:G4,:A4,:G4,:A4,:B4,:A4,:B4,:C5,:Bf4,:A4,:Bf4,:C5,:Bf4,:C5,:D5,:C5,:Bf4,:Ef5,:D5,:C5,:F5,:Ef5,:D5,:C5,:Bf4,:A4,:Bf4,:C5,:Fs4,:G4,:A4,:Bf4,:A4,:B4,:C5,:B4,:C5,:C5,:Bf4,:A4,:G4,:r,:r,:r,:r,:r,:r,:G4,:D5,:D5,:Ef5,:D5,:C5,:Bf4,:C5,:D5,:C5,:Bf4,:A4,:Bf4,:C5,:G4,:C5,:Bf4,:A4,:Bf4,:A4,:G4,:A4,:D4,:G4,:Fs4,:E4,:Fs4,:G4,:r,:r,:D5,:Cs5,:C5,:B4,:Bf4,:A4,:D4,:G4,:A4,:B4,:C5,:D5,:D5,:C5,:D5,:Ef5,:A4,:r,:r,:D5,:C5,:Bf4,:A4,:G4,:A4,:Bf4,:A4,:Cs5,:Cs5]
  b2[0]=[4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,3.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,1.0,0.5,0.5,3.0,1.0,2.0,2.0,3.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,0.5,0.5,2.0,2.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,2.0,1.0,1.0,2.0,2.0,2.0,0.5,0.5,1.0,0.5,0.5,2.0,1.0,0.5,0.5,1.0,0.5,0.5,1.5,0.5,1.0,0.5,0.5,1.0,1.0,4.0,4.0,4.0,4.0,2.0,2.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,3.0,1.0,3.0,0.5,0.5,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,3.0,1.0,4.0,3.0,1.0,2.0,2.0,4.0,3.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,6.0,2.0,1.5,0.5]
  a2[1]=[:Cs5,:A4,:G4]
  b2[1]=[1.0,0.5,0.5]
  a2[2]=[:A4,:Bf4]
  b2[2]=[2.0,2.0]
  c2=[120,90,70]
amp2=[0.5,0.7,0.9]
in_thread do
  for i in st..a2.length-1
    in_thread do
      bosc 1,a2[i],b2[i],s[1],r[1],synth[1],c2[i],amp[1]*qt,:cont1,-5 #add transpose
    end
    sync :cont1
  end
end

 a3=[]
  b3=[]
  a3[0]=[:r,:r,:r,:r,:r,:r,:r,:r,:A3,:D4,:D4,:F4,:E4,:D4,:C4,:D4,:E4,:D4,:C4,:B3,:C4,:D4,:A3,:D4,:C4,:B3,:C4,:B3,:A3,:B3,:A3,:B3,:Cs4,:D4,:r,:E4,:F4,:r,:D4,:Cs4,:C4,:B3,:Bf3,:A3,:G3,:A3,:D4,:G3,:A3,:G3,:F3,:G3,:A3,:Bf3,:A3,:G3,:F3,:G3,:A3,:B3,:A3,:G3,:A3,:B3,:Af3,:A3,:F4,:E4,:D4,:C4,:B3,:C4,:B3,:A3,:B3,:A3,:r,:r,:r,:r,:r,:r,:r,:r,:D3,:A3,:A3,:Bf3,:A3,:G3,:F3,:G3,:A3,:G3,:F3,:E3,:Fs3,:G3,:D3,:G3,:F3,:E3,:F3,:Ef3,:D3,:Ef3,:D3,:Ef3,:D3,:C3,:D3,:D4,:Cs4,:C4,:B3,:Bf3,:A3,:D4,:G3,:F3,:Bf3,:E3,:A3,:r,:r,:r,:r,:r,:r,:D3,:A3,:A3,:Bf3,:A3,:G3,:F3,:G3,:A3,:G3,:F3,:E3,:F3,:G3,:D3,:G3,:Fs3,:E3,:Fs3,:G3,:A3,:Bf3,:C4,:D4,:F4,:F4]
  b3[0]=[4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,2.0,1.0,0.5,0.5,3.0,1.0,3.0,0.5,0.5,3.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,3.0,0.5,0.5,2.0,3.0,1.0,1.0,0.5,0.5,3.0,0.5,0.5,3.0,0.5,0.5,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,2.0,3.0,0.5,0.5,2.0,4.0,2.0,2.0,2.0,2.0,2.0,3.0,1.0,4.0,3.0,1.0,2.0,4.0,2.0,4.0,4.0,4.0,4.0,2.0,2.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,2.0,1.0,1.0,1.0,1.0,8.0,1.5,0.5]
  a3[1]=[:F4]
  b3[1]=[2.0]
  a3[2]=[:E4,[:A3,:D4]]
  b3[2]=[2.0,2.0]
  c3=[120,90,70]
amp3=[0.5,0.7,0.9]
in_thread do
  for i in st..a3.length-1
    in_thread do
      bosc 2,a3[i],b3[i],s[2],r[2],synth[2],c3[i],amp[2]*qt,:cont2
    end
    sync :cont2
  end
end

  a4=[]
  b4=[]
  a4[0]=[:r,:D3,:A3,:A3,:Bf3,:A3,:G3,:F3,:G3,:A3,:G3,:F3,:E3,:F3,:G3,:D3,:G3,:F3,:E3,:F3,:E3,:D3,:E3,:D3,:E3,:F3,:E3,:F3,:G3,:A3,:A3,:Af3,:G3,:Fs3,:F3,:E3,:D3,:E3,:A3,:D3,:C3,:D3,:E3,:F3,:E3,:D3,:Cs3,:D3,:G2,:A2,:Bf2,:A2,:A3,:G3,:E3,:Cs3,:D3,:B2,:Cs3,:D3,:E3,:F3,:E3,:D3,:C3,:B2,:A3,:Af3,:E3,:A3,:A3,:Af3,:A3,:Fs3,:E3,:A2,:A3,:Bf3,:A3,:G3,:A3,:Bf3,:A3,:Bf3,:C4,:Bf3,:A3,:Bf3,:C4,:r,:C3,:D3,:E3,:Fs3,:E3,:Fs3,:G3,:A3,:G3,:F3,:E3,:D3,:Cs3,:D3,:G2,:A2,:Bf2,:A2,:G2,:E3,:Cs3,:A2,:D3,:C3,:B2,:C3,:Bf2,:A2,:D3,:G2,:r,:r,:r,:r,:r,:r,:r,:r,:A2,:D3,:D3,:F3,:E3,:D3,:C3,:D3,:E3,:D3,:C3,:B2,:Cs3,:D3,:A2,:D3,:C3,:B2,:C3,:B2,:A2,:B2,:A2,:D3,:G2,:D3,:Cs3,:C3,:B2,:Bf2,:A2,:D3,:G2,:G3,:F3,:A3,:F3,:Bf3,:B3,:B3]
  b4[0]=[2.0,2.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,2.0,3.0,1.0,1.0,1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,1.0,0.5,0.5,3.0,1.0,1.0,1.0,1.0,1.0,3.0,0.5,0.5,2.0,2.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,9.0,1.0,2.0,4.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,4.0,2.0,2.0,2.0,2.0,1.0,1.0,1.0,0.5,0.5,2.0,2.0,2.0,2.0,3.0,0.5,0.5,1.5,0.5,1.0,0.5,0.5,5.0,0.5,0.5,1.0,0.5,0.5,2.0,2.0,1.0,1.0,2.0,4.0,3.0,1.0,1.0,1.0,1.5,0.5,2.0,4.0,2.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,4.0,4.0,2.0,1.0,1.0,3.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,3.0,0.5,0.5,3.0,0.5,0.5,2.0,3.0,1.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,1.0,0.5,0.5,6.0,1.5,0.5]
  a4[1]=[:B3]
  b4[1]=[2.0]
  a4[2]=[:A3,:D3]
  b4[2]=[2.0,2.0]
  c4=[120,90,70]
amp4=[0.5,0.7,0.9]
in_thread do
  for i in st..a4.length-1
    in_thread do
      bosc 3,a4[i],b4[i],s[3],r[3],synth[3],c4[i],amp[3]*qt,:cont3
    end
    sync :cont3
  end
end
