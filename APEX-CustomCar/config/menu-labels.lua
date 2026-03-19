Config = Config or {}

-- UI Label Overrides (แสดงผลเฉพาะหน้า UI เท่านั้น ไม่กระทบ logic ระบบ)
-- ใช้ไฟล์นี้สำหรับเปลี่ยนชื่อเมนู/ชื่อหัวข้อ/ชื่อ option
Config.UILabels = Config.UILabels or {}

Config.UILabels.MenuTitlesById = {
    main = 'แต่งรถ',
    upgrade = 'อัปเกรด',
    visual = 'ของแต่ง',
    body_parts = 'ชุดแต่ง',
    inside_parts = 'ภายใน',
    respray = 'สีตัวรถ',
    wheels = 'ล้อรถ',
    wheel_type = 'รูปแบบล้อรถ',
    plate = 'ป้ายทะเบียน',
    lights = 'ไฟรถ',
    stickers = 'ลาย',
}

-- เมนูย่อยที่สร้างแบบ dynamic (เช่น mod_11) จะใช้ชื่อ title จาก label เดิม
-- สามารถ map ชื่อตามข้อความหัวข้อได้ที่นี่ เพื่อให้บรรทัดล่างใน UI เปลี่ยนตาม
Config.UILabels.MenuTitlesByName = {
    ['Engine'] = 'เครื่องยนต์',
    ['Brakes'] = 'เบรก',
    ['Transmission'] = 'เกียร์',
    ['Suspension'] = 'ช่วงล่าง',
    ['Armor'] = 'เกราะ',
    ['Turbo'] = 'เทอร์โบ',
}

Config.UILabels.OptionLabels = {
    ['Body'] = 'ของตกแต่ง',
    ['Upgrade'] = 'อัปเกรดสมรรถนะ',
    ['Engine'] = 'เครื่องยนต์',
    ['Brakes'] = 'ระบบเบรก',
    ['Transmission'] = 'ระบบเกียร์',
    ['Suspension'] = 'ช่วงล่าง',
    ['Armor'] = 'เกราะรถ',
    ['Turbo'] = 'เทอร์โบ',
    ['Body Part'] = 'ชิ้นส่วนตัวถัง',
    ['Inside Part'] = 'ชิ้นส่วนภายใน',
    ['Respray'] = 'ทำสีรถ',
    ['Wheel'] = 'ล้อรถ',
    ['Plate'] = 'ป้ายทะเบียน',
    ['Lights'] = 'ไฟรถ',
    ['Sticker'] = 'สติ๊กเกอร์',
    ['Extra'] = 'อุปกรณ์เสริม',
    ['Window Tint'] = 'ฟิล์มกระจก',
    ['Horn'] = 'แตร',
    ['Speakers'] = 'ลำโพง',
    ['Trunk'] = 'ท้ายรถ',
    ['Hydrulics'] = 'ไฮดรอลิก',
    ['Engine Block'] = 'ฝาครอบเครื่อง',
    ['Air Filter'] = 'กรองอากาศ',
    ['Struts'] = 'ค้ำโช้ค',
    ['Tank'] = 'ถังน้ำมัน',
    ['Spoilers'] = 'สปอยเลอร์',
    ['FrontBumper'] = 'กันชนหน้า',
    ['Rear Bumper'] = 'กันชนหลัง',
    ['Side Skirts'] = 'สเกิร์ตข้าง',
    ['Exhaust'] = 'ท่อไอเสีย',
    ['RollCage'] = 'โรลเคจ',
    ['Grille'] = 'กระจังหน้า',
    ['Hood'] = 'ฝากระโปรง',
    ['Left Fender'] = 'แก้มซ้าย',
    ['Right Fender'] = 'แก้มขวา',
    ['Roof'] = 'หลังคา',
    ['Arch Cover'] = 'ครอบซุ้มล้อ',
    ['Aerials'] = 'เสาอากาศ',
    ['Trim'] = 'คิ้วตกแต่ง',
    ['Dashboard'] = 'แผงหน้าปัด',
    ['Dashboard Color'] = 'สีแผงหน้าปัด',
    ['Dial'] = 'หน้าปัด',
    ['Door Speaker'] = 'ลำโพงประตู',
    ['Seats'] = 'เบาะรถ',
    ['Steering Wheel'] = 'พวงมาลัย',
    ['Shifter Leaver'] = 'คันเกียร์',
    ['Ornaments'] = 'ของตกแต่ง',
    ['Interior'] = 'ภายในรถ',
    ['Interior Color'] = 'สีภายใน',
    ['Primary'] = 'สีหลัก',
    ['Secondary'] = 'สีรอง',
    ['Primary Paint Type'] = 'ประเภทสีหลัก',
    ['Secondary Paint Type'] = 'ประเภทสีรอง',
    ['Pearlescent'] = 'สีมุก',
    ['Wheels Type'] = 'ประเภทรถล้อ',
    ['Wheels Color'] = 'สีล้อ',
    ['Smoke Color'] = 'สีควันยาง',
    ['Sport'] = 'ล้อสปอร์ต',
    ['Muscle'] = 'ล้อมัสเซิล',
    ['Lowrider'] = 'ล้อโลว์ไรเดอร์',
    ['SUV'] = 'ล้อ SUV',
    ['Offroad'] = 'ล้อออฟโรด',
    ['Tuner'] = 'ล้อจูนเนอร์',
    ['Bike Wheels'] = 'ล้อมอเตอร์ไซค์',
    ['High End'] = 'ล้อไฮเอนด์',
    ['Type'] = 'ประเภท',
    ['Color'] = 'สี',
    ['Holder'] = 'กรอบป้าย',
    ['Xenon'] = 'ไฟซีนอน',
    ['Neon'] = 'ไฟนีออน',
    ['Stickers'] = 'สติ๊กเกอร์',
    ['Livery'] = 'ลายรถ',
    ['OFF'] = 'ปิด',
    ['ON'] = 'เปิด',
}

Config.UILabels.OptionLabelsByMenu = {
    main = {
        ['Body'] = 'ตัวรถ',
        ['Upgrade'] = 'อัปเกรด',
    },
}

Config.UILabels.OptionSubLabels = {
    ['Body'] = 'ของตกแต่ง',
    ['Upgrade'] = 'อัปเกรดสมรรถนะ',
}