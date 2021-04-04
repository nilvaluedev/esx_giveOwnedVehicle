--------------------------------------------------------------------
--                  Code by: 我吃了你妈妈#5871                     --
--------------------------------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esxGOV:setOwnedVehicle')
AddEventHandler('esxGOV:setOwnedVehicle', function(vehicleProps)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then 
        if xPlayer.getGroup() == 'admin' then
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
                ['@owner']   = xPlayer.identifier,
                ['@plate']   = vehicleProps.plate,
                ['@vehicle'] = json.encode(vehicleProps)
            }, function(rowsChanged)
                if rowsChanged == 1 then
                    xPlayer.showNotification('The vehicle with the plate ~y~'..vehicleProps.plate..'~w~ is now yours.')
                elseif rowsChanged == 0 then
                    xPlayer.showNotification('You gotta repeat what you have done. (Returned false)')
                end
            end)
        else
            xPlayer.showNotification('You do not have permission to do this.')
        end
    end
end)

RegisterCommand('delplate', function(source, args, rawCommand) 
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if args[1] then
        local thePlate = args[1]

        if xPlayer then 
            if xPlayer.getGroup() == 'admin' then
                MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
                    ['@plate'] = thePlate
                }, function(rowsChanged)
                    if rowsChanged == 1 then
                        xPlayer.showNotification('The vehicle with the plate ~y~'..thePlate..'~w~ has been removed.')
                    elseif rowsChanged == 0 then
                        xPlayer.showNotification('You gotta repeat what you have done. (Returned false)')
                    end
                end)
            else
                xPlayer.showNotification('You do not have permission to do this.')
            end
        end
    end

end, true) -- is it restricted? 

ESX.RegisterServerCallback('esxGOV:CallBack', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == 'admin' then
    	cb(true)
	else
		xPlayer.showNotification('You do not have permission to do this.')
	    cb(false)
    end
end)
