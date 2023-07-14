local hotMic = {}

local circle

---@param playerObj IsoMovingObject|IsoGameCharacter|IsoPlayer
function hotMic.onPlayerUpdate(playerObj)

    if playerObj:isDead() or playerObj:isAsleep() then return end

    getCore():setTestingMicrophone(true)

    local volume =  math.min(10, math.max(0, getCore():getMicVolumeIndicator())) * 1.5
    local isErr = getCore():getMicVolumeError()
    if isErr then return end

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