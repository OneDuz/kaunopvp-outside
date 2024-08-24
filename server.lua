local ox_inventory = exports.ox_inventory
ESX = exports['es_extended']:getSharedObject()
local PlayerMoneyTypes = {}

RegisterServerEvent("One-Codes:Outside:registerAndOpenStash")
AddEventHandler('One-Codes:Outside:registerAndOpenStash', function(moneyType)
    local src = source
    local stashId = 'SellWeapons_' .. src
    local stashLabel = 'Parduoti Ginklus'
    local xPlayer = ESX.GetPlayerFromId(src)

    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local distance = #(playerCoords - Config.Markers[2].location)
    local distance2 = #(playerCoords - Config.Markers[7].location)
    if distance > 2.0 and distance2 > 2.0 then
        xPlayer.showNotification("Too far / cheat?")
        exports["KaunasPvP-Direction"]:fg_BanPlayer(src, "Tried to execute a trigger via executer to open black market fui nx", true)
    else
        ox_inventory:RegisterStash(stashId, stashLabel, 5, 100000, src)
        TriggerClientEvent('ox_inventory:openInventory', src, 'stash', stashId)
        PlayerMoneyTypes[src] = moneyType
    end
end)


local function itemHandler(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local moneyType = PlayerMoneyTypes[src] or 'normal'
    local stashId = 'SellWeapons_' .. src
    local chance = math.random(1, 2)
    local stashItems = ox_inventory:GetInventoryItems(stashId)

    if stashItems then
        for _, item in pairs(stashItems) do
            local itemName = string.lower(item.name):gsub("weapon_", "")
            if Config.whiteListItems[itemName] then
                local priceItem = Config.whiteListItems[itemName].price
                ox_inventory:RemoveItem(stashId, item.name, item.count)
                local reward = chance == 2 and math.random(100, 10000) or item.count * priceItem / 2 + math.random(1, 10000)
                if moneyType == 'black' then
                    xPlayer.addAccountMoney('black_money', reward)
                else
                    xPlayer.addMoney(reward)
                end
            end
        end
    end
end


AddEventHandler('playerDropped', function()
    local src = source
    PlayerMoneyTypes[src] = nil
end)


Citizen.CreateThread(function()
    while true do
        local players = ESX.GetPlayers()
        for _, playerId in pairs(players) do
            itemHandler(playerId)
        end
        Citizen.Wait(3000)
    end
end)


function GenerateShareLink()
    local randomString = ''
    local charset = {}
    for i = 48,  57 do table.insert(charset, string.char(i)) end
    for i = 65,  90 do table.insert(charset, string.char(i)) end
    for i = 97, 122 do table.insert(charset, string.char(i)) end
    for i = 1, 10 do
        randomString = randomString .. charset[math.random(#charset)]
    end
    return randomString
end


lib.callback.register('One-Codes:Outside:getPlayerOutfits', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local outfits = {}
    
    if xPlayer then
        local result = MySQL.Sync.fetchAll('SELECT outfit_name, outfit_data FROM player_outfits WHERE player_identifier = @identifier',
        {
            ['@identifier'] = xPlayer.identifier
        })

        for i=1, #result, 1 do
            table.insert(outfits, {
                name = result[i].outfit_name,
                data = json.decode(result[i].outfit_data)
            })
        end
    end

    return outfits
end)

lib.callback.register('One-Codes:Outside:importOutfitWithLink', function(source, shareLink)
    local data = {
        outfitData = nil,
        creatorName = nil,
        createdAt = nil,
    }

    MySQL.Async.fetchAll('SELECT outfit_name, outfit_data, creator_name, created_at FROM shared_outfits WHERE share_link = @link', {
        ['@link'] = shareLink
    }, function(result)
        if result and result[1] then
            local outfitData = json.decode(result[1].outfit_data)
            local creatorName = result[1].creator_name
            local createdAt = result[1].created_at

            if not outfitData then
                return false
            end

            if outfitData and creatorName and createdAt then
                data.outfitData = outfitData
                data.creatorName = creatorName
                data.createdAt = createdAt
            else
                data = nil
            end
        else
            return false
        end
    end)
    Wait(150) -- Wait for the SQL query to complete.

    if data and data.outfitData and data.creatorName and data.createdAt then
        return data.outfitData, data.creatorName, data.createdAt
    else
        return nil
    end
end)


lib.callback.register('One-Codes:Outside:shareOutfit', function(source, outfitName, outfitData)
    local xPlayer = ESX.GetPlayerFromId(source)
    local shareLink = GenerateShareLink()
    if xPlayer then
        MySQL.Async.execute('INSERT INTO shared_outfits (outfit_name, outfit_data, share_link, creator_id, creator_name) VALUES (@name, @data, @link, @creatorId, @creatorName)', {
            ['@name'] = outfitName,
            ['@data'] = json.encode(outfitData),
            ['@link'] = shareLink,
            ['@creatorId'] = xPlayer.identifier,
            ['@creatorName'] = GetPlayerName(source)
        }, function(rowsInserted)
            if rowsInserted > 0 then
            end
        end)
        return shareLink
    end
end)


lib.callback.register('One-Codes:Outside:overwriteOutfitByName', function(source, outfitName, newOutfitData)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.execute('UPDATE player_outfits SET outfit_data = @outfitData WHERE outfit_name = @name AND player_identifier = @identifier', {
            ['@outfitData'] = json.encode(newOutfitData),
            ['@name'] = outfitName,
            ['@identifier'] = xPlayer.identifier
        }, function(rowsChanged)
            if rowsChanged > 0 then
                return tonumber
            else
                return false
            end
        end)
    else
        return false
    end
end)

lib.callback.register('One-Codes:Outside:deleteOutfitByName', function(source, outfitName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.execute('DELETE FROM player_outfits WHERE outfit_name = @name AND player_identifier = @identifier', {
            ['@name'] = outfitName,
            ['@identifier'] = xPlayer.identifier
        }, function(rowsDeleted)
            if rowsDeleted > 0 then
                return true
            else
                return false
            end
        end)
    else
        return false
    end
end)

lib.callback.register('One-Codes:Outside:saveOutfit', function(source, outfitData, outfitName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.execute('INSERT INTO player_outfits (player_identifier, outfit_name, outfit_data) VALUES (@identifier, @outfitName, @outfitData)',
        {
            ['@identifier'] = xPlayer.identifier,
            ['@outfitName'] = outfitName,
            ['@outfitData'] = json.encode(outfitData)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                return true
            else
                return false
            end
        end)
    else
        return false
    end
end)


-- fake for hacker lfmao
RegisterNetEvent("One-Codes:Outside:GiveMoney")
AddEventHandler("One-Codes:Outside:GiveMoney", function(amount, type)
    print("cheat?")
    exports["KaunasPvP-Direction"]:fg_BanPlayer(source, "Bro got fooled on this trigger HAHA", true)
end)

RegisterNetEvent("One-Codes:Outside:GiveGun")
AddEventHandler("One-Codes:Outside:GiveGun", function(amount, item)
    print("cheat?")
    exports["KaunasPvP-Direction"]:fg_BanPlayer(source, "Bro got fooled on this trigger HAHA", true)
end)

lib.callback.register('One-Codes:Outside:GiveMoneyForSell', function(source)
    exports["KaunasPvP-Direction"]:fg_BanPlayer(source, "Bro got fooled on this trigger HAHA", true)
end)


ESX.RegisterUsableItem('medikit', function(source)
    TriggerClientEvent("One-Codes:Outside:5", source)
end)

lib.callback.register('One-Codes:medikit:Check', function(source)
    local haveitem = exports.ox_inventory:GetItem(source, "medikit")
    print(haveitem)
    return haveitem
end)

lib.callback.register('One-Codes:medikit:Check2', function(source)
    local haveitem = exports.ox_inventory:RemoveItem(source, "medikit", 1)
    if haveitem then
        exports.ox_inventory:RemoveItem(source, "healthstim", 1)
        return true
    else
        return false
    end
end)

lib.callback.register('One-Codes:healthstim:Check2', function(source)
    exports.ox_inventory:RemoveItem(source, "healthstim", 1)
end)