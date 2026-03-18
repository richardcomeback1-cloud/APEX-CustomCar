Config = Config or {}

Config.BlockCustomCategories = {
    -- [`elegypolice`] = {
    --     ['Respray'] = true,
    -- },
    -- [`komodapolice`] = {
    --     ['Respray'] = true,
    -- },
    -- [`furiapolice`] = {
    --     ['Respray'] = true,
    -- },
    -- [`coquette4police`] = {
    --     ['Respray'] = true,
    -- },
    -- [`thraxpolice`] = {
    --     ['Respray'] = true,
    -- },

    -- [`neonmedic`] = {
    --     ['Respray'] = true,
    -- },
    -- [`furiamedic`] = {
    --     ['Respray'] = true,
    -- },
    -- [`coquette4medic`] = {
    --     ['Respray'] = true,
    -- },
    -- [`thraxmedic`] = {
    --     ['Respray'] = true,
    -- },
}

-- The vehicle price will be the first option and will change the upgrades price
Config.VehicleOverridePrice = {

    --------- EX ---------
    --['ค่าเสกรถ'] = {
    --    name = 'ชื่อรถ',
    --    price = 'ราคาตัวรถ'
    --},
    --------- EX ---------

    -- รถ MOD

    ['adm_porcaygt2'] = { -- Porsche Cayenne Turbo GT2
        name = 'Porsche Cayenne Turbo GT',
        price = '1000000'
    },
    
    -- รถเช่ามีวันหมดอายุ

    -- รถผู้เล่นใหม่

    -- รถกาชา

    ------------------ รถร้านค้า ------------------

    -- จักรยาน

    -- มอเตอร์ไซต์

    -- รถโล

    -- รถสปอร์ต

    -- รถตำรวจ

    -- รถหมอ

}

-- If a is not included in "Config.VehicleOverridePrice" and the class of the vehicle is not included in the "Config.VehicleClassPrice" the price will be as the "Config.VehicleDefaultPrice"
Config.VehicleDefaultPrice = 200000

-- This multiplier will add to the parts multiplier for the position that is not for whitelist job
Config.PriceMultiplierWithoutTheJob = 1.0

-- The price of the repair for the points with whitelist job (for the open points the "Config.PriceMultiplierWithoutTheJob" multiplier will apply)
Config.VehicleRepairPrice = 2500

-- The multiplier of parts for the points with whitelist job (for the open points the "Config.PriceMultiplierWithoutTheJob" multiplier will add to that)
Config.VehicleCustomisePriceMultiplier = {
    ['engine'] = { 0, 5.0, 7.5, 10.0, 12.5, 15.0 },
    ['brakes'] = { 0, 2.5, 5, 7.5, 10 },
    ['transmission'] = { 0, 2.5, 5, 7.5, 10, 12.5 },
    ['suspension'] = { 0, 1.5, 2.0, 2.5, 3, 3.5, 4 },
    ['armor'] = { 0, 1.5, 2.5, 3.5, 4.5, 5, 6.5, 7.5 },
    ['turbo'] = { 0, 7.5 },

    ['extras'] = 0.05,
    ['windowTint'] = 0.05,

    ['horn'] = 0.05,
    ['speakers'] = 0.05,
    ['trunk'] = 0.05,
    ['hydrulics'] = 0.05,
    ['engine_block'] = 0.05,
    ['air_filter'] = 0.05,
    ['struts'] = 0.05,
    ['tank'] = 0.05,

    ['spoilers'] = 0.05,
    ['front_bumper'] = 0.05,
    ['rear_bumper'] = 0.05,
    ['side_skirts'] = 0.05,
    ['exhaust'] = 0.05,
    ['cage'] = 0.05,

    ['grille'] = 0.05,
    ['hood'] = 0.05,
    ['left_fender'] = 0.05,
    ['right_fender'] = 0.05,
    ['roof'] = 0.05,
    ['arch_cover'] = 0.05,
    ['aerials'] = 0.05,
    ['wings'] = 0.05,
    ['windows'] = 0.05,

    ['dashboard'] = 0.05,
    ['dashboard_color'] = 0.05,

    ['dial'] = 0.05,
    ['door_speaker'] = 0.05,
    ['seat'] = 0.05,
    ['steering_wheel'] = 0.05,
    ['shifter_leaver'] = 0.05,
    ['ornaments'] = 0.05,

    ['interior'] = 0.05,
    ['interior_color'] = 0.05,

    ['primary_paint'] = 0.05,
    ['secondary_paint'] = 0.05,
    ['primary_paint_type'] = 0.05,
    ['secondary_paint_type'] = 0.05,
    ['pearlescent'] = 0.05,

    ['wheels_color'] = 0.05,
    ['smoke_color'] = 0.05,

    ['sport'] = 0.05,
    ['muscle'] = 0.05,
    ['lowrider'] = 0.05,
    ['suv'] = 0.05,
    ['offroad'] = 0.05,
    ['tuner'] = 0.05,
    ['bike_wheels'] = 0.05,
    ['high_end'] = 0.05,

    ['plate_type'] = 0.05,
    ['plate_color'] = 0.05,
    ['plate_holder'] = 0.05,

    ['xenon'] = 0.05,
    ['neon'] = 0.05,

    ['stickers'] = 0.05,
    ['livery'] = 0.05
}
