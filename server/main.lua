if (GetResourceState("es_extended") == "started") then
    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
	elseif (GetResourceState('qb-core') == 'started') and exports['qb-core'].GetCoreObject then
	QB = exports['qb-core']:GetCoreObject()
	ESX = {}
	else
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end

if QB then 
	ESX.GetPlayers = QB.Functions.GetPlayers
end

function getJob(source)
	if ESX then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer then
			return xPlayer.job.name
		end
	elseif QB then 
		local xPlayer = QB.Functions.GetPlayer(source)
		if xPlayer then
			return xPlayer.PlayerData.job.name
		end
	end
end

RegisterServerEvent('lama_ring:triggerBell')
AddEventHandler('lama_ring:triggerBell', function(job, image, title, subtitle, text)
	local _source = source
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		job = getJob(xPlayers[i])

			if xPlayerJob == job then
				if ESX then
					TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], title, subtitle, text, image, 1)	
				else
					TriggerClientEvent('QBCore:Notify', xPlayers[i], text)	
				end	
			end
	end
	Citizen.Wait(100)
end) 
