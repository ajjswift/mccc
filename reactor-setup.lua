-- command: setup <relay | control> <reactorQuadrant> <reactorTriplet> <reactorNumber>
local tArgs = { ... }

local type = tArgs[1]
local reactorQuadrant = tArgs[2]
local reactorTriplet = tArgs[3]
local reactorNumber = tArgs[4]

-- Download wpp
shell.run("wget https://raw.githubusercontent.com/jdf221/CC-WirelessPeripheral/main/wpp.lua wpp")

if type == "relay" then
    shell.run("wget https://raw.githubusercontent.com/ajjswift/mccc/refs/heads/main/reactor-relay.lua startup.lua")
elseif type == "control" then
    -- Download the reactor-control.lua file
    shell.run("wget https://raw.githubusercontent.com/ajjswift/mccc/refs/heads/main/reactor-control.lua temp_reactor_control.lua")

    -- Read the content of the downloaded file
    local file = io.open("temp_reactor_control.lua", "r")
    if not file then
        print("Error: Could not open temp_reactor_control.lua for reading")
        return
    end
    local content = file:read("a")
    file:close()

    -- Modify the content to set the variables
    content = string.gsub(content, "local reactorNumber = .*", "local reactorNumber = " .. reactorNumber)
    content = string.gsub(content, "local reactorQuadrant = \".*\"", "local reactorQuadrant = \"" .. reactorQuadrant .. "\"")
    content = string.gsub(content, "local reactorTriplet = \".*\"", "local reactorTriplet = \"" .. reactorTriplet .. "\"")

    -- Write the modified content to startup.lua
    file = io.open("startup.lua", "w")
    if not file then
        print("Error: Could not open startup.lua for writing")
        return
    end
    file:write(content)
    file:close()

    -- Delete the temporary file
    fs.delete("temp_reactor_control.lua")
end

-- shell.execute("reboot");
