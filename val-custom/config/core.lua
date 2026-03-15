Config = Config or {}

-- the derailCard position on the top of the screen (0 = right, 1 = left)
Config.detailCardMenuPosition = 0

-- the cash amount position on the top of the screen (0 = right, 1 = left)
Config.cashPosition = 0

-- if this turned off every mechanic position will be able to to cosmetics and upgrades otherwise only whitelist job can do upgrades 
Config.IsUpgradesOnlyForWhitelistJobPoints = false

-- The key to access the mechanic menu, the key code and the name can be found here: https://docs.fivem.net/docs/game-references/controls/
Config.Keys = {
    action = {key = 38, label = 'E', name = '~INPUT_PICKUP~'}
}

-- The default values access disrance from position if "Config.Positions" misses the value actionDistance
Config.DefaultActionDistance = 8.0

-- The default values for the blip if "Config.Positions" misses the value "blip = {}"
Config.DefaultBlip = {
    enable = false,
    type = 72,
    color = 0,
    scale = 1.0
}

Config.DefaultMarker = {
    drawDistance = 40.0,
    enable = true,
    type = 36,
    positionOffset = { x = 0.0, y = 0.0, z = 1.0 },
    direction = { x = 0.0, y = 0.0, z = 0.0 },
    rotation = { x = 0.0, y = 0.0, z = 0.0 },
    scale = { x = 2.0, y = 3.0, z = 2.0 },
    color = { r = 255, g = 255, b = 255, a = 100 },
    bobUpAndDownAlways = false,
    bobUpAndDownOnAccess = true,
    faceCamera = false,
    rotating = true
}

-- Add or remove position for mechanic access points
-- pisition without "whitelistJobName" will be open for anyone and the price will have the multiple of "Config.PriceMultiplierWithoutTheJob" in "config/prices.lua"
-- if any position miss the "blip = {}" will be the default as seen above "Config.DefaultBlip"
-- if any position miss the "actionDistance" will be the default as seen above "Config.DefaultActionDistance"
Config.Positions = {
    {
        pos = vector3(-335.93, -134.34, 39.01),
        -- whitelistJobName = 'mechanic',
        blip = {
            enable = true,
            type = 847,
            color = 0,
            title = "<font face='dbheavent'>Customs Car</font>",
            scale = 0.8
        },
        marker = {
            enable = false,
            type = 1,
            positionOffset = { x = 0.0, y = 0.0, z = 0.3 },
            scale = { x = 27.0, y = 27.0, z = 1.5 },
            color = { r = 244, g = 98, b = 0, a = 100 },
        },
        actionDistance = 15.0
    },
    {
        pos = vector3(-212.59, -1325.17, 29.89),
        -- whitelistJobName = 'mechanic',
        blip = {
            enable = true,
            type = 847,
            color = 0,
            title = "<font face='dbheavent'>Customs Car</font>",
            scale = 0.8
        },
        marker = {
            enable = false,
            type = 1,
            positionOffset = { x = 0.0, y = 0.0, z = 0.3 },
            scale = { x = 27.0, y = 27.0, z = 1.5 },
            color = { r = 244, g = 98, b = 0, a = 100 },
        },
        actionDistance = 15.0
    },
}
