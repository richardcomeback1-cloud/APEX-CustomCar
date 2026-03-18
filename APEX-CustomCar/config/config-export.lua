Config = Config or {}

Config.ScriptName = 'APEX-CustomCar'

Config.ExportResources = {
    esExtended = 'es_extended',
    garage = 'val-garage',
    textUI = 'val-textui',
    notify = 'mythic_notify',
    carHUD = 'lizz_carhud',
    playerHUD = 'lizz_playerhud',
    serverLogs = 'azael_dc-serverlogs'
}

Config.Performance = {
    distanceSleepFar = 1000,
    distanceSleepNear = 250,
    distanceSleepMarkerVisible = 0,
    distanceSleepInteract = 0
}

Config.Validation = {
    maxChargeAmount = 5000000,
    maxPropsPayloadBytes = 65535,
    removeCashCooldownMs = 150,
    updatePropsCooldownMs = 250,
    getPropsCooldownMs = 200
}
