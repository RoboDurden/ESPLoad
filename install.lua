print("install ESPLoad")

function WriteFile()
    print("add file: " .. sFile .. ": " .. string.len(sData))
    file.close()

    file.remove(sFile)
    file.open(sFile,"w+")
    file.write(sData)
    file.close()

    file.open("install.lua","r")
    file.seek("set",iSeek)
    
    sData = ""
    collectgarbage()
end


file.open("install.lua","r")

sData = ""
sFile = nil
iSeek=0

s=file.readline()
while s ~= nil do
    iSeek = iSeek + string.len(s)
    sNewFile = string.match(s, "file:([%w.]+)")
    if sNewFile then
        --print(sNewFile)
        if sFile then
            WriteFile(sFile,sData)
        end
        sFile = sNewFile
    else
        if sFile then
            sData = sData .. s
        end
    end
    s=file.readline()
end
WriteFile(sFile,sData)

file.close()
file.remove("install.lua")
print("install finished :-)")

--[[
file:init.lua
function LoadX()
    s = {ssid="", pwd="", host="", domain="", path="", err="no data",update=0}
    if (file.open("s.txt","r")) then
        local sF = file.read()
        --print("setting: "..sF)
        file.close()
        for k, v in string.gmatch(sF, "([%w.]+)=([%S ]*)") do    
            s[k] = v
            print(k .. ": " .. v)
        end
    end
end

print(collectgarbage("count").." kB used")
LoadX()

if s.err == "" then
    if (tonumber(s.update)>0) then
        tmr.alarm (0, tonumber(s.update)*60000, 1, function()
                print("checking for update")
            end)
    end
    dofile("client.lua")   
else
    dofile("server.lua")   
end 
file:server.lua

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


print(collectgarbage("count").." kB: server.lua")
LoadX()


wifi.setmode(wifi.SOFTAP)
wifi.ap.config({ssid="node_"..node.chipid(), pwd=""})
srv=net.createServer(net.TCP)
print(wifi.sta.getip())
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
       local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
       if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=([^&]*)&*") do
                s[k],n = string.gsub(v,"%%2F","/")
                print(k .. " = " .. s[k])
            end
            SaveX()
            if s.err == "" then
                node.restart()
            end
        end

        file.open("y.htm","r")
        local sH = file.read()
        for k, v in pairs(s) do
            sH,n = string.gsub(sH,"_"..k,v)
        end                
        print(sH)
        file.close()
        client:send(sH)
        client:close()

        collectgarbage()
    end)
end)
file:y.htm
<html><body><form>
error: <input name=err value='_err'/><br/>
<h2>access point:</h2>
SSID: <input name=ssid value='_ssid'/><br/>
pwd: <input name=pwd value='_pwd'/><br/>
<h2>fetch lua:</h2>
ip: <input name=host value='_host'/><br/>
domain: <input name=domain value='_domain'/><br/>
path: <input name=path value='_path'/><br/>
reboot: <input type=number size=4 name=update value='_update'/> minutes<br/>
<input type=submit value='submit'/>
</form></body></html>
 
file:client.lua
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
    print(s.ssid)
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

 print(collectgarbage("count").." kB: client.lua")
--]]
