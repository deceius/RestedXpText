local function UpdateXPText()
    if not MainMenuBarExpText then return end

    local curr = UnitXP("player")
    local max = UnitXPMax("player")
    local rested = GetXPExhaustion() or 0

    if max == 0 then return end

    local text = string.format("XP %d / %d", curr, max)

    if rested > 0 then
        local restedPercent = (rested / max) * 100
        text = text .. string.format(" (|cff0099ff%.1f%%|r)", restedPercent)
    end

    MainMenuBarExpText:SetText(text)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_XP_UPDATE")
f:RegisterEvent("UPDATE_EXHAUSTION")

f:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" and not XP_Hook_Initialized then

        local oldUpdate = MainMenuExpBar_Update
        MainMenuExpBar_Update = function()
            oldUpdate()
            UpdateXPText()
        end

        local oldEnter = MainMenuExpBar:GetScript("OnEnter")
        MainMenuExpBar:SetScript("OnEnter", function()
            if oldEnter then oldEnter() end
            UpdateXPText()
        end)

        local oldLeave = MainMenuExpBar:GetScript("OnLeave")
        MainMenuExpBar:SetScript("OnLeave", function()
            if oldLeave then oldLeave() end
            UpdateXPText()
        end)

        XP_Hook_Initialized = true
    end
    
    UpdateXPText()
    end
)