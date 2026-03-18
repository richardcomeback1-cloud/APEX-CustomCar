local ESX = exports['es_extended']:getSharedObject()

local function toJson(data)
    local ok, encoded = pcall(json.encode, data)
    if ok then return encoded end
    return nil
end

local function normalizePlate(plate)
    return tostring(plate or ''):gsub('^%s*(.-)%s*$', '%1'):upper()
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
    if not xPlayer or amt <= 0 then return end
    if xPlayer.getMoney() < amt then return end
    xPlayer.removeMoney(amt)
end

RegisterNetEvent('APEX-CustomCar:removeCash')
AddEventHandler('APEX-CustomCar:removeCash', handleRemoveCash)

local function handleUpdateProperties(props)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(props) ~= 'table' then return end

    local plate = normalizePlate(props.plate or (props.plateIndex and tostring(props.plateIndex)) or nil)
    if not plate or plate == '' then return end

    props.plate = plate
    local payload = toJson(props)
    if not payload then return end

    MySQL.execute('REPLACE INTO apex_customcar_props (plate, props) VALUES (?, ?)', { plate, payload })
end

RegisterNetEvent('APEX-CustomCar:updateProperties')
AddEventHandler('APEX-CustomCar:updateProperties', handleUpdateProperties)

local function handleGetProperties(source, cb, plate)
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

ESX.RegisterServerCallback('APEX-CustomCar:getProperties', handleGetProperties)
