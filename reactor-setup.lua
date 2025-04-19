-- command: setup <relay | control> <reactorQuadrant> <reactorTriplet> <<reactorNumber>
local tArgs = { ... }

local type = tArgs[1]
local reactorQuadrant = tArgs[2]
local reactorTriplet = tArgs[3]
local reactorNumber = tArgs[4]

-- Download wpp
shell.run("wget https://raw.githubusercontent.com/jdf221/CC-WirelessPeripheral/main/wpp.lua wpp"); 

if type == "relay" then
    shell.run("wget https://raw.githubusercontent.com/ajjswift/mccc/refs/heads/main/reactor-relay.lua startup.lua")
end
if type == "control" then
    shell.run("wget https://raw.githubusercontent.com/ajjswift/mccc/refs/heads/main/reactor-control.lua startup.lua");
end


-- shell.execute("reboot");