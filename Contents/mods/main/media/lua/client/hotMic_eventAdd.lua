local zombiesCanHearYou = require("hotMic")
if zombiesCanHearYou then Events.OnPlayerUpdate.Add(zombiesCanHearYou.onPlayerUpdate) end