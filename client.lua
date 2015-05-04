
function SaveX(sErr)
    if (sErr) then
        print (sErr)
        s.err = sErr
    end
    file.remove("s.txt")
    file.open("s.txt","w+")
    for k, v in pairs(s) do
        file.writeline(k .. "=" .. v)
    end                
    file.close()
    collectgarbage()
end

function NewLua(sck,c)
    local nStart, nEnd = string.find(c, "\n\n")
    if (nEnde == nil) then
        nStart, nEnd = string.find(c, "\r\n\r\n")
    end
    c = string.sub(c,nEnd+1)
    print("lua length: "..string.len(c))

    if (string.sub(c,0,5) ~= "--lua") then
        SaveX(s.domain.."/"..s.path .. " does not begin with --lua")
        node.restart()
        return
    end
    file.remove("do.lua")
    file.open("do.lua","w+")
    file.writeline(c)
    file.close()
    node.compile("do.lua")
    --dofile("do.lua")
    dofile("do.lc")    
    collectgarbage()
end

print("fetch lua..")
LoadX()

wifi.setmode (wifi.STATION)
wifi.sta.config(s.ssid, s.pwd)
wifi.sta.autoconnect (1)

iFail = 20
tmr.alarm (1, 1000, 1, function ( )
  iFail = iFail -1
  print(iFail)
  if (iFail == 0) then
    SaveX("could not access "..s.ssid)
    node.restart()
  end      
  
  if wifi.sta.getip ( ) == nil then
    print(s.ssid..": "..iFail)
  else
    print ("ip: " .. wifi.sta.getip ( ))
    tmr.stop (1)
    sk=net.createConnection(net.TCP, 0)
    sk:on("receive", NewLua)
    sk:connect(80,s.host) 
    sGet = "GET /".. s.path .. " HTTP/1.1\r\nHost: " .. s.domain .. "\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n"
    print(sGet)
    sk:send(sGet)
    
  end
  collectgarbage()
 
end)

 print(collectgarbage("count").." kB used")
