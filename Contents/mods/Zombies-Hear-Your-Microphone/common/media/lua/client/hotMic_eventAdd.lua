local zombiesCanHearYou = require("hotMic")
if zombiesCanHearYou then Events.OnPlayerUpdate.Add(zombiesCanHearYou.onPlayerUpdate) end

local config = require "hotMic_config"
Events.OnGameBoot.Add(config.apply)