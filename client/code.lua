ESX = nil

Citizen.CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end end)

local UseLegacyFuel = true -- set this to true if you use legacy fuel, false if you don't use it.

RegisterCommand('givecar', function(source, args, rawCommand) 
    while not ESX do Citizen.Wait(500) end
    while not ESX.IsPlayerLoaded() do Citizen.Wait(500) end

    local ped = PlayerPedId()

    if args[1] then
        if IsModelInCdimage(args[1]) then
            ESX.TriggerServerCallback('esxGOV:CallBack', function(isAdmin)
                if isAdmin then
                    local modelOrHash = args[1]
                    local newPlate = exports['esx_vehicleshop']:GeneratePlate()

                    while newPlate == nil do
                        Citizen.Wait(1000)
                    end

                    if ESX.Game.IsSpawnPointClear(GetEntityCoords(ped), 5) then
                        ESX.Game.SpawnVehicle(modelOrHash, GetEntityCoords(ped), GetEntityHeading(ped), function(callback_vehicle)
                            ESX.SetTimeout(1000,function()
                                SetVehicleNumberPlateText(callback_vehicle, newPlate)
                                TaskWarpPedIntoVehicle(ped, callback_vehicle, -1)
                            end)
                            ESX.SetTimeout(1000,function()
                                if UseLegacyFuel then
                                    exports['LegacyFuel']:SetFuel(callback_vehicle, 100)
                                end

                                local vehicleProps = ESX.Game.GetVehicleProperties(callback_vehicle)
                                
                                vehicleProps.plate = newPlate
                                TriggerServerEvent('esxGOV:setOwnedVehicle', vehicleProps)
                            end)
                        end)
                    else
                        ESX.ShowNotification('You do not have space here to spawn the vehicle.')
                    end
                end
            end)
        else
            ESX.ShowNotification('Invalid vehicle model.')
        end
    end
end, true) -- is it restricted?
