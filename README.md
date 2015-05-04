# ESPLoader
6 kB init.lua for NodeMCU to install lua files via wifi 

client.lua      : 1612 bytes
init.lua        : 701 bytes
s.txt           : 53 bytes
server.lua      : 1277 bytes
y.htm           : 170 bytes
Total file(s)   : 5
Total size      : 3813 bytes

I don't want to hook up the ESP via RX TX to a usb-serial. Only once to flash such a firmware:

1. On startup it checks "client settings" and if filled it flashes the lua code from the internet/intranet and executes it. 
2. With no or faulty "client settings" (access point and url from where to download lua code) it goes into server mode offering a very simply form to enter the "client settings" or directly upload lua code.

The ESP will "always" be used either in client mode or server mode anyway. 

the code checks a setting file "s.txt" and if fully populated it downloads for example 
host=81.169.145.148
domain=robosoft.de
path=do.lua

if the download does not begin with "--lua", an error message is saved to "s.txt" and after restart init.lua starts it's own access point to update "s.txt"

s.txt is created when the form is posted. But always nice to add a "x" to err and let ESPlorer upload it to go back to access point mode

init.lua  takes the  gloabl timer id 0 to look for a new download every s.update minutes while the downloaded lua file is running. (no node.restart() yet added)

By now,i don't really want to replace the ESPlorer with a webIDE. It is great for developing / debugging. I have tried http://www.NodeLua.org and it is a great simple and plain webIDE where you can see the print("logging / debuggin") in your browser while the ESP is connected to the internet. Sadly the creator seems to have vanished from earth ?

When i will have a dozen ESPs all over the house and nearby friends, i will need a wifi distribution system to update the code. That is how i started this thread. No server web ide. Just ftp the latest update to the internet and all my ESPs will fetch them.
And if some ESPs run as access points, i would like to upload updates via the the simple "x"-settings form.

My electric bike is still controlled by a PIC, yet i moved to Arduino already some years ago, now moving from Arduino to ESP.
(and backing https://www.kickstarter.com/projects/70 ... for-things as well as https://www.kickstarter.com/projects/on ... nternet-of )

I think NodeMCU needs a very simple way to update/distribute code without any cables or IDE.

Roland
alias Robo Durden
and the first Rule: you always speak yes !
