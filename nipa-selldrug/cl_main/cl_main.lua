TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function text(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z+0.30)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*1
    local fov = (1/GetGameplayCamFov())*100
    local scale = 1.0
   
    if onScreen then
        SetTextScale(0.0*scale, 0.25*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(0, 0, 0, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    	DrawRect(_x,_y+0.0125, 0.013+ factor, 0.03, 0, 0, 0, 68)
    end
end

local function accepted()
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(testped)
    ESX.ShowAdvancedNotification('', Config.Translation["convo"], Config.Translation["interested"], mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
    TriggerEvent('nd-selldrugs:config:sellmenu')
end


local function callcops()
	RequestAnimDict("cellphone@")
    while not HasAnimDictLoaded("cellphone@") do
        Wait(10)
    end
    TaskPlayAnim(testped, "cellphone@", "cellphone_call_listen_base", 2.0, 2.0, -1, 51, 0, false, false, false)
	prop = CreateObject(GetHashKey('prop_npc_phone_02'), testpedcoords.x, testpedcoords.y, testpedcoords.z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, testped, GetPedBoneIndex(testped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(prop)
    Wait(Config.SecondsAfterPoliceGetAlert)
    if not IsEntityDead(testped) then 
        DeleteObject(prop)
	    ClearPedTasks(testped)
        SetEntityAsNoLongerNeeded(testped)
        TriggerServerEvent('nd-selldrugs:server:palert')
    end
end

local robbing = false

local function robplayer()
    TriggerEvent('nd-selldrugs:client:distancecheck')
    ClearPedTasks(testped)
    GiveWeaponToPed(testped, GetHashKey("WEAPON_PISTOL"), 250, false, true)
    TaskAimGunAtCoord(testped, GetEntityCoords(PlayerPedId()), 7500, 0, 0)
    TaskHandsUp(PlayerPedId(), 7500, testped, 0, 0)
    robbing = true
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(testped)
    ESX.ShowAdvancedNotification('', Config.Translation["convo"], Config.Translation["robbing-text"], mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
    Wait(7500)
    TriggerServerEvent('nd-selldrug:server:tookmoney')
    Wait(1000)
    SetPedAsNoLongerNeeded(testped)
    TaskSmartFleePed(testped, PlayerPedId(), 40.0, 40000, 0, 0)
    robbing = false
end

local function cancel()
    local luck = math.random(1, 100)
    if luck <= Config.AlertCopsLuck then -- Check if luck is less than or equal to Config.AlertCopsLuck
        Wait(2000)
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(testped)
        ESX.ShowAdvancedNotification('', Config.Translation["convo"], Config.Translation["not-interested"], mugshotStr, 1)
        UnregisterPedheadshot(mugshot)
        Wait(1000)
        callcops()
    else
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(testped)
        ESX.ShowAdvancedNotification('', Config.Translation["convo"], Config.Translation["not-interested"], mugshotStr, 1)
        UnregisterPedheadshot(mugshot)
    end
end

local function randomfunc()
    SetEntityAsMissionEntity(testped)
    TaskChatToPed(testped, PlayerPedId())
    Wait(Config.OrderTime)
    local acpt = math.random(0, 100)
    if acpt <= Config.CancelLuck then
        cancel()
    elseif acpt <= Config.RobLuck then
        robplayer()
    else
        accepted()
    end
end

local interactednpc = {}

CreateThread(function()
    while true do
        local wait = 500
        testped = ESX.Game.GetClosestPed(GetEntityCoords(PlayerPedId()))
        testpedcoords = GetEntityCoords(testped)
        if #(GetEntityCoords(PlayerPedId()) - testpedcoords) < Config.TextDistance and IsPedDeadOrDying(testped) == false and IsPedAPlayer(testped) == false and GetPedType(testped) ~= 28 and IsPedInAnyVehicle(testped, true) == false and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsEntityDead(PlayerPedId()) then
            wait = 0
            local npcID = NetworkGetNetworkIdFromEntity(testped)
            if interactednpc[npcID] == nil then
                text(testpedcoords.x, testpedcoords.y, testpedcoords.z, tostring(Config.Translation["presstosell"]))
                if IsControlJustPressed(0, Config.SellDrugsKey) then
                    randomfunc()
                    TriggerServerEvent('nd-selldrugs:server:SVcheck', npcID)
                    interactednpc[npcID] = true
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('nd-selldrugs:client:interactwithnpc', function(npcID)
    interactednpc[npcID] = true
end)

RegisterNetEvent('nd-selldrugs:client:selldrugs', function(data)
    local maxLength = 8
    AddTextEntry("Amount to sell", Config.Translation["menu-how-much-want-to-sell"])
    DisplayOnscreenKeyboard(1, "Amount to sell", "", "", "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
       Wait(0)
    end
    local amount = GetOnscreenKeyboardResult()
    local drug = data.thisdrug
    TriggerServerEvent('nd-selldrug:server:selldrug', drug, amount)
    SetEntityAsNoLongerNeeded(testped)
end)

RegisterNetEvent('nd-selldrugs:client:donthaveMS',function()
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(testped)
    ESX.ShowAdvancedNotification('', Config.Translation["convo"], Config.Translation["dont-have-drugs-to-sell"], mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end)

RegisterNetEvent('nd-selldrugs:client:donthavemoney',function()
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(testped)
    ESX.ShowAdvancedNotification('', Config.Translation["convo"], Config.Translation["rob-dont-have-money"], mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end)

RegisterNetEvent('nd-selldrugs:client:distancecheck', function()
    while robbing do 
        Wait(0)
        if IsPedRunning(PlayerPedId()) or IsPedInAnyVehicle(PlayerPedId(), false) then
            TaskCombatPed(testped, PlayerPedId(), 0, 16)
        end
    end
end)

RegisterNetEvent('nd-selldrugs:client:animSV', function()
	RequestAnimDict("mp_common")            
	while not HasAnimDictLoaded("mp_common") do
		Wait(0)
	end
   TaskPlayAnim(testped, "mp_common", "givetake2_a", 8.0, 4.0, -1, 48, 0, 0, 0, 0)
   TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 8.0, 4.0, -1, 48, 0, 0, 0, 0)
end)

RegisterNetEvent('nd-selldrugs:client:palert', function()
    if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == Config.PoliceJobName then
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
	ESX.ShowAdvancedNotification(Config.Translation["alert-text3"], Config.Translation["alert-text2"], Config.Translation["alert-to-police"], mugshotStr, 1)
	    UnregisterPedheadshot(mugshot)
        local copblip = AddBlipForCoord(testpedcoords)
        SetBlipSprite(copblip, Config.AlertBlip["blip-sprite"])
        SetBlipDisplay(copblip, Config.AlertBlip["blip-display"])
        SetBlipScale(copblip, Config.AlertBlip["blip-scale"])
        SetBlipColour(copblip, Config.AlertBlip["blip-colour"])
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Translation["alert-blip"])
        EndTextCommandSetBlipName(copblip)
        PulseBlip(copblip)
        Wait(20000)
        RemoveBlip(copblip)
    end
end)