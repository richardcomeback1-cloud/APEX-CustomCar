ESX = nil
PlayerData = {}

jobName = nil

CreateThread(function()
    while (ESX == nil) do
        ESX = exports[Config.ExportResources.esExtended]:getSharedObject()
        Wait(100)
    end

    while (ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil) do
        Wait(100)
    end

    PlayerData = ESX.PlayerData

    jobName = getJobName()
    updateUICurrentJob()
    if updateCash then
        updateCash(true)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    jobName = getJobName()
    updateUICurrentJob()
    if updateCash then
        updateCash(true)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job

    jobName = getJobName()
    updateUICurrentJob()
end)

function getJobName()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name ~= nil) then
        return PlayerData.job.name
    end
    return nil
end

RegisterNetEvent('esx:setMoney')
AddEventHandler('esx:setMoney', function(money)
    if PlayerData == nil then
        PlayerData = {}
    end

    PlayerData.money = tonumber(money) or 0

    if ESX and ESX.PlayerData then
        ESX.PlayerData.money = PlayerData.money
    end

    if updateCash then
        updateCash(true)
    end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    if type(account) ~= 'table' or not account.name then
        return
    end

    if PlayerData == nil then
        PlayerData = {}
    end

    local accountMoney = tonumber(account.money) or 0

    if account.name == 'money' then
        PlayerData.money = accountMoney

        if ESX and ESX.PlayerData then
            ESX.PlayerData.money = accountMoney
        end
    end

    if type(PlayerData.accounts) ~= 'table' then
        PlayerData.accounts = {}
    end

    local found = false
    for i = 1, #PlayerData.accounts do
        local entry = PlayerData.accounts[i]
        if entry and entry.name == account.name then
            PlayerData.accounts[i].money = accountMoney
            found = true
            break
        end
    end

    if not found then
        PlayerData.accounts[#PlayerData.accounts + 1] = {
            name = account.name,
            money = accountMoney
        }
    end

    if updateCash then
        updateCash(true)
    end
end)
