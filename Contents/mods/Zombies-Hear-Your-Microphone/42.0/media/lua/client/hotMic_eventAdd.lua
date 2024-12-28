local zombiesCanHearYou = require("hotMic")
if zombiesCanHearYou then Events.OnPlayerUpdate.Add(zombiesCanHearYou.onPlayerUpdate) end

if getActivatedMods():contains("ChuckleberryFinnAlertSystem") then
    local modCountSystem = require "chuckleberryFinnModding_modCountSystem"
    if modCountSystem then modCountSystem.pullAndAddModID() end
else print("WARNING: Highly recommended to install `ChuckleberryFinnAlertSystem` (Workshop ID: `3077900375`) for latest news and updates.") end