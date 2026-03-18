local uiOpen = false

customCamMain = nil
customCamSec = nil

customConfigPosIndex = nil
customVehicle = nil
customVehiclePrice = nil
customVehicleData = nil

local renderingScriptCam = false
local radarWasVisible = true
local lastUiCash = nil
local nuiMouseEnabled = false
local runtimeMenus = {}

isOpenByAdmin = false

local function getActionKey()
    return (Config and Config.Keys and Config.Keys.action and Config.Keys.action.key) or 38
end

local function getActionLabel()
    return (Config and Config.Keys and Config.Keys.action and Config.Keys.action.label) or 'E'
end

local function isInteractPressed()
    local key = getActionKey()
    return IsControlJustPressed(0, key) or IsControlJustReleased(0, key)
end

local function isPlayerDead(ped)
    if not ped or ped == 0 then return true end
    return IsEntityDead(ped) or IsPedFatallyInjured(ped)
end

local function getPerformanceConfig()
    return Config.Performance or {}
end

local function getDistanceSleepFar()
    return getPerformanceConfig().distanceSleepFar or 1000
end

local function getDistanceSleepNear()
    return getPerformanceConfig().distanceSleepNear or 250
end

local function getDistanceSleepMarkerVisible()
    return getPerformanceConfig().distanceSleepMarkerVisible or 0
end

local function getDistanceSleepInteract()
    return getPerformanceConfig().distanceSleepInteract or 0
end

local function getVectorDistanceSquared(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local dz = a.z - b.z
    return (dx * dx) + (dy * dy) + (dz * dz)
end

local function resetRuntimeMenus()
    runtimeMenus = {}
end

local function getMenuDefinition(menuId)
    if menuId == nil then
        return nil
    end

    return runtimeMenus[menuId] or Config.Menus[menuId]
end


local function getPlayerCash()
    local cash = nil

    if type(PlayerData) == 'table' then
        if type(PlayerData.money) == 'number' then
            cash = PlayerData.money
        elseif type(PlayerData.accounts) == 'table' then
            for i = 1, #PlayerData.accounts do
                local account = PlayerData.accounts[i]
                if account and account.name == 'money' and type(account.money) == 'number' then
                    cash = account.money
                    break
                end
            end
        end
    end

    if cash == nil and ESX ~= nil and ESX.GetPlayerData then
        local esxData = ESX.GetPlayerData()
        if type(esxData) == 'table' then
            if type(esxData.money) == 'number' then
                cash = esxData.money
            elseif type(esxData.accounts) == 'table' then
                for i = 1, #esxData.accounts do
                    local account = esxData.accounts[i]
                    if account and account.name == 'money' and type(account.money) == 'number' then
                        cash = account.money
                        break
                    end
                end
            end
        end
    end

    return math.floor(tonumber(cash) or 0)
end


local MIN_ENGINE_HEALTH_FOR_MENU_REPAIR = 350.0

local function hasBurstTyre(vehicle)
    for wheel = 0, 7 do
        if IsVehicleTyreBurst(vehicle, wheel, false) or IsVehicleTyreBurst(vehicle, wheel, true) then
            return true
        end
    end

    return false
end

local function repairExteriorOnMenuOpen(vehicle)
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        return
    end

    local engineHealth = GetVehicleEngineHealth(vehicle)
    if engineHealth <= MIN_ENGINE_HEALTH_FOR_MENU_REPAIR then
        return
    end

    if hasBurstTyre(vehicle) then
        return
    end

    SetVehicleDeformationFixed(vehicle)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
end


local function setCustomizationNuiFocus(enable, hasCursor, keepInput)
    local focus = enable == true
    local cursor = focus and (hasCursor == true) or false
    local keep = focus and (keepInput == true) or false

    SetNuiFocus(focus, cursor)
    SetNuiFocusKeepInput(keep)
end

local function initializeCustomizationCameras(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end

    local vehPos = GetEntityCoords(vehicle)
    local camPos = GetOffsetFromEntityInWorldCoords(vehicle, -2.0, 5.0, 3.0)
    local headingToObject = GetHeadingFromVector_2d(vehPos.x - camPos.x, vehPos.y - camPos.y)

    if customCamMain and DoesCamExist(customCamMain) then
        DestroyCam(customCamMain, true)
    end

    if customCamSec and DoesCamExist(customCamSec) then
        DestroyCam(customCamSec, true)
    end

    customCamMain = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camPos.x, camPos.y, camPos.z, -35.0, 0.0, headingToObject, GetGameplayCamFov(), false, 2)
    customCamSec = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camPos.x, camPos.y, camPos.z, -35.0, 0.0, headingToObject, GetGameplayCamFov(), false, 2)

    SetCamActive(customCamMain, true)
    RenderScriptCams(true, true, 500, true, true)
    renderingScriptCam = true
end

local function toggleCustomizationCameraRender()
    RenderScriptCams(not renderingScriptCam, true, 500, true, true)
    renderingScriptCam = not renderingScriptCam
end

local function destroyCustomizationCameras()
    RenderScriptCams(false, true, 500, true, true)
    renderingScriptCam = false

    if customCamMain and DoesCamExist(customCamMain) then
        DestroyCam(customCamMain, true)
    end

    if customCamSec and DoesCamExist(customCamSec) then
        DestroyCam(customCamSec, true)
    end

    customCamMain = nil
    customCamSec = nil
end

local customTextUiState = {
    isOpen = false,
    key = nil,
    text = nil
}

local function showCustomTextUI(keyText, text)
    local key = tostring(keyText or getActionLabel())
    local label = tostring(text or 'OPEN CUSTOMIZATION MENU')

    if customTextUiState.isOpen and customTextUiState.key == key and customTextUiState.text == label then
        return
    end

    exports[Config.ExportResources.textUI]:open({
        key = key,
        text = label
    })
    customTextUiState.isOpen = true
    customTextUiState.key = key
    customTextUiState.text = label
end

local function hideCustomTextUI()
    if not customTextUiState.isOpen then
        return
    end

    exports[Config.ExportResources.textUI]:close()
    customTextUiState.isOpen = false
    customTextUiState.key = nil
    customTextUiState.text = nil
end


local function normalizeUiLabelKey(value)
    if value == nil then return '' end
    local key = tostring(value)
    key = string.gsub(key, '^%s*(.-)%s*$', '%1')
    return key
end

local defaultUiOptionLabels = {
    ['Body'] = 'ตัวรถ',
    ['Upgrade'] = 'อัปเกรด',
    ['Engine'] = 'เครื่องยนต์',
    ['Brakes'] = 'เบรก',
    ['Transmission'] = 'เกียร์',
    ['Suspension'] = 'ช่วงล่าง',
    ['Armor'] = 'เกราะ',
    ['Turbo'] = 'เทอร์โบ',
}

local function getUiLabelConfig()
    local uiLabels = (Config and Config.UILabels) or {}
    if type(uiLabels) ~= 'table' then
        uiLabels = {}
    end
    return uiLabels
end

local function getMenuTitleForUi(menuId, menuTitle)
    local uiLabels = getUiLabelConfig()
    local titleKey = normalizeUiLabelKey(menuTitle)

    if type(uiLabels.MenuTitlesById) == 'table' and uiLabels.MenuTitlesById[menuId] ~= nil then
        return uiLabels.MenuTitlesById[menuId]
    end

    if type(uiLabels.MenuTitlesByName) == 'table' and uiLabels.MenuTitlesByName[titleKey] ~= nil then
        return uiLabels.MenuTitlesByName[titleKey]
    end

    if type(uiLabels.OptionLabels) == 'table' and uiLabels.OptionLabels[titleKey] ~= nil then
        return uiLabels.OptionLabels[titleKey]
    end

    return defaultUiOptionLabels[titleKey] or menuTitle
end

local function getOptionLabelForUi(menuId, optionLabel)
    local uiLabels = getUiLabelConfig()
    local optionKey = normalizeUiLabelKey(optionLabel)

    if type(uiLabels.OptionLabelsByMenu) == 'table' and type(uiLabels.OptionLabelsByMenu[menuId]) == 'table' and uiLabels.OptionLabelsByMenu[menuId][optionKey] ~= nil then
        return uiLabels.OptionLabelsByMenu[menuId][optionKey]
    end

    if type(uiLabels.OptionLabels) == 'table' and uiLabels.OptionLabels[optionKey] ~= nil then
        return uiLabels.OptionLabels[optionKey]
    end

    return defaultUiOptionLabels[optionKey] or optionLabel
end

local function getOptionSubLabelForUi(optionLabel, optionSubLabel)
    local uiLabels = getUiLabelConfig()

    if type(optionSubLabel) == 'string' and optionSubLabel ~= '' then
        return optionSubLabel
    end

    if type(uiLabels.OptionSubLabels) == 'table' and uiLabels.OptionSubLabels[optionLabel] ~= nil then
        return uiLabels.OptionSubLabels[optionLabel]
    end


    return optionSubLabel
end

local function applyUiLabels(menuId, menuTitle, options)
    local uiMenuTitle = getMenuTitleForUi(menuId, menuTitle)
    if type(options) ~= 'table' then
        return uiMenuTitle
    end

    for i = 1, #options do
        if options[i] then
            local optionLabel = options[i].label
            local optionSubLabel = options[i].labelTH

            options[i].uiLabel = getOptionLabelForUi(menuId, optionLabel)
            options[i].uiLabelTH = getOptionSubLabelForUi(optionLabel, optionSubLabel)
            options[i].uiMenuTitle = uiMenuTitle

            -- เผื่อกรณีฝั่ง UI ไม่อ่าน uiLabel/uiLabelTH ให้ทับค่าแสดงผลไปเลย
            options[i].label = options[i].uiLabel or optionLabel
            options[i].labelTH = options[i].uiLabelTH or optionSubLabel
        end
    end

    return uiMenuTitle
end


CreateThread(function()
    while true do
        if (not uiOpen) then
            nuiMouseEnabled = false
            setCustomizationNuiFocus(false, false, false)
            Wait(500)
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    for i = 1, #Config.Positions do
        local marker = Config.Positions[i].marker or {}
        for k, v in pairs(Config.DefaultMarker) do
            if marker[k] == nil then
                marker[k] = v
            end
        end
        Config.Positions[i].marker = marker
    end

    for i = 1, #Config.Positions do
        local tempPos = Config.Positions[i]
        if (((tempPos.blip == nil or tempPos.blip.enable == nil) and Config.DefaultBlip.enable == true) or (tempPos.blip and tempPos.blip.enable)) then
            addBlip(
                tempPos.pos,
                tempPos.blip and tempPos.blip.type or nil,
                tempPos.blip and tempPos.blip.color or nil,
                tempPos.blip and tempPos.blip.title or nil,
                tempPos.blip and tempPos.blip.scale or nil
            )
        end
    end

    local waitTime
    local playerPed, playerVeh

    while true do
        waitTime = getDistanceSleepFar()
        playerPed = PlayerPedId()
        playerVeh = GetVehiclePedIsIn(playerPed, false)

        local isDead = isPlayerDead(playerPed)

        if not uiOpen then
            local playerPos = GetEntityCoords(playerPed)
            local isInVehicle = (playerVeh ~= 0)
            local shouldKeepTextUi = false

            for i = 1, #Config.Positions do
                local tempPos = Config.Positions[i]
                if not tempPos.whitelistJobName or jobName == tempPos.whitelistJobName then
                    local actionDist = tempPos.actionDistance or Config.DefaultActionDistance
                    local actionDistSq = actionDist * actionDist
                    local distSq = getVectorDistanceSquared(playerPos, tempPos.pos)

                    local marker = tempPos.marker
                    if marker and marker.enable and distSq <= ((marker.drawDistance or 0.0) * (marker.drawDistance or 0.0)) then
                        waitTime = math.min(waitTime, getDistanceSleepMarkerVisible())
                        DrawMarker(
                            marker.type,
                            tempPos.pos.x + marker.positionOffset.x,
                            tempPos.pos.y + marker.positionOffset.y,
                            tempPos.pos.z + marker.positionOffset.z,
                            marker.direction.x, marker.direction.y, marker.direction.z,
                            marker.rotation.x, marker.rotation.y, marker.rotation.z,
                            marker.scale.x, marker.scale.y, marker.scale.z,
                            marker.color.r, marker.color.g, marker.color.b, marker.color.a,
                            (marker.bobUpAndDownAlways or (marker.bobUpAndDownOnAccess and distSq <= actionDistSq)),
                            marker.faceCamera,
                            2,
                            marker.rotating,
                            nil, nil, false
                        )
                    end

                    if distSq <= actionDistSq and isInVehicle then
                        waitTime = getDistanceSleepInteract()

                        local isDriver = (GetPedInVehicleSeat(playerVeh, -1) == playerPed)

                        if isDriver then
                            showCustomTextUI(getActionLabel(), 'เพื่อเปิดเปิดเมนูแต่งรถ')
                            shouldKeepTextUi = true
                        end

                        if isInteractPressed() then
                            if isDead then
                                exports[Config.ExportResources.notify]:SendAlert('error', 'ไม่สามารถแต่งรถในสถานะนี้ !', 3000)
                            elseif not isDriver then
                                exports[Config.ExportResources.notify]:SendAlert('error', 'ต้องนั่งตำแหน่งคนขับและอยู่ในรถ !', 3000)
                            else
                                customConfigPosIndex = i
                                openUI()
                            end
                        end

                        break
                    end
                end
            end

            if not shouldKeepTextUi then
                hideCustomTextUI()
            end
        else
            hideCustomTextUI()
            if customConfigPosIndex then
                local tempPos = Config.Positions[customConfigPosIndex]
                updateCash()

                if playerVeh == 0 or playerVeh ~= customVehicle or isDead then
                    closeUI(1, 1)
                else
                    local currentPos = GetEntityCoords(customVehicle)
                    local actionDist = tempPos.actionDistance or Config.DefaultActionDistance
                    if getVectorDistanceSquared(currentPos, tempPos.pos) > (actionDist * actionDist) then
                        closeUI(1, 1)
                    end
                end
            end
        end

        Wait(waitTime)
    end
end)


function updateCash(forceUpdate)
    local whitelistJobName = nil
    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex]) then
        whitelistJobName = Config.Positions[customConfigPosIndex].whitelistJobName
    end

    local cash = getPlayerCash()
    if (not forceUpdate and lastUiCash == cash) then
        return
    end

    lastUiCash = cash

    SendNUIMessage({
        type = 'update',
        what = 'cash',
        cash = cash,
        whitelistJobName = whitelistJobName
    })
end

function GetVehicleClassName(vehicle)
    if not DoesEntityExist(vehicle) then
        return "Unknown"
    end

    local classId = GetVehicleClass(vehicle)
    local classNames = {
        [0] = "Compacts",
        [1] = "Sedans",
        [2] = "SUVs",
        [3] = "Coupes",
        [4] = "Muscle",
        [5] = "Sports Classics",
        [6] = "Sports",
        [7] = "Supercar",
        [8] = "Motorcycles",
        [9] = "Off-road",
        [10] = "Industrial",
        [11] = "Utility",
        [12] = "Vans",
        [13] = "Cycles",
        [14] = "Boats",
        [15] = "Helicopters",
        [16] = "Planes",
        [17] = "Service",
        [18] = "Emergency",
        [19] = "Military",
        [20] = "Commercial",
        [21] = "Trains"
    }

    return classNames[classId] or "Unknown"
end

function updateVehicleCard(vehicle)
    local vehicleModel = GetEntityModel(vehicle)

    local vehDisplayName = GetDisplayNameFromVehicleModel(vehicleModel)
    local vehicleLabelText = GetLabelText(vehDisplayName)
    local vehicleName = vehicleLabelText == 'NULL' and vehDisplayName or vehicleLabelText

    local acceleration = (GetVehicleModelAcceleration(vehicleModel) or 0.0) * 10
    local maxSpeed = (GetVehicleModelEstimatedMaxSpeed(vehicleModel) or 0.0) / 10
    local breaks = GetVehicleModelMaxBraking(vehicleModel) or 0.0
    local power = (acceleration + maxSpeed) / 2
    local NameClass = GetVehicleClassName(vehicle)

    SendNUIMessage({
        type = 'update',
        what = 'card',
        vehicleName = vehicleName,
        power = power,
        acceleration = acceleration,
        maxSpeed = maxSpeed,
        breaks = breaks,
        class = NameClass
    })
end

function openUI()
    if (uiOpen) then return end

    local playerPed = cache.ped
    local playerVeh = GetVehiclePedIsIn(playerPed, false)

    if (playerVeh ~= 0 and DoesEntityExist(playerVeh)) then
        customVehicle = playerVeh
        customVehicleData = GetVehicleData(customVehicle)
        FreezeEntityPosition(customVehicle, true)

        SetVehicleOnGroundProperly(playerVeh)
        repairExteriorOnMenuOpen(playerVeh)

        DisplayHud(false)
        radarWasVisible = not IsRadarHidden()
        DisplayRadar(false)
        nuiMouseEnabled = false
        uiOpen = true
        setCustomizationNuiFocus(true, false, true)

        pcall(function()
            exports[Config.ExportResources.carHUD]:ToggleDisplay(false)
            exports[Config.ExportResources.playerHUD]:toggleHUD(false)
        end)

        customVehiclePrice = Config.VehicleDefaultPrice
        local tempVehicleModel = GetEntityModel(customVehicle)
        for model, data in pairs(Config.VehicleOverridePrice) do
            if (tempVehicleModel == GetHashKey(model)) then
                customVehiclePrice = data.price
                break
            end
        end

        updateCash(true)
        updateVehicleCard(customVehicle)

        resetRuntimeMenus()

        local menu = clearMenu(getMenuDefinition('main'))
        local newOptions = optionsShouldShow(menu)
        local uiMenuTitle = applyUiLabels('main', menu.title, newOptions)
        local whitelistJobName = nil
        if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex]) then
            whitelistJobName = Config.Positions[customConfigPosIndex].whitelistJobName
        end

        SendNUIMessage({
            type = 'open',
            isOpenByAdmin = isOpenByAdmin,
            what = 'menu',
            menuId = 'main',
            options = newOptions,
            menuTitle = uiMenuTitle,
            defaultOption = menu.defaultOption,
            whitelistJobName = whitelistJobName
        })

        initializeCustomizationCameras(customVehicle)

        CreateThread(function()
            while (uiOpen) do
                DisableAllControlActions(0)

                EnableControlAction(0, 1, true)   -- mouse mv
                EnableControlAction(0, 2, true)   -- mouse mv
                EnableControlAction(0, 74, true)  -- headlights
                EnableControlAction(0, 86, true)  -- horn
                EnableControlAction(0, 249, true) -- voice

                if (IsDisabledControlJustReleased(0, 26)) then
                    toggleCustomizationCameraRender()
                end

                Wait(0)
            end
        end)
    end
end

-- exports("openUI", openUI)

function closeUI(sendToUI, resetVehToDefault)
    sendToUI = sendToUI or 0
    resetVehToDefault = resetVehToDefault or 0
    resetRuntimeMenus()

    DisplayHud(true)
    if radarWasVisible then
        DisplayRadar(true)
    end
    nuiMouseEnabled = false
    uiOpen = false
    setCustomizationNuiFocus(false, false, false)

    pcall(function()
        exports[Config.ExportResources.carHUD]:ToggleDisplay(true)
        exports[Config.ExportResources.playerHUD]:toggleHUD(true)
    end)

    if (sendToUI == 1) then
        SendNUIMessage({
            type = 'close'
        })
    end

    destroyCustomizationCameras()
    ClearFocus()

    if (resetVehToDefault == 1) then
        SetVehicleData(customVehicle, customVehicleData)
    end

    openDoors(customVehicle, { 0, 0, 0, 0, 0, 0, 0 })

    customVehiclePrice = nil
    lastUiCash = nil

    FreezeEntityPosition(customVehicle, false)
    customVehicle = nil
    customVehicleData = nil
    customConfigPosIndex = nil

    if (isOpenByAdmin) then
        isOpenByAdmin = false
    end

end

function updateMenu(menuId)
    local menuConfig = getMenuDefinition(menuId)
    if (menuId == nil or menuConfig == nil) then return end

    local menu = clearMenu(menuConfig)

    local newOptions = optionsShouldShow(menu)
    local uiMenuTitle = applyUiLabels(menuId, menu.title, newOptions)

    local whitelistJobName = nil
    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex]) then
        whitelistJobName = Config.Positions[customConfigPosIndex].whitelistJobName
    end

    SendNUIMessage({
        type = 'update',
        what = 'menu',
        menuId = menuId,
        options = newOptions,
        menuTitle = uiMenuTitle,
        defaultOption = menu.defaultOption,
        whitelistJobName = whitelistJobName
    })
end

RegisterNUICallback('uiReady', function(data)
    updateUICurrentJob()
end)

local function getGarageVehicleProperties(vehicle)
    if not vehicle or vehicle == 0 then return nil end

    local ok, props = pcall(function()
        return exports[Config.ExportResources.garage]:GetVehicleProperties(vehicle)
    end)

    if ok and type(props) == 'table' then
        return props
    end

    if ESX and ESX.Game and ESX.Game.GetVehicleProperties then
        return ESX.Game.GetVehicleProperties(vehicle)
    end

    return nil
end

RegisterNUICallback('handle', function(data)
    if (data.type == 'close') then
        closeUI(0, 1)
    elseif (data.type == 'update') then
        if (data.what == 'menu') then
            if (data.user == 'hover') then
                if (not data or not data.menuId or not data.menuIndex) then return end

                local menu = getMenuDefinition(data.menuId)
                if (not menu) then return end

                playSound('Faster_Click', 'RESPAWN_ONLINE_SOUNDSET')
                local newOptions = optionsShouldShow(menu)

                if (data.color ~= nil) then
                    local tempModType = string.sub(data.menuId, #'mod_' + 1)
                    SetVehicleModData(customVehicle, tempModType, data.color)
                    return
                end

                local menuOption = newOptions[data.menuIndex + 1]
                if (menuOption.onHover ~= nil) then
                    menuOption.onHover()
                end

            elseif (data.user == 'toggleMouse') then
                if (not uiOpen) then
                    setCustomizationNuiFocus(false, false, false)
                    return
                end

                nuiMouseEnabled = data.enableMouse == true
                setCustomizationNuiFocus(true, nuiMouseEnabled, true)
                return
            elseif (data.user == 'enter') then
                if (not data.menuId or not data.menuIndex) then return end

                local menu = getMenuDefinition(data.menuId)
                if (not menu) then return end

                local newOptions = optionsShouldShow(menu)
                local menuOption = newOptions[data.menuIndex + 1]

                local vehicleModelCheck = GetEntityModel(customVehicle)
                local blockCustom = Config.BlockCustomCategories[vehicleModelCheck]
                if blockCustom and blockCustom[menuOption and menuOption.label or nil] then
                    updateMenu('main')
                    exports[Config.ExportResources.notify]:SendAlert('error', 'รถคันนี้ไม่สามารถแต่งส่วนนี้ได้ !', 3000)
                    return
                end

                local canBuyMod = true
                local tempPrice = 0
                local vehiclePropBefore = getGarageVehicleProperties(customVehicle)
                if not vehiclePropBefore then return end

                if ((not isOpenByAdmin) and menuOption and menuOption.price) then
                    if (menuOption.price == -1) then
                        canBuyMod = false
                    elseif (menuOption.price > 0) then
                        canBuyMod = false
                        menuOption.priceMult = menuOption.priceMult or 1
                        tempPrice = menuOption.price or math.floor(customVehiclePrice * menuOption.priceMult / 500)

                        if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex] and jobName ~= Config.Positions[customConfigPosIndex].whitelistJobName) then
                            tempPrice = math.floor(tempPrice * Config.PriceMultiplierWithoutTheJob)
                        end

                        if (getPlayerCash() >= tempPrice) then
                            canBuyMod = true

                            -- ตัดเงิน
                            TriggerServerEvent(('%s:%s'):format(Config.ScriptName, 'removeCash'), tempPrice)

                            -- Log Discord
                            local vehicleModel = GetEntityModel(customVehicle)
                            local vehDisplayName = GetDisplayNameFromVehicleModel(vehicleModel)
                            local modName = string.gsub(menuOption.img, "img/icons/(.-)%.png", "%1")
                            local sendToDiscord = 'ได้แต่งชิ้นส่วน: ' .. string.upper(modName) .. '\n' ..
                                'ระดับของแต่ง/ชื่อรุ่นของแต่ง: ' .. string.upper(menuOption.label) .. '\n' ..
                                'ยานพาหนะ: ' .. GetLabelText(vehDisplayName) .. '\n' ..
                                'ป้ายทะเบียน: ' .. GetVehicleNumberPlateText(customVehicle) .. '\n' ..
                                'เสียค่าใช้จ่าย: $' .. ESX.Math.GroupDigits(tempPrice)

                            pcall(function()
                                exports[Config.ExportResources.serverLogs]:insertData({
                                    event = 'customCar',
                                    content = sendToDiscord,
                                    color = 2
                                })
                            end)

                            -- ส่ง property หลังจ่ายเงิน
                            local vehiclePropAfter = getGarageVehicleProperties(customVehicle)
                            if vehiclePropAfter then
                                TriggerServerEvent(('%s:%s'):format(Config.ScriptName, 'updateProperties'), vehiclePropAfter)
                            end
                        end
                    end
                elseif isOpenByAdmin then
                    -- admin กดแต่ง -> อนุญาตส่ง property ได้เลย
                    local vehiclePropAfter = getGarageVehicleProperties(customVehicle)
                    if vehiclePropAfter then
                        TriggerServerEvent(('%s:%s'):format(Config.ScriptName, 'updateProperties'), vehiclePropAfter)
                    end
                end

                if (canBuyMod == false) then
                    playSound('ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET')
                    return
                end

                playSound('Click_Special', 'WEB_NAVIGATION_SOUNDS_PHONE')

                if (data.color ~= nil) then
                    local tempModType = string.sub(data.menuId, #'mod_' + 1)
                    local colorPrice = data.price or math.floor(customVehiclePrice * (data.priceMult or 1) / 500)

                    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex] and jobName ~= Config.Positions[customConfigPosIndex].whitelistJobName) then
                        colorPrice = math.floor(colorPrice * Config.PriceMultiplierWithoutTheJob)
                    end

                    if not isOpenByAdmin and (getPlayerCash() < colorPrice) then
                        playSound('ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET')
                        return
                    end

                    if not isOpenByAdmin and colorPrice > 0 then
                        TriggerServerEvent(('%s:%s'):format(Config.ScriptName, 'removeCash'), colorPrice)

                        local vehicleModel = GetEntityModel(customVehicle)
                        local vehDisplayName = GetDisplayNameFromVehicleModel(vehicleModel)
                        local sendToDiscord =
                            'ได้แต่งสี: ' .. string.upper(tempModType) .. '\n' ..
                            'ยานพาหนะ: ' .. GetLabelText(vehDisplayName) .. '\n' ..
                            'ป้ายทะเบียน: ' .. GetVehicleNumberPlateText(customVehicle) .. '\n' ..
                            'เสียค่าใช้จ่าย: $' .. ESX.Math.GroupDigits(colorPrice)

                        pcall(function()
                            exports[Config.ExportResources.serverLogs]:insertData({
                                event = 'customCar',
                                content = sendToDiscord,
                                color = 2
                            })
                        end)

                        local vehiclePropAfter = getGarageVehicleProperties(customVehicle)
                        if vehiclePropAfter then
                            TriggerServerEvent(('%s:%s'):format(Config.ScriptName, 'updateProperties'), vehiclePropAfter)
                        end
                    end

                    -- ✅ อยู่นอก block ข้างบน!
                    if isOpenByAdmin then
                        local vehiclePropAfter = getGarageVehicleProperties(customVehicle)
                        if vehiclePropAfter then
                            TriggerServerEvent(('%s:%s'):format(Config.ScriptName, 'updateProperties'), vehiclePropAfter)
                        end
                    end

                    customVehicleData = GetVehicleData(customVehicle)
                    playCustomSound('spray')
                    openColorPicker(data.colorTitle, tempModType, data.isCustom, data.priceMult)
                    return
                end

                if (not menuOption) then return end

                if (menuOption.onSelect ~= nil) then
                    menuOption.onSelect()
                end

                if (menuOption.openSubMenu ~= nil) then
                    updateMenu(menuOption.openSubMenu)
                end

                if (menuOption.modType ~= nil) then
                    createMenu(data.menuId, menuOption)
                    updateMenu('mod_' .. menuOption.modType)
                end
            elseif (data.user == 'backspace') then
                if (not data.menuId) then return end

                local menu = getMenuDefinition(data.menuId)
                if (not menu) then return end

                playSound('Lose_1st', 'GTAO_FM_Events_Soundset')

                local newOptions = optionsShouldShow(menu)

                if (data.menuIndex) then
                    local menuOption = newOptions[data.menuIndex + 1]
                    if (menuOption and menuOption.onBack) then
                        menuOption.onBack()
                    end
                end

                if (menu.onBack ~= nil) then
                    menu.onBack()
                end

                SetVehicleData(customVehicle, customVehicleData)
                openDoors(customVehicle, { 0, 0, 0, 0, 0, 0, 0 })
            end
        end
    end
end)

function optionsShouldShow(menu)
    local newOptions = {}

    for i = 1, #menu.options, 1 do
        local shouldShow = true

        if (menu.options[i].modType ~= nil) then
            if (GetNumVehicleModData(customVehicle, menu.options[i].modType) < 0) then
                shouldShow = false
            end
        end

        if (menu.options[i].modType == 'extras') then
            if (menu.options[i].price ~= nil) then
                menu.options[i].priceForSub = menu.options[i].price
                menu.options[i].price = nil
            end
        end

        if (shouldShow and menu.options[i].openSubMenu ~= nil) then
            local subMenu = getMenuDefinition(menu.options[i].openSubMenu)
            local tempShouldShow = false

            if type(subMenu) == 'table' and type(subMenu.options) == 'table' then
                for j = 1, #subMenu.options, 1 do
                    if (subMenu.options[j].modType ~= nil) then
                        if (GetNumVehicleModData(customVehicle, subMenu.options[j].modType) >= 0 or subMenu.options[j].openSubMenu ~= nil) then
                            tempShouldShow = true
                            break
                        end
                    end
                end
            end

            shouldShow = tempShouldShow
        end

        if (not isOpenByAdmin) then
            if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex] and (Config.IsUpgradesOnlyForWhitelistJobPoints == true and jobName ~= Config.Positions[customConfigPosIndex].whitelistJobName)) then
                if (menu.options[i].openSubMenu == 'upgrade') then
                    shouldShow = false
                end
            end
        end

        if (shouldShow == true) then
            table.insert(newOptions, menu.options[i])
        end
    end

    return newOptions
end

function createMenu(menuId, menuOption)
    local newMenuId = 'mod_' .. menuOption.modType

    local curOption = GetVehicleCurrentMod(customVehicle, menuOption.modType)
    local curOptionOptionIndex = curOption + 1
    if (menuOption.modType == 'windowTint') then
        curOptionOptionIndex = curOption
    end

    runtimeMenus[newMenuId] = {
        title = menuOption.label,
        options = {},
        onBack = function()
            updateMenu(menuId)

            if (menuOption.onSubBack ~= nil) then
                menuOption.onSubBack()
            end
        end,
        defaultOption = curOptionOptionIndex
    }

    if (menuOption.customType == 'color' or menuOption.customType == 'customColor') then
        runtimeMenus[newMenuId].title = ''
        return
    end

    local startIndex = -1
    if (menuOption.modType == 'windowTint' or menuOption.modType == 'extras') then
        startIndex = 0
    end

    for i = startIndex, GetNumVehicleModData(customVehicle, menuOption.modType), 1 do
        local tempLabel = GetVehicleModIndexLabel(customVehicle, menuOption.modType, i)
        if (not tempLabel or tempLabel == 'NULL') then
            tempLabel = tostring(i) + 1
        end

        menuOption.priceMult = menuOption.priceMult or 1.0

        local tempPrice = 0
        if (curOption == i) then
            tempPrice = -1
        else
            if (type(menuOption.priceMult) == 'number') then
                tempPrice = menuOption.price or menuOption.priceForSub or math.floor(customVehiclePrice * menuOption.priceMult / 500)
            else
                tempPrice = menuOption.price or math.floor(customVehiclePrice * menuOption.priceMult[i + 2] / 500)
            end
        end

        table.insert(runtimeMenus[newMenuId].options, {
            label = tempLabel,
            uiMenuTitle = getMenuTitleForUi(newMenuId, menuOption.label),
            img = menuOption.img,
            price = tempPrice,
            priceMult = menuOption.priceMult,
            onHover = function()
                SetVehicleModData(customVehicle, menuOption.modType, i)
            end,
            onSelect = function()
                customVehicleData = GetVehicleData(customVehicle)
                createMenu(menuId, menuOption)
                updateMenu(newMenuId)

                playCustomSound('construction')
            end
        })

        if (menuOption.modType == 11 or menuOption.modType == 18) then
            local tempOption = runtimeMenus[newMenuId].options[#runtimeMenus[newMenuId].options]
            tempOption.onHover = function()
                SetVehicleModData(customVehicle, menuOption.modType, i)
                TaskVehicleTempAction(cache.ped, customVehicle, 31, 2000)
            end
        elseif (menuOption.modType == 'extras') then
            local tempOption = runtimeMenus[newMenuId].options[#runtimeMenus[newMenuId].options]

            local isTempExtraOn = GetVehicleCurrentMod(customVehicle, 'extras', (i + 1))

            tempOption.price = nil
            tempOption.onHover = nil

            tempOption.onSelect = function()
                isTempExtraOn = GetVehicleCurrentMod(customVehicle, 'extras', (i + 1))

                runtimeMenus['extras_on_off'] = {
                    title = 'EXTRA ' .. tostring(i + 1),
                    options = {
                        {
                            label = 'OFF',
                            uiLabel = getOptionLabelForUi('extras_on_off', 'OFF'),
                            img = 'minus',
                            price = tempPrice,
                            onHover = function()
                                SetVehicleModData(customVehicle, menuOption.modType, { id = (i + 1), enable = 1 })
                            end,
                            onSelect = function()
                                customVehicleData = GetVehicleData(customVehicle)

                                runtimeMenus['extras_on_off'].options[1].price = -1
                                runtimeMenus['extras_on_off'].options[2].price = tempPrice

                                updateMenu('extras_on_off')

                                playCustomSound('construction')
                            end
                        },
                        {
                            label = 'ON',
                            uiLabel = getOptionLabelForUi('extras_on_off', 'ON'),
                            img = 'plus',
                            price = tempPrice,
                            onHover = function()
                                SetVehicleModData(customVehicle, menuOption.modType, { id = (i + 1), enable = 0 })
                            end,
                            onSelect = function()
                                customVehicleData = GetVehicleData(customVehicle)

                                runtimeMenus['extras_on_off'].options[1].price = tempPrice
                                runtimeMenus['extras_on_off'].options[2].price = -1

                                updateMenu('extras_on_off')

                                playCustomSound('construction')
                            end
                        },
                    },
                    onBack = function() updateMenu(newMenuId) end,
                    defaultOption = 0
                }

                if (isTempExtraOn == 0) then
                    runtimeMenus['extras_on_off'].options[2].price = -1
                    runtimeMenus['extras_on_off'].defaultOption = 1
                else
                    runtimeMenus['extras_on_off'].options[1].price = -1
                end

                updateMenu('extras_on_off')
            end
        end
    end
end

function openColorPicker(title, modType, isCustom, priceMult)
    priceMult = priceMult or 1

    local defaultValue

    if (isCustom) then
        local r, g, b = GetVehicleCurrentMod(customVehicle, modType)
        defaultValue = { r, g, b }
    else
        defaultValue = GetVehicleCurrentMod(customVehicle, modType)
    end

    local whitelistJobName = nil
    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex]) then
        whitelistJobName = Config.Positions[customConfigPosIndex].whitelistJobName
    end

    SendNUIMessage({
        type = 'open',
        what = 'colorPicker',
        isOpenByAdmin = isOpenByAdmin,
        IsUpgradesOnlyForWhitelistJobPoints = Config.IsUpgradesOnlyForWhitelistJobPoints,
        priceMultiplierWithoutTheJob = Config.PriceMultiplierWithoutTheJob,
        detailCardMenuPosition = Config.detailCardMenuPosition,
        cashPosition = Config.cashPosition,
        isCustom = isCustom,
        defaultValue = defaultValue,
        title = title,
        priceMult = priceMult,
        price = math.floor(customVehiclePrice * priceMult / 500),
        whitelistJobName = whitelistJobName
    })
end

function updateUICurrentJob()
    SendNUIMessage({
        type = 'update',
        what = 'job',
        jobName = jobName
    })
end


exports('openMenuByAdmin', function()
    isOpenByAdmin = true
    openUI()
end)

AddEventHandler('onResourceStop', function(resource)
    if (GetCurrentServerEndpoint() == nil) then
        return
    end

    if (resource == GetCurrentResourceName()) then
        if (uiOpen) then
            DisplayHud(true)
            uiOpen = false
            setCustomizationNuiFocus(false, false, false)

            destroyCustomizationCameras()
            ClearFocus()

            SetVehicleData(customVehicle, customVehicleData)
            FreezeEntityPosition(customVehicle, false)
        end
    end
end)
