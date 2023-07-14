local hotMic = {}

local circle

---@param playerObj IsoMovingObject|IsoGameCharacter|IsoPlayer
function hotMic.onPlayerUpdate(playerObj)

    local volume =  math.min(10, math.max(0, getCore():getMicVolumeIndicator())) * 3
    local isErr = getCore():getMicVolumeError()
    local serverVOIPEnable = getCore():getServerVOIPEnable()
    local voiceEnabled = getCore():getOptionVoiceEnable()
    local voiceMode = getCore():getOptionVoiceMode()

    print("volume:"..volume.."  ("..getCore():getMicVolumeIndicator()..")")

    AddWorldSound(playerObj, volume, volume)

    if circle then getWorldMarkers():removeGridSquareMarker(circle) end
    circle = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", playerObj:getSquare(), 1, 1, 1, true, volume)

end


return hotMic