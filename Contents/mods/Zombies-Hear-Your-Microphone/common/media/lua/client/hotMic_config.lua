--- Thank you to dhert
------ local options = PZAPI.ModOptions:getOptions("Conditional-Speech")
------ local option = options:getOption(""cndSpeech_Phrase_"..moodID")

local config = {}

function config.apply()
    local options = PZAPI.ModOptions:create("ZombiesHearYourMicrophone", getText("UI_Config_ZombiesHearYourMicrophone"))
    options:addTickBox("ZombiesHearYourMicrophone_visualRadius", getText("UI_Config_ZombiesHearYourMicrophone_visualRadius"), false, getText("UI_Config_ZombiesHearYourMicrophone_visualRadius_ToolTip"))
end

return config