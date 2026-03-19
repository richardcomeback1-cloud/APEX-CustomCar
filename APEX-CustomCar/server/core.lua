local ESX = exports[Config.ExportResources.esExtended]:getSharedObject()
local rateLimitState = {}

local function toJson(data)
    local ok, encoded = pcall(json.encode, data)
    if ok then return encoded end
    return nil
end

local function getValidationConfig()
    return Config.Validation or {}
end

local function normalizePlate(plate)
    return tostring(plate or ''):gsub('^%s*(.-)%s*$', '%1'):upper()
end

local function canProcessEvent(src, key, cooldownMs)
    local now = GetGameTimer()
    local playerState = rateLimitState[src]
    if not playerState then
        playerState = {}
        rateLimitState[src] = playerState
    end

    local lastAt = playerState[key] or 0
    if now - lastAt < (cooldownMs or 0) then
        return false
    end

    playerState[key] = now
    return true
end

local function isPlayerDrivingVehicle(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then
        return false, 0
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= ped then
        return false, vehicle
    end

    return true, vehicle
end

CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS apex_customcar_props (
            plate VARCHAR(32) PRIMARY KEY,
            props LONGTEXT,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]])
end)

local function handleRemoveCash(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local amt = tonumber(amount) or 0
    local validation = getValidationConfig()
    if not canProcessEvent(src, 'removeCash', validation.removeCashCooldownMs or 150) then return end
    if not xPlayer or amt <= 0 or amt > (validation.maxChargeAmount or 5000000) then return end
    if xPlayer.getMoney() < amt then return end
    xPlayer.removeMoney(amt)
end

RegisterNetEvent(('%s:%s'):format(Config.ScriptName, 'removeCash'))
AddEventHandler(('%s:%s'):format(Config.ScriptName, 'removeCash'), handleRemoveCash)

local function handleUpdateProperties(props)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local validation = getValidationConfig()
    if not canProcessEvent(src, 'updateProperties', validation.updatePropsCooldownMs or 250) then return end
    if not xPlayer or type(props) ~= 'table' then return end

    local plate = normalizePlate(props.plate or (props.plateIndex and tostring(props.plateIndex)) or nil)
    if not plate or plate == '' then return end

    local isDriver, vehicle = isPlayerDrivingVehicle(src)
    if not isDriver or vehicle == 0 then return end

    local currentPlate = normalizePlate(GetVehicleNumberPlateText(vehicle))
    if currentPlate == '' or currentPlate ~= plate then return end

    props.plate = plate
    local payload = toJson(props)
    if not payload then return end
    if #payload > (validation.maxPropsPayloadBytes or 65535) then return end

    MySQL.execute('REPLACE INTO apex_customcar_props (plate, props) VALUES (?, ?)', { plate, payload })
end

RegisterNetEvent(('%s:%s'):format(Config.ScriptName, 'updateProperties'))
AddEventHandler(('%s:%s'):format(Config.ScriptName, 'updateProperties'), handleUpdateProperties)

local function handleGetProperties(source, cb, plate)
    local validation = getValidationConfig()
    if not canProcessEvent(source, 'getProperties', validation.getPropsCooldownMs or 200) then
        cb(nil)
        return
    end

    plate = normalizePlate(plate)
    if not plate or plate == '' then cb(nil) return end

    MySQL.single('SELECT props FROM apex_customcar_props WHERE plate = ?', { plate }, function(row)
        if row and row.props then
            local ok, decoded = pcall(json.decode, row.props)
            if ok then
                cb(decoded)
                return
            end
        end
        cb(nil)
    end)
end

ESX.RegisterServerCallback(('%s:%s'):format(Config.ScriptName, 'getProperties'), handleGetProperties)

AddEventHandler('playerDropped', function()
    rateLimitState[source] = nil
end)
