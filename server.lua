ESX = exports['es_extended']:getSharedObject()

lib.callback.register('tg-carkeys:callback:getowner', function(source, plate)
    local plates = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    --print(plate)
    local data = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = ?', {plate})
    if data[1] then
        if data[1].owner == xPlayer.getIdentifier() then
            return true
        end
    end
end)

lib.addCommand('givekey', {
    help = 'Gives an key to a player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'plate',
            type = 'string',
            help = 'plate of the vehicle to give',
        },
    },
}, function(source, args, raw)
    if not args.target then return end
    local playerPed = GetPlayerPed(source)
    local yPed = GetPlayerPed(args.target)
    local xCoord = GetEntityCoords(playerPed)
    local yCoord = GetEntityCoords(yPed)
    local distance = #(xCoord - yCoord)
    local xPlayer = ESX.GetPlayerFromId(source)
    if distance <= 5 then
    TriggerClientEvent('tg-carkeys:client:givekeytoplayer', args.target, args.plate)
    elseif distance > 5 then
        xPlayer.showNotification('player is not near')
    end
end)
