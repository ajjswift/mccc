local reactorNumber = 1
local reactorQuadrant = "lc"
local reactorTriplet = "b"


local wpp = require("wpp");
wpp.wireless.listen(string.format("reactor-management-%s-%s-%d", reactorQuadrant, reactorTriplet, reactorNumber))