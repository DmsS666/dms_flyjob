 
Citizen.CreateThread(function() 

    startJob()
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
local StartNow = false
local StartNow2 = false
local StartNow3 = false
--PED
Citizen.CreateThread(function()
	RequestModel(GetHashKey(Config.NPC.Ped))
	while not HasModelLoaded(GetHashKey(Config.NPC.Ped)) do
		Citizen.Wait(100)
	end
	WYPED = CreatePed(7,GetHashKey(Config.NPC.Ped),Config.NPC.x,Config.NPC.y,Config.NPC.z-1,Config.NPC.h ,0,true,true)
	FreezeEntityPosition(WYPED,true)
	SetBlockingOfNonTemporaryEvents(WYPED, true)
	TaskStartScenarioInPlace(WYPED, "WORLD_HUMAN_AA_SMOKE", 0, false)
	SetEntityInvincible(WYPED,true)
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.NPC.x, Config.NPC.y, Config.NPC.z)
	SetBlipSprite(blip, Config.NPC.BlipSprite)
	SetBlipDisplay(blip, Config.NPC.BlipDisplay)
	SetBlipScale  (blip, Config.NPC.BlipScale)
	SetBlipColour (blip, Config.NPC.BlipColour)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.NPC.BlipNameOnMap)
	EndTextCommandSetBlipName(blip)
end)

function startJob()
	local s = true
    while s do
        local wait = 1000
        local pedcoords = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(pedcoords, Config.NPC.x, Config.NPC.y, Config.NPC.z, true)

        if dist < 3 then
            wait = 5
            ESX.ShowHelpNotification(Config.locales[1])
			if Config.job.jobs then
				if IsControlJustPressed(1, 38) then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.job.jobname then
						s = false
						open_menu_Event()
					else
						exports['mythic_notify']:SendAlert('Inform', Config.locales[26] )
            		end
				end
			else
				if IsControlJustPressed(1, 38) then
					s = false
					open_menu_Event()
				end
			end
        end
        Citizen.Wait(wait)
    end
end

function open_menu_Event()
	ESX.UI.Menu.CloseAll()
	
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), '1553_menu',
    	{
    	    title    = Config.locales[2],
    	    elements = {
				{label = Config.locales[3], value = 'start_airplane'},
				{label = Config.locales[4], value = 'EXP'},
				{label = Config.locales[5], value = 'end_Event'},
    	    }
    	},
    	function(data, menu)
			local pedcoords = GetEntityCoords(PlayerPedId())
        	local dist = GetDistanceBetweenCoords(pedcoords, Config.NPC.x, Config.NPC.y, Config.NPC.z, true)
			if dist < 3 then
    	    	if data.current.value == 'start_airplane' then
					TriggerEvent('dms_flyjob:Event')
					TriggerEvent("rtx_notify:Notify", "空中運輸", "駕駛你的飛機前往貨物點", 5000, "missionst")
					menu.close()
				elseif data.current.value == 'EXP' then
					ESX.TriggerServerCallback('dms_flyjob:get', function(result)
						local name = result[1].name
						local kill = result[1].exp
						exports['mythic_notify']:SendAlert('Inform', name ..Config.locales[7].. kill)
					end)
					menu.close()
					startJob()
				elseif data.current.value == 'end_Event' then
					menu.close()
					startJob()
    	    	end
			end
    	end,	
    function(data, menu)
        menu.close()
		startJob()
    end)
end

RegisterNetEvent('dms_flyjob:Event')
AddEventHandler('dms_flyjob:Event', function()
	local zones = Config.zones[math.random(1, #Config.zones)]
	local blip = CreateMissionBlip(zones)
	SetNewWaypoint(zones)
	PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
	TriggerEvent("rtx_notify:Notify", "空中運輸", "GPS已發送", 5000, "missionst")
	StartNow = false
	StartNow2 = true
	StartNow3 = true
	routeStartNow(zones,blip)
end)

function ShowFloatingHelpNotification(msg, coords)
	SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(2, false, true, -1)
end

function routeStartNow(zones,blip)
	if not StartNow then
		local zones2 = Config.zones2[math.random(1, #Config.zones2)]
		SetNewWaypoint(zones)
		while true do
			Citizen.Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		    local carModel = GetEntityModel(veh)
			if GetDistanceBetweenCoords(coords, zones.x, zones.y, zones.z, true) < 5 then
				DrawMarker(1, zones.x, zones.y, zones.z, 0, 0, 0, 0, 0, 0, 5.0000, 5.0000, 0.6001,255,0,0, 200, 0, 0, 0, 0)
				ShowFloatingHelpNotification(Config.locales[9], zones)
				if IsControlJustPressed(0, 38) then
					if isCarBlacklisted(carModel) then
						FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), true)
						TriggerEvent("rtx_notify:Notify", "空中運輸", "裝載貨物中", 5000, "info")	
						RemoveBlip(blip)
						Citizen.Wait(5000)
						FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), false)
						StartNow = true
						StartNow2 = false
						StartNow3 = false
						routeStartNow_2(zones2)
						return StartNow
					else
						TriggerEvent("rtx_notify:Notify", "空中運輸", "你需要駕駛指定載具", 5000, "error")
					end
				end
			end
		end
	end
end

function routeStartNow_2(zones2)
	if not StartNow2 then
		SetNewWaypoint(zones2)
		local blip2 = CreateMissionBlip_v2(zones2)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		TriggerEvent("rtx_notify:Notify", "空中運輸", "GPS已發送", 5000, "missionst")
		TriggerEvent("rtx_notify:Notify", "空中運輸", "駕駛你的飛機前往交貨點", 5000, "missionst")
		while true do
			Citizen.Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		    local carModel = GetEntityModel(veh)
			if GetDistanceBetweenCoords(coords, zones2.x, zones2.y, zones2.z, true) < 5 then
				DrawMarker(1, zones2.x, zones2.y, zones2.z, 0, 0, 0, 0, 0, 0, 5.0000, 5.0000, 0.6001,255,0,0, 200, 0, 0, 0, 0)
				ShowFloatingHelpNotification(Config.locales[13], zones2)
				if IsControlJustPressed(0, 38) then
					if isCarBlacklisted(carModel) then
						FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), true)
						TriggerEvent("rtx_notify:Notify", "空中運輸", "交付貨物中", 5000, "info")
						Citizen.Wait(5000)
						FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), false)
						StartNow2 = true
						StartNow3 = false
						RemoveBlip(blip2)
						routeStartNow_3(Config.zones3)
						return StartNow2
					else
						TriggerEvent("rtx_notify:Notify", "空中運輸", "你需要駕駛指定載具", 5000, "error")
					end
				end
			end
		end
	end
end

function routeStartNow_3(zones3)
	if not StartNow3 then
		SetNewWaypoint(zones3)
		local blip3 = CreateMissionBlip_v3(zones3)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		TriggerEvent("rtx_notify:Notify", "空中運輸", "駕駛你的飛機返回公司", 5000, "missionst")
		while true do
			Citizen.Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		    local carModel = GetEntityModel(veh)
			if GetDistanceBetweenCoords(coords, zones3.x, zones3.y, zones3.z, true) < 5 then
				DrawMarker(1, zones3.x, zones3.y, zones3.z, 0, 0, 0, 0, 0, 0, 5.0000, 5.0000, 0.6001,255,0,0, 200, 0, 0, 0, 0)
				ShowFloatingHelpNotification(Config.locales[15], zones3)
				if IsControlJustPressed(0, 38) then
					if isCarBlacklisted(carModel) then
						FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), true)
						TriggerEvent("rtx_notify:Notify", "空中運輸", "返回公司", 5000, "info")
						Citizen.Wait(5000)
						FreezeEntityPosition(GetVehiclePedIsUsing(PlayerPedId()), false)
						StartNow3 = true
						RemoveBlip(blip3)
						TriggerServerEvent('dms_flyjob:jobexp')
						TriggerServerEvent('dms_flyjob:money')
						local exps = math.random(5,10)
						TriggerEvent("rtx_notify:Notify", "空運", "你獲得經驗", 5000, "missionse")	
						TriggerServerEvent('0mission0:getPointforMission', 4, 1)
						TriggerServerEvent("battlepass:addXP",GetPlayerServerId(PlayerId()),exps)
						startJob()
						return StartNow3
					else
						TriggerEvent("rtx_notify:Notify", "空運", "我屌你", 5000, "success")	
					end
				end
			end
		end
	end
end

function CreateMissionBlip(location)
	local blip = AddBlipForCoord(location.x,location.y,location.z)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', Config.locales[17])
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.9)
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
	return blip
end

function CreateMissionBlip_v2(location)
	local blip = AddBlipForCoord(location.x,location.y,location.z)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', Config.locales[18])
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.9)
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
	return blip
end

function CreateMissionBlip_v3(location)
	local blip = AddBlipForCoord(location.x,location.y,location.z)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', Config.locales[19])
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.9)
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
	return blip
end

function isCarBlacklisted(model)
	Citizen.Wait(1000)
	for _, blacklistedCar in pairs(Config.Vehicles) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end
	return false
end