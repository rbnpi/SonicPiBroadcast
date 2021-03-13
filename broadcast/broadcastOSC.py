#!/usr/bin/env python3
#broadcast received OSC message
#written by Robin Newman, October 2018
#designed for use with Sonic Pi 3
#requires python-osc
#install with sudo pip3 install python-osc
import argparse
from pythonosc import osc_message_builder
from pythonosc import udp_client
from pythonosc import dispatcher
from pythonosc import osc_server


#dispatcher handler which sends broadcast message
#handles up to 10 arguments to add to the message
def broadcast(unused_addr,args,p1="",p2="",p3="",p4="",p5="",p6="",p7="",p8="",p9="",p10=""):
    msg=[]
    if p1 != "": 
       msg.append(p1) 
    if p2 != "":
       msg.append(p2) 
    if p3 != "":
        msg.append(p3)
    if p4 != "":
        msg.append(p4)
    if p5 != "":
        msg.append(p5)
    if p6 != "":
        msg.append(p6)
    if p7 != "":
        msg.append(p7)
    if p8 != "":
        msg.append(p8)
    if p9 != "":
        msg.append(p9)
    if p10 != "":
        msg.append(p10)
        
   #send the broadcast message
    client.send_message("/broadcast",msg)
    #print details on terminal screen
    print("message '/broadcast' {} sent".format(msg))

if __name__ == "__main__":
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--port",default=8000,
          help="The port for the local OSC server")

        parser.add_argument("--ip",default="127.0.0.1",
          help="the ip address of the local OSC server")

        parser.add_argument("--bcip", default="192.168.1.255",
          help="The broadcast address")

        parser.add_argument("--bcport", type=int, default=4560,
         help="The Sonic Pi listening Port")

        args = parser.parse_args()
        #set up client for brodcast
        client = udp_client.SimpleUDPClient(args.bcip, args.bcport,True) #True allows for broadcast
        #set up dispatcher to handle incoming OSC messages
        dispatcher = dispatcher.Dispatcher()
        #dispatcher for "/triggerBroadcast" incoming OSC message
        #can handle up to 10 separate input data
        dispatcher.map("/triggerBroadcast", broadcast,"p1","p2","p3","p4","p5","p6","p7","p8","p9","p10")

        #set up server
        server = osc_server.ThreadingOSCUDPServer( (args.ip, args.port), dispatcher)
        #print configuration data on terminal screen
        print("Serving on {} port {}".format(server.server_address,args.port))
        print("Broadcast to {} on port {}".format(args.bcip,args.bcport))
        #start serving    
        server.serve_forever()

    #allow clean ctrl-C exit
    except KeyboardInterrupt:
        print("\nProgram exit")
