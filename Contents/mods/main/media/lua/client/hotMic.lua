local hotMic = {}
local circle
local DISCOUNT_VALUES = { 1.0, 0.97, 0.94, 0.91, 0.88, 0.85, 0.82, 0.79, 0.76, 0.73, 0.7 }

---@param playerObj IsoMovingObject|IsoGameCharacter|IsoPlayer
function hotMic.onPlayerUpdate(playerObj)
    if playerObj:isDead() or playerObj:isAsleep() then return end
    getCore():setTestingMicrophone(true)


	local traitsMultiplier = 0;
    local influence = SandboxVars.ZombiesHearYourMicrophone.traitsinfluence
	local minimalr = SandboxVars.ZombiesHearYourMicrophone.minimalradius
	local sneakr = SandboxVars.ZombiesHearYourMicrophone.sneakreduce

    if influence == 1 then
        traitsMultiplier = 0
    else
        -- bad traits 2 or 4 (both)
        traitsMultiplier = traitsMultiplier + ((influence == 2 or influence == 4) and getPlayer():HasTrait("Conspicuous") and 1 or 0);
        traitsMultiplier = traitsMultiplier + ((influence == 2 or influence == 4) and getPlayer():HasTrait("Clumsy") and 0.2 or 0);

        -- good traits 3 or 4 (both)
        traitsMultiplier = traitsMultiplier - ((influence == 3 or influence == 4) and getPlayer():HasTrait("Graceful") and 0.6 or 0);
        traitsMultiplier = traitsMultiplier - ((influence == 3 or influence == 4) and getPlayer():HasTrait("Inconspicuous") and 0.5 or 0);

        if traitsMultiplier < -0.9 then
            traitsMultiplier = -0.9;
        end
    end

    local factor = (1 + traitsMultiplier) * SandboxVars.ZombiesHearYourMicrophone.multiplier;
    if influence == 3 or influence == 4 then
        factor = factor * DISCOUNT_VALUES[1 + getPlayer():getPerkLevel(Perks.Lightfoot)] * DISCOUNT_VALUES[1 + getPlayer():getPerkLevel(Perks.Sneak)];
    end
	
    if getPlayer():isSneaking() then
        factor = factor * sneakr;
    end

	if factor < minimalr then
		factor = minimalr;
	end

    local volume =  math.min(10, math.max(0, getCore():getMicVolumeIndicator())) * factor
    local isErr = getCore():getMicVolumeError()
    if isErr then return end

    local isPTT = getCore():getOptionVoiceMode()==1
    local isPTTKeyDown = GameKeyboard.isKeyDown(getCore():getKey("Enable voice transmit"))
    if isPTT and not isPTTKeyDown and SandboxVars.ZombiesHearYourMicrophone.respectEnableVOIP then return end

    local serverVOIPEnable = getCore():getServerVOIPEnable()
    if not serverVOIPEnable and SandboxVars.ZombiesHearYourMicrophone.respectEnableVOIP then return end

    local voiceEnabled = getCore():getOptionVoiceEnable()
    if not voiceEnabled and SandboxVars.ZombiesHearYourMicrophone.respectEnableVOIP then return end

    AddWorldSound(playerObj, volume, volume)

    if getDebug() then
        if circle then getWorldMarkers():removeGridSquareMarker(circle) end
        circle = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", playerObj:getSquare(), 1, 1, 1, true, volume)
    end

end


return hotMic
