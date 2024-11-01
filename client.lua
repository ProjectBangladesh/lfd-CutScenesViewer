local isCutscenePlaying = false
local currentCutsceneId = nil -- Track the current cutscene ID
local menuOpen = false -- Track the menu state

-- Function to open the menu and send cutscene options to NUI
local function openMenu()
    SendNUIMessage({
        action = 'openMenu',
        cutscenes = Config.Cutscenes
    })
    SetNuiFocus(true, true) -- Set NUI focus
    menuOpen = true -- Set menu state to open
end

-- Function to close the menu
local function closeMenu()

    SendNUIMessage({ action = 'closeMenu' })
    SetNuiFocus(false, false) -- Remove NUI focus
    menuOpen = false -- Set menu state to closed

end

local function stopScene()
    
    StopCutsceneImmediately()
    SendNUIMessage({ action = 'stopScene' })
    SetNuiFocus(false, false)
    menuOpen = false
end

-- Listen for the F6 key to toggle the cutscene menu
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(1, 167) then -- F6 key
            openMenu()
        end
    end
end)

-- Handle playing cutscenes from NUI
RegisterNUICallback('playCutscene', function(data, cb)
    local cutsceneId = data.cutsceneId
    if isCutscenePlaying then
        StopCutsceneImmediately()
    end

    RequestCutscene(cutsceneId, 8)
    local timeout = GetGameTimer() + 10000
    while not HasCutsceneLoaded() and GetGameTimer() < timeout do
        Wait(0)
    end

    if HasCutsceneLoaded() then
        StartCutscene(cutsceneId)
        isCutscenePlaying = true
        currentCutsceneId = cutsceneId -- Track the currently playing cutscene

        -- Loop to check if the cutscene is still active
        while isCutscenePlaying do
            Wait(0)
            if not IsCutsceneActive() then
                isCutscenePlaying = false
                currentCutsceneId = nil -- Reset current cutscene ID
                print("Cutscene ended naturally.")
            end
        end
    else
        print("Cutscene failed to load.")
    end

    cb('ok')
end)

-- Handle closing the menu from NUI
RegisterNUICallback('closeMenu', function(data, cb)
    closeMenu()
    cb('ok')
end)

RegisterNUICallback('stopScene', function(data, cb)
    stopScene()
    cb('ok')
end)

-- New NUI Callback to handle ESC keypress
RegisterNUICallback('onEscPressed', function(data, cb)
    if menuOpen == false then
        stopScene()
    end
    cb('ok')
end)
