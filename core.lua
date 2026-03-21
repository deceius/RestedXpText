if restedXpBar_Mode == nil then restedXpBar_Mode = "PERCENT" end


local function UpdateXPText()
    if not MainMenuBarExpText then return end

    local curr = UnitXP("player")
    local max = UnitXPMax("player")
    local expPercentage = (curr / max) * 100
    local rested = GetXPExhaustion() or 0

    if max == 0 then return end
    local text = string.format("XP %d / %d - %.1f%% ", curr, max, expPercentage)
    if rested > 0 then
        local restedPercent = string.format("|cff0099ff%.1f%%|r", (rested / max) * 100) 
        local restedRemaining = string.format("|cff0099ff%d remaining|r", rested)
        if restedXpBar_Mode == "PERCENT" then
            text = text .. string.format('(%s)', restedPercent)
        elseif restedXpBar_Mode == "REMAINING" then
            text = text .. string.format('(%s)', restedRemaining)
        else            
            text = text .. string.format('(%s | %s)', restedPercent, restedRemaining)
        end
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

SLASH_RESTEDXP1 = "/restedxp"

SlashCmdList["RESTEDXP"] = function(msg)
    local cmd = string.lower(msg or "")

    if cmd == "percentage" or cmd == "pct" then
        restedXpBar_Mode = "PERCENT"
    elseif cmd == "remaining" or cmd == "rem" then
        restedXpBar_Mode = "REMAINING"
    elseif cmd == "both" then
        restedXpBar_Mode = "BOTH"
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff0099ff[restedXpBar]|r Usage: /restedxp [percentage | remaining | both]")
        return
    end

     DEFAULT_CHAT_FRAME:AddMessage("|cff0099ff[restedXpBar]|r: Mode set to " .. restedXpBar_Mode)
    
    if UpdateXPText then
        UpdateXPText()
    end
end