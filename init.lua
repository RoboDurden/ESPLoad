function LoadX()
    s = {ssid="", pwd="", host="", domain="", path="", err="",update=0}
    if (file.open("s.txt","r")) then
        local sF = file.read()
        --print("setting: "..sF)
        file.close()
        for k, v in string.gmatch(sF, "([%w.]+)=([%S ]+)") do    
            s[k] = v
            print(k .. ": " .. v)
        end
    end
end

print(collectgarbage("count").." kB used")
LoadX()

if ((s.err == "") and s.host and s.domain and s.path) then
    if (tonumber(s.update)>0) then
        tmr.alarm (0, tonumber(s.update)*60000, 1, function()
                print("checking for update")
            end)
    end
    dofile("client.lua")   
else
    dofile("server.lua")   
end 
