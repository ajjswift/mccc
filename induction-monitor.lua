-- Wrap peripherals
local battery = peripheral.wrap("back")
local monitor = peripheral.wrap("top")

-- Clear the monitor and set text scale
monitor.setTextScale(1)
monitor.clear()

-- Function to convert Joules to FE (1 Joule = 0.4 FE)
local function joulesToFE(joules)
  return joules * 0.4
end

-- Function to format large numbers with commas
local function formatNumber(num)
  local formatted = tostring(math.floor(num))
  local k
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
    if k == 0 then break end
  end
  return formatted
end

-- Function to draw a centered progress bar
local function drawProgressBar(x, y, width, progress, maxText)
  -- Set colors
  monitor.setBackgroundColor(colors.white)
  monitor.setTextColor(colors.black)
  
  -- Draw background
  for i = 0, width - 1 do
    monitor.setCursorPos(x + i, y)
    monitor.write(" ")
  end
  
  -- Draw progress bar
  local filledWidth = math.floor(width * progress)
  monitor.setBackgroundColor(colors.red)
  for i = 0, filledWidth - 1 do
    monitor.setCursorPos(x + i, y)
    monitor.write(" ")
  end
  
  -- Draw percentage text
  local percent = math.floor(progress * 100)
  local text = percent .. "% " .. maxText
  local textX = x + math.floor((width - #text) / 2)
  monitor.setCursorPos(textX, y)
  monitor.write(text)
  
  -- Reset colors
  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
end

-- Main loop
while true do
  -- Get monitor dimensions
  local width, height = monitor.getSize()
  
  -- Get battery information
  local energy = battery.getEnergy()
  local maxEnergy = battery.getMaxEnergy()
  local percentage = battery.getEnergyFilledPercentage()
  
  -- Convert to FE
  local energyFE = joulesToFE(energy)
  local maxEnergyFE = joulesToFE(maxEnergy)
  
  -- Format text
  local energyText = formatNumber(energyFE) .. " FE"
  local maxEnergyText = formatNumber(maxEnergyFE) .. " FE"
  local statusText = energyText .. " / " .. maxEnergyText
  
  -- Clear screen
  monitor.setBackgroundColor(colors.white)
  monitor.clear()
  
  -- Set text color
  monitor.setTextColor(colors.black)
  
  -- Display energy text centered
  local textX = math.floor((width - #statusText) / 2) + 1
  monitor.setCursorPos(textX, math.floor(height / 2) - 1)
  monitor.write(statusText)
  
  -- Draw progress bar
  local barWidth = math.min(width - 4, 40)
  local barX = math.floor((width - barWidth) / 2) + 1
  drawProgressBar(barX, math.floor(height / 2) + 1, barWidth, percentage, "Full")
  
  -- Update every second
  sleep(1)
end
