local hotMic = {}

local circle

---@param playerObj IsoMovingObject|IsoGameCharacter|IsoPlayer
function hotMic.onPlayerUpdate(playerObj)

    if playerObj:isDead() or playerObj:isAsleep() then return end
    getCore():setTestingMicrophone(true)

    local factor = 1.5
    if playerObj:isSneaking() then factor = 0.66 end

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