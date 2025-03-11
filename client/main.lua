if (GetResourceState("es_extended") == "started") then
    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
	elseif GetResourceState('qb-core') == 'started' then
		ESX = {}
	QB = exports['qb-core']:GetCoreObject()

	else
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end

if QB then
	ESX.ShowHelpNotification = QB.Functions.Notify
	ESX.ShowNotification = QB.Functions.Notify
end




CreateThread(function()
	while true do
	        local sleep = 500  
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)		
		
		for k, v in pairs(Config.BellPoints) do	
			if #(playerCoords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
				sleep = 0
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				if #(playerCoords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.InteractDistance then
					ESX.ShowHelpNotification(_U('trigger'))
					if IsControlJustReleased(0, 38) then
						ESX.ShowNotification(_U('used'))
						TriggerServerEvent('lama_ring:triggerBell', v.Job, v.Image, v.Title, v.SubTitle, v.Text)					
						if Config.UseInteractSound and GetResourceState('interact-sound') == "started" then
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 1.5, Config.SoundName, 1.0)
						end
					end	
				end
			end
		end
		Wait(sleep)
	end			
end)

