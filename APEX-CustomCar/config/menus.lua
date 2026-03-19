Config = Config or {}

Config.Menus = {
    ['empty'] = {
        title = 'Custom',
        options = {},
    },
    ['main'] = {
        title = 'Custom',
        options = {
            { label = 'Body', labelTH = 'ของตกแต่ง',  img = 'cosmatic',  openSubMenu = 'visual' },
            { label = 'Upgrade', labelTH = 'อัปเกรดสมรรถนะ', img = 'upgrade', openSubMenu = 'upgrade' },
            -- { label = 'Repair',  img = 'repair',  price = Config.VehicleRepairPrice,
            --     onSelect = function()
            --     repairtVehicle(customVehicle)
            --     end
            -- },
        },
        onBack = function() closeUI(1) end,
        defaultOption = 1
    },
    ['upgrade'] = {
        title = 'UPGRADES',
        options = {
            { label = 'Engine',       img = 'engine',       modType = 11, priceMult = Config.VehicleCustomisePriceMultiplier['engine'] },
            { label = 'Brakes',       img = 'brakes',       modType = 12, priceMult = Config.VehicleCustomisePriceMultiplier['brakes'] },
            { label = 'Transmission', img = 'transmission', modType = 13, priceMult = Config.VehicleCustomisePriceMultiplier['transmission'] },
            { label = 'Suspension',   img = 'suspension',   modType = 15, priceMult = Config.VehicleCustomisePriceMultiplier['suspension'] },
            { label = 'Armor',        img = 'armor',        modType = 16, priceMult = Config.VehicleCustomisePriceMultiplier['armor'] },
            { label = 'Turbo',        img = 'turbo',        modType = 18, priceMult = Config.VehicleCustomisePriceMultiplier['turbo'] },
        },
        onBack = function() updateMenu('main') end
    },
    ['visual'] = {
        title = 'VISUALS',
        options = {
            { label = 'Body Part',   img = 'body',     openSubMenu = 'body_parts' },
            { label = 'Inside Part', img = 'interior', openSubMenu = 'inside_parts' },
            { label = 'Respray',     img = 'respray',  openSubMenu = 'respray' },
            { label = 'Wheel',       img = 'wheel',    openSubMenu = 'wheels',
                onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', { x = -1.8, y = 0.0, z = 0.0 }, { x = 0.0, y = 0.0, z = -20.0 })
                end
            },
            { label = 'Plate',   img = 'plate',      openSubMenu = 'plate' },
            { label = 'Lights',  img = 'headlights', openSubMenu = 'lights' },
            { label = 'Sticker', img = 'livery',     openSubMenu = 'stickers' },
            { label = 'Extra', img = 'plus',       modType = 'extras',      priceMult = Config.VehicleCustomisePriceMultiplier['extras'] },
            { label = 'Window Tint', img = 'door',   modType = 'windowTint',  priceMult = Config.VehicleCustomisePriceMultiplier['windowTint'],
                onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'window_lf', { x = -2.0, y = 0.0, z = 0.0 }, { x = 0.0, y = 0.0, z = -10.0 })
                end,
                onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end
            },
            { label = 'Horn',         img = 'horn',         modType = 14, priceMult = Config.VehicleCustomisePriceMultiplier['horn'] },
            { label = 'Speakers',     img = 'speaker',      modType = 36, priceMult = Config.VehicleCustomisePriceMultiplier['speakers'] },
            { label = 'Trunk',        img = 'trunk',        modType = 37, priceMult = Config.VehicleCustomisePriceMultiplier['trunk'],
                onSelect = function()
                    openDoors(customVehicle, { 0, 0, 0, 0, 0, 1, 1 })
                end
            },
            { label = 'Hydrulics',    img = 'hydrulics',    modType = 38, priceMult = Config.VehicleCustomisePriceMultiplier['hydrulics'] },
            { label = 'Engine Block', img = 'engine_block', modType = 39, priceMult = Config.VehicleCustomisePriceMultiplier['engine_block'],
                onSelect = function()
                    openDoors(customVehicle, { 0, 0, 0, 0, 1, 0, 0 })
                end
            },
            { label = 'Air Filter',   img = 'air_filter',   modType = 40, priceMult = Config.VehicleCustomisePriceMultiplier['air_filter'],
                onSelect = function()
                    openDoors(customVehicle, { 0, 0, 0, 0, 1, 0, 0 })
                end
            },
            { label = 'Struts',       img = 'struts',       modType = 41, priceMult = Config.VehicleCustomisePriceMultiplier['struts'],
                onSelect = function()
                    openDoors(customVehicle, { 0, 0, 0, 0, 1, 0, 0 })
                end
            },
            { label = 'Tank',         img = 'gas_tank',     modType = 45, priceMult = Config.VehicleCustomisePriceMultiplier['tank'],
                onSelect = function()
                    openDoors(customVehicle, { 0, 0, 0, 0, 1, 1, 1 })
                end
            },
        },
        onBack = function() updateMenu('main') end
    },
    ['body_parts'] = {
        title = 'BODY PARTS',
        options = {
            { label = 'Spoilers',    img = 'spoiler', modType = 0, priceMult = Config.VehicleCustomisePriceMultiplier['spoilers'] },
            { label = 'FrontBumper', img = 'front_bumper',  modType = 1, priceMult = Config.VehicleCustomisePriceMultiplier['front_bumper'] },
            { label = 'Rear Bumper', img = 'rear_bumper', modType = 2, priceMult = Config.VehicleCustomisePriceMultiplier['rear_bumper'],
                onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', { x = 1, y = -6.0, z = 1.0 }, { x = -20.0, y = 0.0, z = -10.0 }) --{ x = 0.0, y = 0.0, z = 0.0 }, { x = เอียงขึ้นเอียงลง, y = เอียงซ้ายเอียงขวา, z = ซ้ายขวา })
                end,
                onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end
            },
            { label = 'Side Skirts', img = 'sideskirt', modType = 3, priceMult = Config.VehicleCustomisePriceMultiplier['side_skirts'],
                onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', { x = -2.5, y = 0.0, z = 0.0 }, { x = 0.0, y = 0.0, z = -20.0 })
                end,
                onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end
            },
            { label = 'Exhaust', img = 'exhaust', modType = 4, priceMult = Config.VehicleCustomisePriceMultiplier['exhaust'],
                onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', { x = 1, y = -6.0, z = 1.0 }, { x = -20.0, y = 0.0, z = -10.0 })
                end,
                onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end
            },
            { label = 'RollCage', img = 'rollcage', modType = 5, priceMult = Config.VehicleCustomisePriceMultiplier['cage'],
                onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'interiorlight', { x = 0.0, y = 1.0, z = -0.1 }, { x = 0.0, y = 0.0, z = 0.0 })
                end,
                onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end
            },
            { label = 'Grille',       img = 'grille',      modType = 6,  priceMult = Config.VehicleCustomisePriceMultiplier['grille'] },
            { label = 'Hood',         img = 'hood',        modType = 7,  priceMult = Config.VehicleCustomisePriceMultiplier['hood'] },
            { label = 'Left Fender',  img = 'leftfender',  modType = 8,  priceMult = Config.VehicleCustomisePriceMultiplier['left_fender'] },
            { label = 'Right Fender', img = 'rightfender', modType = 9,  priceMult = Config.VehicleCustomisePriceMultiplier['right_fender'] },
            { label = 'Roof',         img = 'roof',        modType = 10, priceMult = Config.VehicleCustomisePriceMultiplier['roof'] },
            { label = 'Arch Cover',   img = 'archcover',   modType = 42, priceMult = Config.VehicleCustomisePriceMultiplier['arch_cover'] },
            { label = 'Aerials',      img = 'aerials',     modType = 43, priceMult = Config.VehicleCustomisePriceMultiplier['aerials'] },
            { label = 'Wings',        img = 'wings',       modType = 44, priceMult = Config.VehicleCustomisePriceMultiplier['wings'] },
            { label = 'Windows',      img = 'door',        modType = 46, priceMult = Config.VehicleCustomisePriceMultiplier['windows'] },
        },
        onBack = function() updateMenu('visual') end
    },
    ['inside_parts'] = {
        title = 'INSIDE PARTS',
        options = {
            { label = 'Dashboard',       img = 'dashboard',      modType = 29,               priceMult = Config.VehicleCustomisePriceMultiplier['dashboard'] },
            { label = 'Dashboard Color', img = 'dashboardColor', modType = 'dashboardColor', customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['dashboard_color'],
                onSelect = function()
                    openColorPicker('Dashboard Color', 'dashboardColor', false, Config.VehicleCustomisePriceMultiplier['dashboard_color'])
                end
            },
            { label = 'Dial',            img = 'dashboard',      modType = 30,               priceMult = Config.VehicleCustomisePriceMultiplier['dial'] },
            { label = 'Door Speaker',    img = 'speaker',        modType = 31,               priceMult = Config.VehicleCustomisePriceMultiplier['door_speaker'],
                onSelect = function()
                    openDoors(customVehicle, { 1, 1, 1, 1, 0, 0, 0 })
                end
            },
            { label = 'Seat',            img = 'seat',           modType = 32,               priceMult = Config.VehicleCustomisePriceMultiplier['seat'] },
            { label = 'Steering Wheel',  img = 'steering_wheel', modType = 33,               priceMult = Config.VehicleCustomisePriceMultiplier['steering_wheel'] },
            { label = 'Shifter Leaver',  img = 'shifter_leaver', modType = 34,               priceMult = Config.VehicleCustomisePriceMultiplier['shifter_leaver'] },
            { label = 'Ornaments',       img = 'ornaments',      modType = 28,               priceMult = Config.VehicleCustomisePriceMultiplier['ornaments'] },
            { label = 'Interior',        img = 'body',           modType = 27,               priceMult = Config.VehicleCustomisePriceMultiplier['interior'] },
            { label = 'Interior Color',  img = 'interiorColor',  modType = 'interiorColor',  customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['interior_color'], 
                onSelect = function()
                    openColorPicker('Interior Color', 'interiorColor', false, Config.VehicleCustomisePriceMultiplier['interior_color'])
                end
            },
        },
        onBack = function() updateMenu('visual') end
    },
    ['respray'] = {
        title = 'RESPRAY',
        options = {
            { label = 'Primary',              img = 'respray', modType = 'color1',           customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['primary_paint'],
                onSelect = function()
                    openColorPicker('Primary Color', 'color1', true, Config.VehicleCustomisePriceMultiplier['primary_paint'])
                end
            },
            { label = 'Secondary',            img = 'respray', modType = 'color2',           customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['secondary_paint'],
                onSelect = function()
                    openColorPicker('Secondary Color', 'color2', true, Config.VehicleCustomisePriceMultiplier['secondary_paint'])
                end
            },
            { label = 'Primary Paint Type',   img = 'respray', modType = 'paintType1',       priceMult = Config.VehicleCustomisePriceMultiplier['primary_paint_type'] },
            { label = 'Secondary Paint Type', img = 'respray', modType = 'paintType2',       priceMult = Config.VehicleCustomisePriceMultiplier['secondary_paint_type'] },
            { label = 'Pearlescent',          img = 'respray', modType = 'pearlescentColor', customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['pearlescent'],
                onSelect = function()
                    openColorPicker('Pearlescent Color', 'pearlescentColor', false, Config.VehicleCustomisePriceMultiplier['pearlescent'])
                end
            },
        },
        onBack = function() updateMenu('visual') end
    },
    ['wheels'] = {
        title = 'WHEELS',
        options = {
            { label = 'Wheels Type',  img = 'wheel',
                onSelect = function()
                    updateMenu('wheels_type')
                end
            },
            { label = 'Wheels Color', img = 'wheelfigma', modType = 'wheelColor', customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['wheels_color'],
                onSelect = function()
                    openColorPicker('Wheels Color', 'wheelColor', false, Config.VehicleCustomisePriceMultiplier['wheels_color'])
                end
            },
            { label = 'Smoke Color',  img = 'tireSmoke', modType = 'tyreSmokeColor', customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['smoke_color'],
                onSelect = function()
                    openColorPicker('Tyre Smoke Color', 'tyreSmokeColor', true, Config.VehicleCustomisePriceMultiplier['smoke_color'])
                end
            },
        },
        onBack = function()
            updateMenu('visual')
            SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
        end
    },
    ['wheels_type'] = {
        title = 'WHEELS TYPE',
        options = {
            { label = 'Sport',       img = 'wheel',      modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['sport'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 0)
                end
            },
            { label = 'Muscle',      img = 'wheel',     modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['muscle'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 1)
                end
            },
            { label = 'Lowrider',    img = 'wheel',   modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['lowrider'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 2)
                end
            },
            { label = 'SUV',         img = 'wheel',        modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['suv'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 3)
                end
            },
            { label = 'Offroad',     img = 'wheel',    modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['offroad'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 4)
                end
            },
            { label = 'Tuner',       img = 'wheel',      modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['tuner'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 5)
                end
            },
            { label = 'Bike Wheels', img = 'wheel', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['bike_wheels'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 6)
                end
            },
            { label = 'High End',    img = 'wheel',    modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['high_end'],
                onSelect = function()
                    SetVehicleModData(customVehicle, 'wheels', 7)
                end
            },
        },
        onBack = function() updateMenu('wheels') end
    },
    ['plate'] = {
        title = 'PLATE',
        options = {
            { label = 'Type',   img = 'plate',  modType = 25, priceMult = Config.VehicleCustomisePriceMultiplier['plate_type'] },
            { label = 'Color', img = 'plate', modType = 'plateIndex', priceMult = Config.VehicleCustomisePriceMultiplier['plate_color'],
                onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'bumper_r',
                        { x = -2.0, y = -2.0, z = 1.5 }, { x = -30.0, y = 0.0, z = 0.0 })
                end,
                onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end
            },
            { label = 'Holder', img = 'holder', modType = 26, priceMult = Config.VehicleCustomisePriceMultiplier['plate_holder'] },
        },
        onBack = function() updateMenu('visual') end
    },
    ['lights'] = {
        title = 'LIGHTS',
        options = {
            { label = 'Xenon', img = 'headlights', modType = 'modXenon',  priceMult = Config.VehicleCustomisePriceMultiplier['xenon'],
                onSelect = function()
                    SetVehicleEngineOn(customVehicle, true, false, false) 
                end
            },
            { label = 'Neon',  img = 'neon',       modType = 'neonColor', customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['neon'],
                onSelect = function()
                    SetVehicleEngineOn(customVehicle, true, false, false); openColorPicker('Neon Color', 'neonColor', true, Config.VehicleCustomisePriceMultiplier['neon'])
                end
            },
        },
        onBack = function() updateMenu('visual') end
    },
    ['stickers'] = {
        title = 'STICKERS',
        options = {
            { label = 'Stickers', img = 'livery', modType = 48,       priceMult = Config.VehicleCustomisePriceMultiplier['stickers'] },
            { label = 'Livery',   img = 'livery', modType = 'livery', priceMult = Config.VehicleCustomisePriceMultiplier['livery'] },
        },
        onBack = function() updateMenu('visual') end
    },
}
