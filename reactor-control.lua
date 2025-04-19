local reactorNumber = 1
local reactorQuadrant = "lc"
local reactorTriplet = "b"

local wpp = require("wpp");
wpp.wireless.connect(string.format("reactor-management-%s-%s-%d", reactorQuadrant, reactorTriplet, reactorNumber))

local reactor = wpp.peripheral.find("fusionReactorLogicAdapter");

local monitor = peripheral.wrap("right");

local w,h = monitor.getSize()


while true do
    local reactorName = string.format("Reactor rc-%s-%s-%d", reactorQuadrant, reactorTriplet, reactorNumber);
    local productionRate = reactor.getProductionRate() * 0.4
    local injectionRate = reactor.getInjectionRate()

    monitor.clear()
    monitor.setCursorPos(3,2)
    monitor.write(reactorName)
    monitor.setCursorPos(3, 3)
    monitor.write(
        string.format("Output: %d FE/t", productionRate)
    )
    monitor.setCursorPos(3,4)
    monitor.write(
        string.format("Injection rate: %d mB/t", injectionRate)
    )
    os.sleep(0.5)
end