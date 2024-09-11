ESX = exports['es_extended']:getSharedObject()

local keys = {}

function giveKeys(plate)
    --print(plate)
    table.insert(keys, plate)
end

RegisterNetEvent('tg-carkeys:client:givekeytoplayer', function(plate)
	table.insert(keys, plate)
end)

function removeKey(plate)
    for k,v in pairs(keys) do
        if v == plate then
            table.remove(keys, k)
        end
    end
end

function ToggleVehicleLock()
    local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle
    --lockAnimation()
    if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 71)
	end
	if not DoesEntityExist(vehicle) then
		return
	end
    local plate =  ESX.Game.GetVehicleProperties(vehicle).plate
	--print(plate)
    local isOwner = lib.callback.await('tg-carkeys:callback:getowner', 100, plate)
	if isOwner then
		local lockStatus = GetVehicleDoorLockStatus(vehicle)
		if lockStatus == 1 then -- unlocked
			SetVehicleDoorsLocked(vehicle, 2)
			SetVehicleDoorsLockedForAllPlayers(vehicle, true)
			lockAnimation()				
			SetVehicleLights(vehicle, 2)
			Citizen.Wait(250)
			SetVehicleLights(vehicle, 0)
			--Citizen.Wait(250)
			StartVehicleHorn (vehicle, 500, "NORMAL", -1)
			PlayVehicleDoorCloseSound(vehicle, 1)
			
			--Citizen.Wait(450)
			--PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)
			ESX.ShowNotification('Vehicle has been locked', 'success', 5000)
		elseif lockStatus == 2 then -- locked
			SetVehicleDoorsLocked(vehicle, 1)
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
			lockAnimation()
			SetVehicleLights(vehicle, 2)
			Citizen.Wait(250)
			SetVehicleLights(vehicle, 0)
			--Citizen.Wait(250)
			--StartVehicleHorn (vehicle, 500, "NORMAL", -1)
			PlayVehicleDoorOpenSound(vehicle, 0)				
			--Citizen.Wait(450)
			--PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)

			ESX.ShowNotification('Vehicle has been unlocked', 'success', 5000)
		end
	else
		local haskey = Getkeys(plate)
		if haskey then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)
			if lockStatus == 1 then -- unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				SetVehicleDoorsLockedForAllPlayers(vehicle, true)
				lockAnimation()				
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(250)
				SetVehicleLights(vehicle, 0)
				--Citizen.Wait(250)
				StartVehicleHorn (vehicle, 500, "NORMAL", -1)
				PlayVehicleDoorCloseSound(vehicle, 1)
				
				--Citizen.Wait(450)
				--PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)
				ESX.ShowNotification('Vehicle has been locked', 'success', 5000)
			elseif lockStatus == 2 then -- locked
				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				lockAnimation()
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(250)
				SetVehicleLights(vehicle, 0)
				--Citizen.Wait(250)
				--StartVehicleHorn (vehicle, 500, "NORMAL", -1)
				PlayVehicleDoorOpenSound(vehicle, 0)				
				--Citizen.Wait(450)
				--PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)
	
				ESX.ShowNotification('Vehicle has been unlocked', 'success', 5000)
			end
		else
			ESX.ShowNotification('Vehicle is not yours', 'error', 5000)
		end
	end
end

function Getkeys(plate)
	local has = false
	for k,v in pairs(keys) do
		if v == plate then
			has = true
		end
	end
	return has
end

RegisterCommand('togglekeys', function ()
	ToggleVehicleLock()
end)

function lockAnimation()
    local ply = PlayerPedId()
	if not IsPedInAnyVehicle(ply, true) then
		RequestAnimDict("anim@heists@keycard@")
		while not HasAnimDictLoaded("anim@heists@keycard@") do
			Wait(0)
		end
    	TaskPlayAnim(ply, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
	end
    Citizen.Wait(50)
    ClearPedTasks(ply)
end

RegisterKeyMapping('togglekeys', 'Toggle Keys', 'keyboard', 'u')

exports("giveKeys", giveKeys)
exports("removeKey", removeKey)
