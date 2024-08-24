Config = {}

Config.blips = {
    {title="Viešasis sandelys", colour=39, id=478, coords=vector3(-851.9207, -1227.3839, 6.7648)},   
    {title="Ginklų parduotuvė", colour=2, id=110, coords=vector3(-843.2184, -1234.7150, 6.9339)},   
    {title="Parduoti savo ginklus", colour=28, id=110, coords=vector3(-840.1157, -1235.2251, 6.9339)},   

    {title="Viešasis sandelys", colour=39, id=478, coords=vector3(-1273.8916, 316.0669, 65.5118)},   
    {title="Ginklų parduotuvė", colour=2, id=110, coords=vector3(-1278.0542, 313.8918, 65.5118)},   
    {title="Parduoti savo ginklus", colour=28, id=110, coords=vector3(-1273.1123, 311.1172, 65.5113)},   
}

Config.Peds = {
    {
        model = "IG_Johnny_Guns",
        coords = {x = -1278.5814, y = 314.1122, z = 64.5, heading = 243.5020}
    },
    {
        model = "IG_Johnny_Guns",
        coords = {x = -843.4859, y = -1235.1643, z = 6.0, heading = 321.7308}
    },
    {
        model = "U_M_Y_GunVend_01",
        coords = {x = -1272.6031, y = 310.8475, z = 64.5, heading = 65.3802}
    },
    {
        model = "U_M_Y_GunVend_01",
        coords = {x = -839.8652, y = -1235.7159, z = 6.0, heading = 18.5336}
    },
    {
        model = "a_m_y_stbla_02",
        coords = {x  = -849.0466, y = -1230.6299, z = 6.0, heading = 350.8761}
    },
    {
        model = "s_m_m_doctor_01",
        coords = {x = -845.5973, y = -1231.8087, z = 6.0, heading = 267.6191}
    },
    {
        model = "S_M_Y_DockWork_01",
        coords = {x = -867.5551, y = -1219.9971, z = 4.75, heading = 300.3604}
    }
}

Config.rewards = {'money'}

Config.whiteListItems = {
    pistol = {price = 2000},
    appistol = {price = 95000},
    combatpistol = {price = 350},
    pistol50 = {price = 90000},
    snspistol = {price = 250},
    heavypistol = {price = 80000},
    smg = {price = 100000},
    microsmg = {price = 1100},
    assaultsmg = {price = 1300},
    combatpdw = {price = 110000},
    machinepistol = {price = 95000},
    assaultrifle = {price = 150000},
    carbinerifle = {price = 130000},
    advancedrifle = {price = 1700},
    specialcarbine = {price = 145000},
    bullpuprifle = {price = 140000},
    COMPACTRIFLE = {price = 100000},
    pumpshotgun = {price = 200000},
    sawnoffshotgun = {price = 600000},
    heavyrifle = {price = 690000},
    tacticalrifle = {price = 800000},
    precisionrifle = {price = 2400},
    ar15 = {price = 9000000},
    ak47 = {price = 9000000},
    fnx45 = {price = 40000000},
    m4 = {price = 30000000},
    glock22 = {price = 2000000},
    m9 = {price = 18000000},
    m70 = {price = 15000000},
    militaryrifle = {price = 150000},
}

Config.Markers = {
    {
        location = vector3(-843.1794, -1234.7676, 6.9339),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 0, g = 150, b = 255, alpha = 100},
        text = "[Pirkti ginklus ir amuniciją]",
        action = function()
            TriggerEvent("One-Codes:Outside:1")
            print("Interacted with marker 1") 
        end
    },
    {
        location = vector3(-840.0959, -1235.2557, 6.9339),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 255, g = 0, b = 0, alpha = 100},
        text = "[Parduoti savo ginklus]",
        action = function()
            TriggerEvent("One-Codes:Outside:2")
            print("Interacted with marker 2")
        end
    },


    {
        location = vector3(-851.8513, -1227.2627, 6.7519),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 0, g = 255, b = 0, alpha = 100},
        text = "[Atidaryti savo sandeli]",
        action = function()
            exports.ox_inventory:openInventory('stash', 'Viesas Sandelis')
            print("Interacted with marker 3")
        end
    },


    {
        location = vector3(-848.9828, -1230.1262, 6.8786),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 255, g = 255, b = 0, alpha = 100},
        text = "[Drabužine]",
        action = function()
            TriggerEvent("One-Codes:Outside:3")
            print("Interacted with marker 4")
        end
    },
    {
        location = vector3(-845.0399, -1231.8910, 6.9339),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 255, g = 255, b = 255, alpha = 100},
        text = "[Daktaras]",
        action = function()
            exports.ox_inventory:openInventory('shop', { type = "Doctor", id = 1 })
            print("Interacted with marker 5")
        end
    },

    -- hotel

    
    {
        location = vector3(-1278.0542, 313.8918, 65.5118),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 0, g = 150, b = 255, alpha = 100},
        text = "[Pirkti ginklus ir amuniciją]",
        action = function()
            TriggerEvent("One-Codes:Outside:1")
            print("Interacted with marker 1") 
        end
    },
    {
        location = vector3(-1273.1123, 311.1172, 65.5113),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 255, g = 0, b = 0, alpha = 100},
        text = "[Parduoti savo ginklus]",
        action = function()
            TriggerEvent("One-Codes:Outside:2")
            print("Interacted with marker 2")
        end
    },

    {
        location = vector3(-1273.8916, 316.0669, 65.5118),
        drawDistance = 10.0,
        interactDistance = 0.8,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 0, g = 255, b = 0, alpha = 100},
        text = "[Atidaryti savo sandeli]",
        action = function()
            exports.ox_inventory:openInventory('stash', 'Viesas Sandelis')
            print("Interacted with marker 3")
        end
    },


    {
        location = vector3(-864.2694, -1217.9884, 5.8176),
        drawDistance = 20.0,
        interactDistance = 1.0,
        size = vector3(0.3, 0.3, 0.3),
        color = {r = 255, g = 0, b = 0, alpha = 100},
        text = "[Parduoti tr.p]",
        action = function()
            ExecuteCommand("sellcar")
            print("Interacted with marker 2")
        end
    },
}
