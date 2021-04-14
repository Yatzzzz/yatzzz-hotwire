ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

-- Citizen.CreateThread(function()
--     TriggerEvent('disc-base:registerItemUse', 'lockpick', function(source, item)
--         TriggerClientEvent('disc-hotwire:hotwire', source, true)
--     end)
-- end)

RegisterNetEvent('ARPF:removeKit')
AddEventHandler('ARPF:removeKit', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('lockpick', 1)
end)

RegisterServerEvent('disc-hotwire:givereward')
AddEventHandler('disc-hotwire:givereward', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local random = math.random(5, 20)
    xPlayer.addMoney(random)
    
end)

RegisterServerEvent('disc-hotwire:giveItem')
AddEventHandler('disc-hotwire:giveItem', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local random = math.random(1, 5)
    local giveCount = math.random(1, 3)
    if random == 1 then
        xPlayer.addInventoryItem("wallet", 1)
    elseif random == 2 then
        xPlayer.addInventoryItem("hamburger", giveCount)
    elseif random == 3 then
        xPlayer.addInventoryItem("bread", giveCount)
    elseif random == 4 then
        xPlayer.addInventoryItem("water", giveCount)
    end
end)

ESX.RegisterServerCallback('x-hotwire:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.getInventoryItem(item)
	if items == nil then
		cb(0)
	else
		cb(items.count)
	end
end)


function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
            sex = identity['sex'],
            group = identity["group"],
			height = identity['height']
			
		}
	else
		return nil
	end
end

RegisterServerEvent('ARPF:GiveKeys')
AddEventHandler('ARPF:GiveKeys', function(closestPlayer, plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(closestPlayer)
    local name = getIdentity(_source)
    local isim = name.firstname.. " " ..name.lastname

    local nameSource = getIdentity(closestPlayer)
    local isimSource = nameSource.firstname.. " " ..nameSource.lastname
    --nameplayer = GetPlayerName(_source)
    --TriggerClientEvent("ARPF:recivekeys", closestPlayer, isim, plate)
    TriggerClientEvent("keys:received", closestPlayer, plate)
    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = isimSource.. " kişisine " .. plate .. " plakalı aracının anahtarını verdin.", duration = 5000 })
end)



ESX.RegisterServerCallback('disc-hotwire:checkOwner', function(source, cb, plate)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
        ['@identifier'] = player.identifier,
        ['@plate'] = plate
    }, function(results)
        cb(#results == 1)
    end)
end)