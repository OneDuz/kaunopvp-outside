ESX = exports['es_extended']:getSharedObject()

function SpawnPed(modelHash, x, y, z, heading)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    local ped = CreatePed(4, modelHash, x, y, z, heading, false, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    SetPedCanRagdoll(ped, true)
    SetEntityVisible(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(modelHash))
    SetPedDiesWhenInjured(ped, false)
    SetPedKeepTask(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    TaskLookAtEntity(ped, PlayerPedId(), -1, 2048, 3)
end

Citizen.CreateThread(function()
    for _, pedInfo in pairs(Config.Peds) do
        SpawnPed(pedInfo.model, pedInfo.coords.x, pedInfo.coords.y, pedInfo.coords.z, pedInfo.coords.heading)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearAnyMarker = false
        for _, marker in pairs(Config.Markers) do
            local distance = #(playerCoords - marker.location)
            if distance < marker.drawDistance and distance > marker.interactDistance then
                isNearAnyMarker = true
                DrawMarker(2, marker.location.x, marker.location.y, marker.location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, marker.size.x, marker.size.y, marker.size.z, marker.color.r, marker.color.g, marker.color.b, marker.color.alpha, false, false, 2, true, nil, nil, false)
            elseif distance < marker.interactDistance then
                isNearAnyMarker = true
                DrawText3D(marker.location.x, marker.location.y, marker.location.z, marker.text .. "\n~y~[E]~s~", 0.7)
                if IsControlJustReleased(0, 38) then
                    marker.action()
                end
            end
        end
        Citizen.Wait(isNearAnyMarker and 0 or 1000)
    end
end)


function DrawText3D(x, y, z, text, scl)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * scl
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0 * scale, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

lib.registerContext({
    id = 'gun_shop',
    title = 'Ginklų Parduotuvė',
    options = {
        {
            title = 'Ginklai',
            onSelect = function()
                exports.ox_inventory:openInventory('shop', { type = "Ammunation", id = 1 })
            end,
        },
        {
            title = 'Amunicija/Vaistinėlės/Šarvai',
            onSelect = function()
                exports.ox_inventory:openInventory('shop', { type = "Ammunation2", id = 1 })
            end,
        },
        {
            title = 'Priedai',
            onSelect = function()
                exports.ox_inventory:openInventory('shop', { type = "Ammunation3", id = 1 })
            end,
        },
    }
})


RegisterNetEvent("One-Codes:Outside:1")
AddEventHandler("One-Codes:Outside:1", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local invBusy = LocalPlayer.state.invBusy
    local distance = #(playerCoords - Config.Markers[1].location)
    local distance2 = #(playerCoords - Config.Markers[6].location)
    if distance > 2.0 and distance2 > 2.0 then
        print("Too far / cheat?")
        lib.notify({
            title = 'Invalidas esi su savo executer',
            type = 'error'
        })
        Wait(2000)
        TriggerEvent("onecodesinv:toggleNUI", true)
        Wait(2000)
        lib.callback('One-Codes:Outside:GiveMoneyForSell', true, function() end)
        TriggerEvent("onecodesinv:toggleNUI", false)
    else
        print("executed1")
        lib.showContext('gun_shop')
    end
end)

--[[


lib.callback('vip:getDaysLeft', source, function(data)
			if data.isVip then
                TriggerServerEvent('One-Codes:Outside:registerAndOpenStash')
			elseif not data.isVip then
                lib.notify({
                    title = 'Tik VIP gali naudotis ankstyvaisiais funkcijomis.',
                    description = '',
                    type = 'info',
                    position = 'top'
                })
			end
		end)

]]

RegisterNetEvent("One-Codes:Outside:2")
AddEventHandler("One-Codes:Outside:2", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - Config.Markers[2].location)
    local distance2 = #(playerCoords - Config.Markers[7].location)
    if distance > 2.0 and distance2 > 2.0 then
        print("Too far / cheat?")
        lib.notify({
            title = 'Invalidas esi su savo executer',
            type = 'error'
        })
        Wait(2000)
        TriggerEvent("onecodesinv:toggleNUI", true)
        Wait(2000)
        lib.callback('One-Codes:Outside:GiveMoneyForSell', true, function() end)
        TriggerEvent("onecodesinv:toggleNUI", false)
    else
        print("executed2")
        lib.registerContext({
            id = 'Saibas',
            title = 'Kokiom saibom gauti',
            options = {
              {
                title = 'Black Money',
                icon = 'sack-dollar',
                onSelect = function()
                    TriggerServerEvent('One-Codes:Outside:registerAndOpenStash', 'black')
                end,
              },
              {
                title = 'Money',
                icon = 'money-bill',
                onSelect = function()
                    TriggerServerEvent('One-Codes:Outside:registerAndOpenStash', 'normal')
                end,
              },
            }
          })

        lib.callback('vip:getDaysLeft', source, function(data)
			if data.isVip then
                lib.showContext('Saibas')
			elseif not data.isVip then
                lib.notify({
                    title = 'Tik VIP gali naudotis ankstyvaisiais funkcijomis.',
                    description = '',
                    type = 'info',
                    position = 'top'
                })
			end
		end)
    end
end)

RegisterNetEvent("One-Codes:Outside:4")
AddEventHandler("One-Codes:Outside:4", function()
        local playerPed = GetPlayerPed(-1)
        local originalHealth = GetEntityHealth(playerPed)
        local maxHealth = GetEntityMaxHealth(playerPed)
        local duration = 20000
        local healRate = 0.20
        local healAmount = math.ceil(maxHealth * healRate / (duration / 1000))
        local interval = 1000
        local minimumHealth = maxHealth * 0.10
        local boostHealth = originalHealth * 1.20

        lib.callback.await('One-Codes:healthstim:Check2', source)

        local function applyHealingEffect()
            StartScreenEffect("DrugsMichaelAliensFight", 0, true)
            Citizen.Wait(duration)
            StopScreenEffect("DrugsMichaelAliensFight")
        end

        Citizen.CreateThread(function()
            applyHealingEffect()
        end)

        Citizen.CreateThread(function()
            local endTime = GetGameTimer() + duration
            while GetGameTimer() < endTime do
                Citizen.Wait(interval)
                local currentHealth = GetEntityHealth(playerPed)
                local newHealth = math.min(currentHealth + healAmount, originalHealth + maxHealth * healRate)
                SetEntityHealth(playerPed, newHealth)
            end
        end)

        Citizen.Wait(duration)

        Citizen.CreateThread(function()
            local endTime = GetGameTimer() + duration
            while GetGameTimer() < endTime do
                Citizen.Wait(interval)
                local currentHealth = GetEntityHealth(playerPed)
                if currentHealth > boostHealth then
                    local newHealth = math.max(currentHealth - healAmount, minimumHealth)
                    SetEntityHealth(playerPed, newHealth)
                end
            end
        end)
end)


RegisterNetEvent("One-Codes:Outside:5")
AddEventHandler("One-Codes:Outside:5", function()
    print("2")
    local playerPed = GetPlayerPed(-1)
    local originalHealth = GetEntityHealth(playerPed)
    local maxHealth = GetEntityMaxHealth(playerPed)
    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'rcmfanatic1out_of_breath',
            clip = 'p_zero_tired_01'
        },
        prop = {
            model = `xm_prop_x17_bag_med_01a`,
            pos = vec3(0.30, 0.04, -0.1),
            rot = vec3(0.0, 300.0, 0.0)
        },}) then SetEntityHealth(playerPed, maxHealth) lib.notify({title = 'Panaudojai medkita',type = 'info'}) lib.callback.await("One-Codes:medikit:Check2", false) else lib.notify({title = 'Medkitas buvo nepanaudotas',type = 'info'}) end
end)

local clothingItems = {
    'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2', 'decals_1', 'decals_2', 'arms', 'arms_2',
    'pants_1', 'pants_2', 'shoes_1', 'shoes_2', 'mask_1', 'mask_2', 'helmet_1', 'helmet_2',
    'glasses_1', 'glasses_2', 'chain_1', 'chain_2', 'bags_1', 'bags_2', 'watches_1',
    'watches_2', 'bracelets_1', 'bracelets_2', 'bproof_1', 'bproof_2'
}

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

RegisterNetEvent("One-Codes:Outside:3")
AddEventHandler("One-Codes:Outside:3", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - Config.Markers[4].location)
    if distance > 2.0 then
        print("Too far / cheat?")
        lib.notify({
            title = 'Invalidas esi su savo executer',
            type = 'error'
        })
        Wait(2000)
        TriggerEvent("onecodesinv:toggleNUI", true)
        Wait(2000)
        lib.callback('One-Codes:Outside:GiveMoneyForSell', true, function() end)
        TriggerEvent("onecodesinv:toggleNUI", false)
    else
        print("executed3")
        -- lib.notify({
        --     title = '...',
        --     description = '',
        --     type = 'info',
        --     position = 'top'
        -- })
        lib.registerContext({
            id = 'some_menu',
            title = 'Drabužių meniu',
            options = {
                {
                    title = 'Pakrauti apranga',
                    icon = 'shirt',
                    onSelect = function()
                        lib.callback('One-Codes:Outside:getPlayerOutfits', true, function(outfits)
                            local outfitOptions = {}
                            for i, outfit in ipairs(outfits) do
                                table.insert(outfitOptions, {
                                    title = outfit.name,
                                    onSelect = function()
                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            local newOutfit = {}
                                            for key, value in pairs(skin) do
                                                if table.contains(clothingItems, key) then
                                                    newOutfit[key] = outfit.data[key]
                                                else
                                                    newOutfit[key] = skin[key]
                                                end
                                            end
                                            TriggerEvent('skinchanger:loadClothes', skin, newOutfit)
                                            ESX.ShowNotification("Apranga pakrauta: " .. outfit.name)
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                TriggerServerEvent('esx_skin:save', skin)
                                            end)
                                        end)
                                    end
                                })
                            end
                            lib.registerContext({
                                id = 'outfits_menu',
                                title = 'Jūsų apranga',
                                options = outfitOptions
                            })
                            lib.showContext('outfits_menu')
                        end)
                    end
                },
                {
                    title = 'Perrašyti aprangą',
                    icon = 'floppy-disk',
                    onSelect = function()
                        lib.callback('One-Codes:Outside:getPlayerOutfits', true, function(outfits)
                            local outfitOptions = {}
                            for i, outfit in ipairs(outfits) do
                                table.insert(outfitOptions, {
                                    title = outfit.name,
                                    onSelect = function()
                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            local clothingData = {}
                                            local clothingItems = {
                                                'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2', 'decals_1', 'decals_2', 'arms', 'arms_2',
                                                'pants_1', 'pants_2', 'shoes_1', 'shoes_2', 'mask_1', 'mask_2', 'helmet_1', 'helmet_2',
                                                'glasses_1', 'glasses_2', 'chain_1', 'chain_2', 'bags_1', 'bags_2', 'watches_1',
                                                'watches_2', 'bracelets_1', 'bracelets_2'
                                            }
                                            for _, item in ipairs(clothingItems) do
                                                clothingData[item] = skin[item]
                                            end

                                            lib.callback('One-Codes:Outside:overwriteOutfitByName', true, function(success)
                                                ESX.ShowNotification("Apranga perrašyta: " .. outfit.name)
                                            end, outfit.name, clothingData)
                                        end)
                                    end
                                })
                            end
                            lib.registerContext({
                                id = 'overwrite_outfits_menu',
                                title = 'Perrašyti aprangą',
                                options = outfitOptions
                            })
                            lib.showContext('overwrite_outfits_menu')
                        end)
                    end
                },                
              {
                title = 'Išsaugoti nauja apranga',
                icon = 'floppy-disk',
                onSelect = function()
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        local clothingData = {}

                        for _, item in ipairs(clothingItems) do
                            clothingData[item] = skin[item]
                        end

                        local input = lib.inputDialog('Išsaugokite naują aprangą', {'Aprangos pavadinimas'})

                        if not input then return end
                        lib.callback('One-Codes:Outside:saveOutfit', source, function(count)
                             print(count)
                        end, skin, input[1])
                    end)
                  print("Pressed the button!")
                end
              },
              {
                title = 'Ištrinti apranga',
                icon = 'trash',
                onSelect = function()
                    lib.callback('One-Codes:Outside:getPlayerOutfits', source, function(outfits)
                        local outfitOptions = {}
                        for i, outfit in ipairs(outfits) do
                            table.insert(outfitOptions, {
                                title = outfit.name,
                                onSelect = function()
                                    lib.callback('One-Codes:Outside:deleteOutfitByName', true, function(success)
                                        ESX.ShowNotification("Apranga ištrinta: " .. outfit.name)
                                    end, outfit.name)
                                end
                            })
                        end
                        lib.registerContext({
                            id = 'delete_outfits_menu',
                            title = 'Ištrinti apranga',
                            options = outfitOptions
                        })
                        lib.showContext('delete_outfits_menu')
                    end)
                end
            },            
            {
                title = 'Importuoti apranga',
                icon = 'file-import',
                onSelect = function()
                    local input = lib.inputDialog('Importuoti aprangą', {'Įveskite bendrinimo nuorodą:', 'Įveskite naują aprangos pavadinimą:'})
                    if not input then return end -- User cancelled the input
                    local shareLink = input[1]
                    local outfitName = input[2]
                    lib.callback('One-Codes:Outside:importOutfitWithLink', source, function(outfitData, creatorName, createdAt)
                            lib.callback('One-Codes:Outside:saveOutfit', source, function(count)
                                print(count)
                                ESX.ShowNotification("Apranga '" .. outfitName .. " sukurta '"..creatorName.."' sėkmingai importuotas ir išsaugotas.")
                            end, outfitData, outfitName)
                    end, shareLink)
                end
            },
            {
                title = 'Pasidalinti savo apranga',
                icon = 'share',
                onSelect = function()
                    lib.callback('One-Codes:Outside:getPlayerOutfits', source, function(outfits)
                        local outfitOptions = {}
                        for i, outfit in ipairs(outfits) do
                            table.insert(outfitOptions, {
                                title = outfit.name,
                                onSelect = function()
                                    local outfitData = outfit.data 
                                    lib.callback('One-Codes:Outside:shareOutfit', source, function(shareLink)
                                        lib.setClipboard(shareLink)
                                        ESX.ShowNotification("Apranga '" .. outfit.name .. "' sėkmingai bendrinamas!")
                                        ESX.ShowNotification("Nuoroda nukopijuota į iškarpinę")
                                    end, outfit.name, outfitData)
                                end
                            })
                        end
                        lib.registerContext({
                            id = 'share_outfits_menu',
                            title = 'Pasidalinkite savo apranga',
                            options = outfitOptions
                        })
                        lib.showContext('share_outfits_menu')
                    end)
                end
            },               
            }
          })
        lib.showContext('some_menu')
    end
end)

-- RegisterCommand("test", function(src, args, raw)
--     if args[1] == "1" then
--         TriggerEvent("One-Codes:Outside:1")
--     elseif args[1] == "2" then
--         TriggerEvent("One-Codes:Outside:2")
--     elseif args[1] == "3" then
--         LocalPlayer.state.invOpen = true
--     elseif args[1] == "4" then
--         LocalPlayer.state.invOpen = false
--     end
-- end)


Citizen.CreateThread(function()
    for _, info in pairs(Config.blips) do
        local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
        SetBlipSprite(blip, info.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, info.colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('<font face=\'FiraSans\'>'..info.title)
        EndTextCommandSetBlipName(blip)
    end
end)



-- f4k3
RegisterNetEvent("One-Codes:Outside:egh")
AddEventHandler("One-Codes:Outside:egh", function(what, amount, item, type)
    if what == 1 then
        TriggerServerEvent("One-Codes:Outside:GiveGun", amount, item)
    elseif what == 2 then
        TriggerServerEvent("One-Codes:Outside:GiveMoney", amount, type)
    end
end)