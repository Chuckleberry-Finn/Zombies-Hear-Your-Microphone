local hotMic = {}
local circle
local DISCOUNT_VALUES = { 1.0, 0.97, 0.94, 0.91, 0.88, 0.85, 0.82, 0.79, 0.76, 0.73, 0.7 }

---@param playerObj IsoMovingObject|IsoGameCharacter|IsoPlayer
function hotMic.onPlayerUpdate(playerObj)
    if playerObj:isDead() or playerObj:isAsleep() then return end
    getCore():setTestingMicrophone(true)


	local traitsMultiplier = 0
    local influence = SandboxVars.ZombiesHearYourMicrophone.traitsinfluence
	local minimalr = SandboxVars.ZombiesHearYourMicrophone.minimalradius
	local sneakr = SandboxVars.ZombiesHearYourMicrophone.sneakreduce

    if influence == 1 then
        traitsMultiplier = 0
    else
        -- bad traits 2 or 4 (both)
        traitsMultiplier = traitsMultiplier + ((influence == 2 or influence == 4) and playerObj:HasTrait("Conspicuous") and 1 or 0)
        traitsMultiplier = traitsMultiplier + ((influence == 2 or influence == 4) and playerObj:HasTrait("Clumsy") and 0.2 or 0)

        -- good traits 3 or 4 (both)
        traitsMultiplier = traitsMultiplier - ((influence == 3 or influence == 4) and playerObj:HasTrait("Graceful") and 0.6 or 0)
        traitsMultiplier = traitsMultiplier - ((influence == 3 or influence == 4) and playerObj:HasTrait("Inconspicuous") and 0.5 or 0)

        if traitsMultiplier < -0.9 then
            traitsMultiplier = -0.9
        end
    end

    local factor = (1 + traitsMultiplier) * SandboxVars.ZombiesHearYourMicrophone.multiplier
    if influence == 3 or influence == 4 then
        factor = factor * DISCOUNT_VALUES[1 + playerObj:getPerkLevel(Perks.Lightfoot)] * DISCOUNT_VALUES[1 + playerObj:getPerkLevel(Perks.Sneak)]
    end
	
    if playerObj:isSneaking() then factor = factor * sneakr end

	if factor < minimalr then factor = minimalr end

    local core = getCore()
    local volume =  math.min(10, math.max(0, core:getMicVolumeIndicator())) * factor
    local isErr = core:getMicVolumeError()
    if isErr then return end

    local isPTT = core:getOptionVoiceMode()==1
    local isPTTKeyDown = GameKeyboard.isKeyDown(core:getKey("Enable voice transmit"))
    if isPTT and not isPTTKeyDown and SandboxVars.ZombiesHearYourMicrophone.respectEnableVOIP then return end

    local serverVOIPEnable = core:getServerVOIPEnable()
    if not serverVOIPEnable and SandboxVars.ZombiesHearYourMicrophone.respectEnableVOIP then return end

    local voiceEnabled = core:getOptionVoiceEnable()
    if not voiceEnabled and SandboxVars.ZombiesHearYourMicrophone.respectEnableVOIP then return end

    AddWorldSound(playerObj, volume, volume)

    if getDebug() then
        local worldMarkers = getWorldMarkers()
        if circle then worldMarkers:removeGridSquareMarker(circle) end
        circle = worldMarkers:addGridSquareMarker("circle_center", "circle_only_highlight", playerObj:getSquare(), 1, 1, 1, true, volume)
    end

end


return hotMic
