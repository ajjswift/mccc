-- command: setup <relay | control> <reactorQuadrant> <reactorTriplet> <reactorNumber>
local tArgs = { ... }

local type = tArgs[1]
local reactorQuadrant = tArgs[2]
local reactorTriplet = tArgs[3]
local reactorNumber = tArgs[4]

-- Download wpp
shell.run("wget https://raw.githubusercontent.com/jdf221/CC-WirelessPeripheral/main/wpp.lua wpp")

local function patchFile(inputFile, outputFile)
    local inFile = fs.open(inputFile, "r")
    if not inFile then
        print("Error: Could not open " .. inputFile .. " for reading")
        return false
    end

    local outFile = fs.open(outputFile, "w")
    if not outFile then
        print("Error: Could not open " .. outputFile .. " for writing")
        inFile.close()
        return false
    end

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
    return true
end

if type == "relay" then
    shell.run("wget https://raw.githubusercontent.com/ajjswift/mccc/refs/heads/main/reactor-relay.lua temp_reactor_relay.lua")
    if patchFile("temp_reactor_relay.lua", "startup.lua") then
        fs.delete("temp_reactor_relay.lua")
    end
elseif type == "control" then
    shell.run("wget https://raw.githubusercontent.com/ajjswift/mccc/refs/heads/main/reactor-control.lua temp_reactor_control.lua")
    if patchFile("temp_reactor_control.lua", "startup.lua") then
        fs.delete("temp_reactor_control.lua")
    end
end

-- shell.execute("reboot");
