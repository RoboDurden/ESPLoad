
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


print(collectgarbage("count").." kB used")
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
            if ((s.err == "") and s.host and s.domain and s.path) then
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
