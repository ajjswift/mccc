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

    -- Open the downloaded file for reading
    local inFile = fs.open("temp_reactor_control.lua", "r")
    if not inFile then
        print("Error: Could not open temp_reactor_control.lua for reading")
        return
    end

    -- Open the startup file for writing
    local outFile = fs.open("startup.lua", "w")
    if not outFile then
        print("Error: Could not open startup.lua for writing")
        inFile.close()
        return
    end

    -- Process each line
    while true do
        local line = inFile.readLine()
        if not line then break end

        if line:match("^local%s+reactorNumber%s*=") then
            outFile.writeLine("local reactorNumber = " .. reactorNumber)
        elseif line:match("^local%s+reactorQuadrant%s*=") then
            outFile.writeLine("local reactorQuadrant = \"" .. reactorQuadrant .. "\"")
        elseif line:match("^local%s+reactorTriplet%s*=") then
            outFile.writeLine("local reactorTriplet = \"" .. reactorTriplet .. "\"")
        else
            outFile.writeLine(line)
        end
    end

    inFile.close()
    outFile.close()

    -- Delete the temporary file
    fs.delete("temp_reactor_control.lua")
end

-- shell.execute("reboot");
