local zombiesCanHearYou = require("hotMic")
if zombiesCanHearYou then Events.OnPlayerUpdate.Add(zombiesCanHearYou.onPlayerUpdate) end

local modCountSystem = require "chuckleberryFinnModding_modCountSystem"
if modCountSystem then modCountSystem.pullAndAddModID()
else print("ERR: MISSING MOD: `ChuckleberryFinnAlertSystem` (Workshop ID: `3077900375`)") end