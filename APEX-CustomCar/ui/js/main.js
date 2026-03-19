let isOpenByAdmin = false;

let currentJobName = null;
let currentCash = null;
let displayedCash = null;
let cashAnimationFrame = null;

let canDetailCardToggle = true;
let userDetailCardToggle = true;

let menuLastPos = [];
let menuLastPosIndex = '';

let cardFadeOutTimeOut = null;

let menuLoading = false;
let lastMenuScrollFrame = null;

let currentVehicleCard = {
    vehicleName: '',
    power: 0.0,
    acceleration: 0.0,
    maxSpeed: 0.0,
    breaks: 0.0
};

let grid = null;
let isCustom = null;
let colorIndex = 0;
let colorPriceMult = null;
let isColorPickerMouseEnabled = false;
let colorPickerMode = 'grid';
let colorWheelState = {
    hue: 0,
    saturation: 100,
    value: 100
};

let colorData = [
    [[13, 17, 22], [28, 29, 33], [50, 56, 61], [69, 75, 79], [153, 157, 160], [194, 196, 198], [151, 154, 151], [99, 115, 128], [99, 98, 92], [60, 63, 71], [68, 78, 84], [29, 33, 41], [19, 24, 31], [38, 40, 42], [81, 85, 84], [21, 25, 33]],
    [[30, 36, 41], [51, 58, 60], [140, 144, 149], [57, 67, 77], [80, 98, 114], [30, 35, 47], [54, 58, 63], [160, 161, 153], [211, 211, 211], [183, 191, 202], [119, 135, 148], [192, 14, 26], [218, 25, 24], [182, 17, 27], [165, 30, 35], [123, 26, 34]],
    [[142, 27, 31], [111, 24, 24], [73, 17, 29], [182, 15, 37], [212, 74, 23], [194, 148, 79], [247, 134, 22], [207, 31, 33], [115, 32, 33], [242, 125, 32], [255, 201, 31], [156, 16, 22], [222, 15, 24], [143, 30, 23], [169, 71, 68], [177, 108, 81]],
    [[55, 28, 37], [19, 36, 40], [18, 46, 43], [18, 56, 60], [49, 66, 63], [21, 92, 45], [27, 103, 112], [102, 184, 31], [34, 56, 62], [29, 90, 63], [45, 66, 63], [69, 89, 75], [101, 134, 127], [34, 46, 70], [35, 49, 85], [48, 76, 126]],
    [[71, 87, 143], [99, 123, 167], [57, 71, 98], [214, 231, 241], [118, 175, 190], [52, 94, 114], [11, 156, 241], [47, 45, 82], [40, 44, 77], [35, 84, 161], [110, 163, 198], [17, 37, 82], [27, 32, 62], [39, 81, 144], [96, 133, 146], [36, 70, 168]],
    [[66, 113, 225], [59, 57, 224], [31, 40, 82], [37, 58, 167], [28, 53, 81], [76, 95, 129], [88, 104, 142], [116, 181, 216], [255, 207, 32], [251, 226, 18], [145, 101, 50], [224, 225, 61], [152, 210, 35], [155, 140, 120], [80, 50, 24], [71, 63, 43]],
    [[34, 27, 25], [101, 63, 35], [119, 92, 62], [172, 153, 117], [108, 107, 75], [64, 46, 43], [164, 150, 95], [70, 35, 26], [117, 43, 25], [191, 174, 123], [223, 213, 178], [247, 237, 213], [58, 42, 27], [120, 95, 51], [181, 160, 121], [255, 255, 246]],
    [[234, 234, 234], [176, 171, 148], [69, 56, 49], [42, 40, 43], [114, 108, 87], [106, 116, 124], [53, 65, 88], [155, 160, 168], [88, 112, 161], [234, 230, 222], [223, 221, 208], [242, 173, 46], [249, 164, 88], [131, 197, 102], [241, 204, 64], [76, 195, 218]],
    [[78, 100, 67], [188, 172, 143], [248, 182, 88], [252, 249, 241], [255, 255, 251], [129, 132, 76], [255, 255, 255], [242, 31, 153], [253, 214, 205], [223, 88, 145], [246, 174, 32], [176, 238, 110], [8, 233, 250], [10, 12, 23], [12, 13, 24], [14, 13, 20]],
    [[159, 158, 138], [98, 18, 118], [11, 20, 33], [17, 20, 26], [107, 31, 123], [30, 29, 34], [188, 25, 23], [45, 54, 42], [105, 103, 72], [122, 108, 85], [195, 180, 146], [90, 99, 82], [129, 130, 127], [175, 214, 228], [122, 100, 64], [127, 106, 72]]
];

const flatColorData = colorData.flat();


const uiLabelFallbackMap = {
    'Body': 'ของแต่งตัวรถ',
    'Upgrade': 'อัปเกรดรถ',
    'Engine': 'เครื่องยนต์',
    'Brakes': 'ระบบเบรก',
    'Transmission': 'ระบบเกียร์',
    'Suspension': 'ช่วงล่าง',
    'Armor': 'เกราะเสริม',
    'Turbo': 'เทอร์โบ',
    'Body Part': 'ชุดแต่งตัวถัง',
    'Inside Part': 'อุปกรณ์ภายใน',
    'Respray': 'ทำสีรถ',
    'Wheel': 'ล้อรถ',
    'Plate': 'ป้ายทะเบียน',
    'Lights': 'ระบบไฟ',
    'Sticker': 'สติ๊กเกอร์',
    'Extra': 'ออปชันเสริม',
    'Window Tint': 'ฟิล์มกระจก',
    'Horn': 'แตรรถ',
    'Speakers': 'ลำโพง',
    'Trunk': 'ห้องเก็บของท้าย',
    'Hydrulics': 'ระบบไฮดรอลิก',
    'Engine Block': 'บล็อกเครื่อง',
    'Air Filter': 'กรองอากาศ',
    'Struts': 'ค้ำโช้ค',
    'Tank': 'ถังน้ำมัน',
    'Spoilers': 'สปอยเลอร์',
    'FrontBumper': 'กันชนหน้า',
    'Rear Bumper': 'กันชนหลัง',
    'Side Skirts': 'สเกิร์ตข้าง',
    'Exhaust': 'ท่อไอเสีย',
    'RollCage': 'โรลเคจ',
    'Grille': 'กระจังหน้า',
    'Hood': 'ฝากระโปรง',
    'Left Fender': 'แก้มซ้าย',
    'Right Fender': 'แก้มขวา',
    'Roof': 'หลังคา',
    'Arch Cover': 'ครอบซุ้มล้อ',
    'Aerials': 'เสาอากาศ',
    'Trim': 'คิ้วตกแต่ง',
    'Dashboard': 'แดชบอร์ด',
    'Dashboard Color': 'สีแดชบอร์ด',
    'Dial': 'หน้าปัดเรือนไมล์',
    'Door Speaker': 'ลำโพงประตู',
    'Seats': 'เบาะรถ',
    'Steering Wheel': 'พวงมาลัย',
    'Shifter Leaver': 'คันเกียร์',
    'Ornaments': 'ของตกแต่ง',
    'Interior': 'ห้องโดยสาร',
    'Interior Color': 'สีภายใน',
    'Primary': 'สีหลัก',
    'Primary Color': 'สีหลัก',
    'Secondary': 'สีรอง',
    'Secondary Color': 'สีรอง',
    'Back Color': 'สีหลัง',
    'Primary Paint Type': 'ประเภทสีหลัก',
    'Secondary Paint Type': 'ประเภทสีรอง',
    'Pearlescent': 'สีมุก',
    'Wheels Type': 'ประเภทล้อ',
    'Wheels Color': 'สีล้อ',
    'Wheel Color': 'สีล้อ',
    'Wheel color': 'สีล้อ',
    'Smoke Color': 'สีควันยาง',
    'Sport': 'ล้อสปอร์ต',
    'Muscle': 'ล้อมัสเซิล',
    'Lowrider': 'ล้อโลว์ไรเดอร์',
    'SUV': 'ล้อ SUV',
    'Offroad': 'ล้อออฟโรด',
    'Tuner': 'ล้อสายแต่ง',
    'Bike Wheels': 'ล้อมอเตอร์ไซค์',
    'High End': 'ล้อไฮเอนด์',
    'Type': 'ประเภท',
    'Color': 'สี',
    'Holder': 'กรอบป้ายทะเบียน',
    'Xenon': 'ไฟซีนอน',
    'Neon': 'ไฟนีออน',
    'Stickers': 'สติ๊กเกอร์',
    'Livery': 'ลายรถ',
    'OFF': 'ปิด',
    'ON': 'เปิด'
};

function resolveUiLabelFallback(label) {
    if (!label) return label;
    const key = String(label).trim();

    const extraMatch = key.match(/^Extra\s+(\d+)$/i);
    if (extraMatch) {
        return `ออปชัน ${extraMatch[1]}`;
    }

    return uiLabelFallbackMap[key] || label;
}


function renderCash(value) {
    $('#cash').html('$' + GetNumberWithCommas(Math.max(0, Math.floor(value || 0))));
}

function animateCashTo(targetCash, smoothDecreaseOnly) {
    const nextCash = Math.max(0, Math.floor(targetCash || 0));

    if (displayedCash === null) {
        displayedCash = nextCash;
        renderCash(displayedCash);
        return;
    }

    if (cashAnimationFrame !== null) {
        cancelAnimationFrame(cashAnimationFrame);
        cashAnimationFrame = null;
    }

    const startCash = displayedCash;
    if (startCash === nextCash) {
        renderCash(nextCash);
        return;
    }

    const shouldAnimate = !smoothDecreaseOnly || nextCash < startCash;
    if (!shouldAnimate) {
        displayedCash = nextCash;
        renderCash(displayedCash);
        return;
    }

    const diff = Math.abs(nextCash - startCash);
    const duration = Math.min(700, Math.max(180, diff / 40));
    const startTime = performance.now();

    const step = (now) => {
        const progress = Math.min((now - startTime) / duration, 1);
        const eased = 1 - Math.pow(1 - progress, 3);
        displayedCash = Math.round(startCash + ((nextCash - startCash) * eased));
        renderCash(displayedCash);

        if (progress < 1) {
            cashAnimationFrame = requestAnimationFrame(step);
        } else {
            displayedCash = nextCash;
            renderCash(displayedCash);
            cashAnimationFrame = null;
        }
    };

    cashAnimationFrame = requestAnimationFrame(step);
}

function getNuiResourceName() {
    if (typeof window.GetParentResourceName === 'function') {
        return window.GetParentResourceName();
    }

    return window.location.hostname || 'nui-resource';
}

$(window).ready(function() {
    resetUI();
    listener();

    $.post(`https://${getNuiResourceName()}/uiReady`, {});
});

function listener() {
    window.addEventListener('message', (event) => {
        let tempData = event.data;

        if (tempData.type === 'open') {
            isOpenByAdmin = tempData.isOpenByAdmin

            $('.display_mech').fadeIn();
            
            fadeInDetailCard();
            userDetailCardToggle = false;

            if (tempData.what === 'menu') {
                createMenu(tempData.menuId, tempData.options, tempData.menuTitle, tempData.defaultOption, tempData.whitelistJobName);
            } else if (tempData.what === 'colorPicker') {
                isCustom = tempData.isCustom;
                colorPriceMult = tempData.priceMult;
                fadeInColorPicker(tempData.title, isOpenByAdmin ? 0 : tempData.price, tempData.defaultValue, tempData.whitelistJobName);
            }
        } else if (tempData.type === 'close') {
            resetUI();
        } else if (tempData.type === 'update') {
            if (tempData.what === 'card') {
                updateDetailCardData(tempData);
            } else if (tempData.what === 'cash') {
                if (currentCash != tempData.cash) {
                    currentCash = tempData.cash;
                    animateCashTo(currentCash, true);

                    if (!$('.mech_color_palette').is(":hidden")) {
                        let tempPrice = parseInt($('#colorPicker-price').html().replace(/[^0-9]/g, ''));
                        if (tempPrice > currentCash) {
                            $('#colorPicker-price').addClass('cash_not');
                        } else {
                            $('#colorPicker-price').removeClass('cash_not');
                        }
                    }
                }
            } else if (tempData.what === 'job') {
                currentJobName = tempData.jobName;
            } else if (tempData.what === 'menu') {
                createMenu(tempData.menuId, tempData.options, tempData.menuTitle, tempData.defaultOption, tempData.whitelistJobName);
            } else if (tempData.what === 'colorPicker') {
                fadeOutColorPicker();
            }
        } else if (tempData.type === 'playSound') {
            playSound(tempData.soundName, tempData.volume);
        }
    });
}

document.onkeydown = function(event) {
    if(menuLoading){ return }
    if (event.which == 9) {
        return false;
    } else if (event.which == 39 || event.which == 68) { // right (next)
        event.preventDefault();

        if (!menuLoading) {
            if ($('.mech_color_palette').is(":hidden") == true) {
                menuGoto(1,true);
            } else {
                menuColorPickerGoto(1, 0)
            }
        }
    } else if (event.which == 37 || event.which == 65) { // left (prev)
        event.preventDefault();

        if (!menuLoading) {
            if ($('.mech_color_palette').is(":hidden") == true) {
                menuGoto(-1,true);
            } else {
                menuColorPickerGoto(-1, 0)
            }
        }
    } else if (event.which == 67) { // c
        event.preventDefault();

        if ($('.mech_color_palette').is(":hidden") == false) {
            setColorPickerMouse(false);
        }
    } else if (event.which == 71) { // g
        event.preventDefault();

        userDetailCardToggle = !userDetailCardToggle;
        fadeInDetailCard();
        fadeOutDetailCard();
    } else if (event.which == 72) { // h
        event.preventDefault();

        if ($('.mech_color_palette').is(":hidden") == false) {
            toggleColorPickerMouse();
        }
    } else if (event.which == 82) { // r
        event.preventDefault();

        if ($('.mech_color_palette').is(":hidden") == false && colorPickerMode === 'wheel') {
            resetColorWheelToPureWhite();
        }
    } else if (event.which == 38 || event.which == 87) { // up
        event.preventDefault();
        if (!menuLoading) {
            if ($('.mech_color_palette').is(":hidden") == false) {
                menuColorPickerGoto(0, -1)
            }
            else{
                menuGoto(-1,true);
            }
        }
    } else if (event.which == 40 || event.which == 83) { // down
        event.preventDefault();
        if (!menuLoading) {
            if ($('.mech_color_palette').is(":hidden") == false) {
                menuColorPickerGoto(0, 1)
            }
            else{
                menuGoto(1,true); 
            }
        }
    } else if (event.which == 8) { // backspace
        event.preventDefault();

        $.post(`https://${getNuiResourceName()}/handle`, JSON.stringify({
            type: 'update',
            what: 'menu',
            user: 'backspace',
            menuId: menuLastPosIndex,
            menuIndex: menuLastPos[menuLastPosIndex]
        }));

        menuLastPos[menuLastPosIndex] = null;

        if ($('.mech_color_palette').is(":hidden") == false) {
            fadeOutColorPicker();
        }
    } else if (event.which == 13) { // enter
        event.preventDefault();

        $.post(`https://${getNuiResourceName()}/handle`, JSON.stringify({
            type: 'update',
            what: 'menu',
            user: 'enter',
            menuId: menuLastPosIndex,
            menuIndex: menuLastPos[menuLastPosIndex],
            color: getCurrentColorPayload(),
            isCustom: isCustom,
            priceMult: colorPriceMult,
        }));
    } else if (event.which == 27) { // esc
        event.preventDefault();

        resetUI();
        setTimeout(() => {
            $.post(`https://${getNuiResourceName()}/handle`, JSON.stringify({
                type: "close"
            }));
        }, 400);
       
    }
}

function resetUI() {
    $('.display_mech').fadeOut();

    canDetailCardToggle = true;
    userDetailCardToggle = true;

    menuLastPos = [];
    menuLastPosIndex = '';

    cardFadeOutTimeOut = null;
    clearTimeout(cardFadeOutTimeOut);
    
    menuLoading = false;

    if (cashAnimationFrame !== null) {
        cancelAnimationFrame(cashAnimationFrame);
        cashAnimationFrame = null;
    }
    displayedCash = null;

    if (lastMenuScrollFrame !== null) {
        cancelAnimationFrame(lastMenuScrollFrame);
        lastMenuScrollFrame = null;
    }

    $('#scroll-container').html('');

    $('#detailCard').hide();
    $('#detailCard').css({opacity: 0, right: '-140px'})
    fadeOutColorPicker()

    isCustom = null;
    grid = null;
    colorIndex = 0;
    isColorPickerMouseEnabled = false;
    colorPickerMode = 'grid';
    $('#colorPicker-title').html('');
    $('#colorPicker-price').html('');
    $('#colorPicker-holder').hide()
}

function createMenu(menuId, data, title, defaultOption, whitelistJobName) {
    menuLastPosIndex = menuId;
    menuLoading = true;
    $('.mech_title').html(`
        <div class="mech_path">
                      <p class="title_show">${title}</p>
         </div>
    `);
        $('#scroll-container').html('');
        const menuItems = [];
        for (let i = 0; i < data.length; i++) {
            let price = '';
            let LastPage = '';
            let Class = '';
            let isnotprice = false;
            LastPage = 'last_page';

            if (data[i].price >= 0) {
                let tempPrice = data[i].price;
                if (whitelistJobName && currentJobName == whitelistJobName) {
                    tempPrice = data[i].price;
                }

                price = `
                 <div class="mech_price">
                      <p>${isOpenByAdmin ? 0 : GetNumberWithCommas(tempPrice)}</p>
                 </div>
                `;
            } else if (data[i].price == -1) {
                Class = 'active';
                price = `
                 <div class="mech_price">
                      <p>กำลังใช้งาน</p>
                 </div>
                `;
            } else {
                isnotprice = true;
            }

            const displayLabel = resolveUiLabelFallback(data[i].uiLabel || data[i].label);
            const displayLabelTH = data[i].uiLabelTH || data[i].labelTH;
            const displayTitle = resolveUiLabelFallback((data[i].uiMenuTitle || title || '')).replaceAll("Type","");

            menuItems.push(`
                <div class="mech_ul img_${(data[i].img).replaceAll('img/icons/').replaceAll('.png')} ${Class} ${LastPage}" style="animation: cIn 0.3s forwards;">
                   <div class="mech_img"></div>
                   <div class="mech_li">
                     ${displayLabelTH ? ` <p>${displayLabel}</p> <p>${displayLabelTH}</p>` : `${isnotprice ? ` <p>${displayLabel.replaceAll("Type","")}</p> ` : ` <p>${displayLabel}</p> <p>${displayTitle}</p>`}`}
                   </div>
                  ${price}
                   <div class="mech_number">
                     <p> ${i + 1}</p>
                   </div>
                 </div>
           `);
        }

        $('#scroll-container').html(menuItems.join(''));

        defaultOption = defaultOption ? defaultOption : 0;
        menuLastPos[menuLastPosIndex] = menuLastPos[menuLastPosIndex] != null ? menuLastPos[menuLastPosIndex] : defaultOption;
        $('.mech_main_area').show();
        menuGoto(0);

        setTimeout(() => {
            menuLoading = false;
        }, 120);
}

function menuGoto(valueHor,News) {
    let total = $('#scroll-container > div').length;
    if (total < 1) {
        $('.mech_page_number p').html('');
        $('.mech_title').html('');
        return;
    }
    $('#scroll-container > div').eq(menuLastPos[menuLastPosIndex]).removeClass('hovers');
    
    menuLastPos[menuLastPosIndex] = menuLastPos[menuLastPosIndex] + valueHor;
    if (menuLastPos[menuLastPosIndex] > (total - 1)) {
        menuLastPos[menuLastPosIndex] = 0
    }
    if (menuLastPos[menuLastPosIndex] < 0) {
        menuLastPos[menuLastPosIndex] = total - 1
    }
    
    $('#scroll-container > div').eq(menuLastPos[menuLastPosIndex]).addClass('hovers');
    $('.mech_page_number p').html((menuLastPos[menuLastPosIndex] + 1) + '/' + total);
    if (lastMenuScrollFrame !== null) {
        cancelAnimationFrame(lastMenuScrollFrame);
    }

    lastMenuScrollFrame = requestAnimationFrame(() => {
        const container = document.getElementById('scroll-container');
        const activeItem = $('#scroll-container > div').eq(menuLastPos[menuLastPosIndex])[0];

        if (container && activeItem) {
            const targetLeft = activeItem.offsetLeft;
            container.scrollTo({
                left: targetLeft,
                behavior: News ? 'smooth' : 'auto'
            });
        }

        lastMenuScrollFrame = null;
    });
   

    $.post(`https://${getNuiResourceName()}/handle`, JSON.stringify({
        type: 'update',
        what: 'menu',
        user: 'hover',
        menuId: menuLastPosIndex,
        menuIndex: menuLastPos[menuLastPosIndex]
    }));
}

function menuColorPickerGoto(hor, vert) {
    if (colorPickerMode === 'wheel') {
        const hueStep = 8;
        const valueStep = 4;

        if (hor !== 0) {
            colorWheelState.hue = (colorWheelState.hue + (hor * hueStep) + 360) % 360;
        }

        if (vert !== 0) {
            colorWheelState.value = Math.max(0, Math.min(100, colorWheelState.value + (vert < 0 ? valueStep : -valueStep)));
        }

        renderColorWheelSelection();
        postColorPickerHover();
        return;
    }

    $('.colorPicker-column').eq(colorIndex).removeClass('active');

    if (hor != 0) {
        colorIndex += hor;

        if (hor > 0 && colorIndex % grid.x == 0) {
            colorIndex -= grid.x;
        }
        if (hor < 0 && (colorIndex % grid.x == (grid.x - 1) || colorIndex % grid.x < 0)) {
            colorIndex += grid.x;
        }
    }
    if (vert != 0) {
        colorIndex += (vert * grid.x);
        
        if (colorIndex == -grid.x) {
            colorIndex = $('.colorPicker-column').length - grid.x;
        }
        if (colorIndex < 0) {
            colorIndex = $('.colorPicker-column').length + (colorIndex % grid.x);
        }
        if (colorIndex >= $('.colorPicker-column').length) {
            colorIndex = colorIndex % grid.x;
        }
    }

    $('.colorPicker-column').eq(colorIndex).addClass('active');

    postColorPickerHover();
}

function postColorPickerHover() {
    $.post(`https://${getNuiResourceName()}/handle`, JSON.stringify({
        type: 'update',
        what: 'menu',
        user: 'hover',
        menuId: menuLastPosIndex,
        menuIndex: menuLastPos[menuLastPosIndex],
        color: getCurrentColorPayload(),
        isCustom: isCustom
    }));
}

function getCurrentColorPayload() {
    if ($('.mech_color_palette').is(":hidden") == true) {
        return null;
    }

    if (colorPickerMode === 'wheel') {
        const rgb = hsvToRgb(colorWheelState.hue, colorWheelState.saturation, colorWheelState.value);
        if (isCustom) {
            return [rgb.r, rgb.g, rgb.b];
        }
        return getNearestColorIndex(rgb.r, rgb.g, rgb.b);
    }

    let tempColor = colorIndex;
    if (isCustom) {
        let temp = getRGBFromString($('.active').css("background-color"));
        tempColor = [temp.red, temp.green, temp.blue];
    }
    return tempColor;
}

function updateDetailCardData(data) {
    currentVehicleCard.vehicleName = data.vehicleName ? data.vehicleName : currentVehicleCard.vehicleName
    currentVehicleCard.power = data.power ? data.power : currentVehicleCard.power;
    currentVehicleCard.acceleration = data.acceleration ? data.acceleration : currentVehicleCard.acceleration;
    currentVehicleCard.maxSpeed = data.maxSpeed ? data.maxSpeed : currentVehicleCard.maxSpeed;
    currentVehicleCard.breaks = data.breaks ? data.breaks : currentVehicleCard.breaks;

    $('#detailCard_name').html(currentVehicleCard.vehicleName);

    $('.acc_1').css('background-size', (currentVehicleCard.acceleration * 10).toFixed(0) + '%')
    $('.spd_1').css('background-size', (currentVehicleCard.maxSpeed * 10).toFixed(0) + '%')
    $('.brk_1').css('background-size', (currentVehicleCard.breaks * 10).toFixed(0) + '%')
    $('.sus_1').css('background-size', (currentVehicleCard.power * 10).toFixed(0) + '%')
    if (data.class) {
        $('#class_name').html(data.class)
    }
}

function fadeInDetailCard() {
    if (!userDetailCardToggle || !canDetailCardToggle || !$('#detailCard').is(':hidden')) {
        return;
    }
    
    canDetailCardToggle = false;
  
    $('.acc_1').css('background-size', (currentVehicleCard.acceleration * 10).toFixed(0) + '%')
    $('.spd_1').css('background-size', (currentVehicleCard.maxSpeed * 10).toFixed(0) + '%')
    $('.brk_1').css('background-size', (currentVehicleCard.breaks * 10).toFixed(0) + '%')
    $('.sus_1').css('background-size', (currentVehicleCard.power * 10).toFixed(0) + '%')
    setTimeout(() => {
        canDetailCardToggle = true;
    }, 3000);
    $('#detailCard').stop(true, true).animate({
        opacity: 1,
        left: '5%'
    }, 1000)

    $('#detailCard').show();
}

function fadeOutDetailCard() {
    if (userDetailCardToggle || !canDetailCardToggle || !$('#detailCard').is(':visible')) {
        return;
    }

    canDetailCardToggle = false;

    $('#detailCard').stop(true, true).animate({
        opacity: 0,
        left: '-10%'
    }, 1000, function() {
        $('#detailCard').hide();

        setTimeout(function(){
            canDetailCardToggle = true;
        }, 1000);
    })
}

function fadeInColorPicker(title, price, defaultValue, whitelistJobName) {
    menuLoading = true 
    initColorPicker(title, isOpenByAdmin ? 0 : price, defaultValue, whitelistJobName);
    $('#colorPicker-holder').fadeIn()
    $('#colorPicker-holder').stop(true, true).animate({
        opacity: 1,
        right: '4%'
    }, 500)
    setTimeout(() => {
        menuLoading = false 
    }, 550);
}

function fadeOutColorPicker() {
    $('#colorPicker-holder').stop(true, true).animate({
        opacity: 0,
        right: '-30%'
    }, 500, function() {
        // Callback after animation completes
        $('#colorPicker-holder').hide();
        $('.mech_color_palette').hide();
        setColorPickerMouse(false);
    });
}

function GetNumberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function initColorPicker(title, price, defaultValue, whitelistJobName) {
    let srting = '';
    let scale = 18
    
    let tempPrice = price;
    if (whitelistJobName && currentJobName == whitelistJobName) {
        tempPrice = price;
    }

    if (isOpenByAdmin)
        tempPrice = 0

    $('#colorPicker-title').html(resolveUiLabelFallback(title));
    $('#colorPicker-price').html('$' + GetNumberWithCommas(tempPrice));
    if (tempPrice > currentCash) {
        $('#colorPicker-price').addClass('cash_not');
    }else{
        $('#colorPicker-price').removeClass('cash_not');
    }

    $('#colorPicker-container').html('');

    setColorPickerMouse(false);
    colorPickerMode = 'wheel';

    if (colorPickerMode === 'wheel') {
        let initialRgb = [255, 255, 255];

        if (isCustom && Array.isArray(defaultValue) && defaultValue.length >= 3) {
            initialRgb = [defaultValue[0], defaultValue[1], defaultValue[2]];
        } else if (!isCustom && Number.isInteger(defaultValue) && flatColorData[defaultValue]) {
            initialRgb = flatColorData[defaultValue];
            colorIndex = defaultValue;
        }

        const initialHsv = rgbToHsv(initialRgb[0], initialRgb[1], initialRgb[2]);
        colorWheelState = {
            hue: initialHsv.h,
            saturation: initialHsv.s,
            value: initialHsv.v
        };

        srting = `
            <div class='color-wheel-wrapper'>
                <div class='color-wheel' id='colorWheel'>
                    <canvas id='colorWheel-canvas' width='360' height='360'></canvas>
                    <div class='color-wheel-marker' id='colorWheel-marker'></div>
                </div>
                <input type='range' min='0' max='100' id='colorWheel-value' value='${colorWheelState.value}' />
                <div class='color-wheel-shortcuts'>
                    <div class='color-wheel-shortcut'>
                        <p>รีเซ็ตเป็นขาวแท้</p>
                        <p>R</p>
                    </div>
                    <div class='color-wheel-shortcut'>
                        <p>เปิด / ปิดเมาส์เลือกสี</p>
                        <p>H</p>
                    </div>
                    <div class='color-wheel-shortcut'>
                        <p>ยืนยันสีที่เลือก</p>
                        <p>ENTER</p>
                    </div>
                </div>
            </div>
        `;

        $('#colorPicker-container').html(srting);
        bindColorWheelEvents();
        drawColorWheel();
        renderColorWheelSelection();
        $('#colorPicker-holder').width(35 + 'vh');
        return;
    }
    
    if (isCustom != null && !isCustom) {
        grid = {x: colorData[0].length, y: colorData.length};
     
        let tempCount = 0;
        for (let y = 0; y < colorData.length; y++) {
            srting += `<div class='colorPicker-row'>`;
            for (let x = 0; x < colorData[y].length; x++) {
                let tempClass = '';
                if (tempCount == defaultValue) {
                    tempClass = 'colorPicker-columnDefault select';
                    colorIndex = tempCount;
                }

                srting += `<div class='color_01 colorPicker-column ${tempClass}' style='background-color:rgb(${colorData[y][x][0]},${colorData[y][x][1]},${colorData[y][x][2]});'></div>`;
                tempCount += 1;
            }
            srting += `</div>`;
        }
    } else {
        grid = {x: 16, y: 12}
        let hslOfDefault = rgbToHsl(defaultValue[0], defaultValue[1], defaultValue[2]);
        
        let tempCount = 0;
        srting += `<div class='colorPicker-row'>`;
        for (let x = 0; x < grid.x; x++) {
            let h = 0;
            let s = 0;
            let l = 100 - (x * 100 / (grid.x - 1));

            let tempClass = '';
           
            if (Math.abs(hslOfDefault[0] - h.toFixed(2)) <= 0.01 && Math.abs(hslOfDefault[1] - s.toFixed(2)) <= 0.01 && Math.abs(hslOfDefault[2] - l.toFixed(2)) <= 0.01) {
                tempClass = 'colorPicker-columnDefault select';
                colorIndex = tempCount;
            }
            
            srting += `<div class='color_01 colorPicker-column ${tempClass}' style='background-color:hsl(${h}deg,${s}%,${l}%);'></div>`;
            tempCount += 1;
        }
        srting += `</div>`;

        for (let y = 3; y < grid.y; y++) {
            srting += `<div class='colorPicker-row'>`;
            for (let x = 0; x < grid.x; x++) {
                let h = 360 / grid.x * x;
                let s = 200 / grid.y * y;
                let l = 100 - (100 / grid.y * y);

                let tempClass = '';
                if (Math.abs(hslOfDefault[0] - h.toFixed(2)) <= 1.01 && Math.abs(hslOfDefault[1] - s.toFixed(2)) <= 84.01 && Math.abs(hslOfDefault[2] - l.toFixed(2)) <= 1.01) {
                    tempClass = 'colorPicker-columnDefault select';
                    colorIndex = tempCount;
                }
                srting += `<div class='color_01 colorPicker-column ${tempClass}' style='background-color:hsl(${h}deg,${s}%,${l}%);'></div>`;
                tempCount += 1;
            }
            srting += `</div>`;
        }
    }

    $('#colorPicker-container').html(srting);
    
    $('#colorPicker-holder').width((grid.x * scale) + (grid.x * 6) - 2);
    $('.colorPicker-column').height(scale - 2);

    if ($('.active').length < 1) {
        $('.colorPicker-column').eq(0).addClass('colorPicker-columnDefault');
        $('.colorPicker-column').eq(0).addClass('active');
        colorIndex = 0;
    }
}


function toggleColorPickerMouse() {
    setColorPickerMouse(!isColorPickerMouseEnabled);
}

function setColorPickerMouse(enable) {
    isColorPickerMouseEnabled = enable;

    $('#colorPicker-holder').toggleClass('mouse-enabled', enable);
    $('body').toggleClass('mouse-enabled', enable);

    $.post(`https://${getNuiResourceName()}/handle`, JSON.stringify({
        type: 'update',
        what: 'menu',
        user: 'toggleMouse',
        enableMouse: enable
    }));
}

function bindColorWheelEvents() {
    const wheelElement = document.getElementById('colorWheel');
    const valueSlider = document.getElementById('colorWheel-value');
    if (!wheelElement || !valueSlider) return;

    wheelElement.onmousedown = (event) => {
        if (!isColorPickerMouseEnabled) return;
        const updatePoint = (clientX, clientY) => {
            const rect = wheelElement.getBoundingClientRect();
            const cx = rect.left + (rect.width / 2);
            const cy = rect.top + (rect.height / 2);
            const dx = clientX - cx;
            const dy = clientY - cy;
            const radius = rect.width / 2;
            const distance = Math.min(Math.sqrt((dx * dx) + (dy * dy)), radius);

            const hue = (Math.atan2(dy, dx) * 180 / Math.PI + 360) % 360;
            const saturation = Math.max(0, Math.min(100, (distance / radius) * 100));

            colorWheelState.hue = hue;
            colorWheelState.saturation = saturation;

            renderColorWheelSelection();
            postColorPickerHover();
        };

        updatePoint(event.clientX, event.clientY);

        document.onmousemove = (moveEvent) => updatePoint(moveEvent.clientX, moveEvent.clientY);
        document.onmouseup = () => {
            document.onmousemove = null;
            document.onmouseup = null;
        };
    };

    valueSlider.oninput = (event) => {
        if (!isColorPickerMouseEnabled) return;
        colorWheelState.value = Number(event.target.value);
        renderColorWheelSelection();
        postColorPickerHover();
    };

}

function resetColorWheelToPureWhite() {
    colorWheelState.hue = 0;
    colorWheelState.saturation = 0;
    colorWheelState.value = 100;
    renderColorWheelSelection();
    postColorPickerHover();
}

function drawColorWheel() {
    const canvas = document.getElementById('colorWheel-canvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    const radius = canvas.width / 2;
    const centerX = radius;
    const centerY = radius;

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    for (let angle = 0; angle < 360; angle += 1) {
        const start = (angle - 1) * Math.PI / 180;
        const end = angle * Math.PI / 180;

        const gradient = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, radius);
        gradient.addColorStop(0, `hsl(${angle}, 0%, 100%)`);
        gradient.addColorStop(1, `hsl(${angle}, 100%, 50%)`);

        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, radius, start, end);
        ctx.closePath();
        ctx.fillStyle = gradient;
        ctx.fill();
    }
}

function renderColorWheelSelection() {
    const wheelElement = document.getElementById('colorWheel');
    const marker = document.getElementById('colorWheel-marker');
    const valueSlider = document.getElementById('colorWheel-value');
    if (!wheelElement || !marker || !valueSlider) return;

    const radius = wheelElement.clientWidth / 2;
    const angle = colorWheelState.hue * Math.PI / 180;
    const distance = (Math.max(0, colorWheelState.saturation) / 100) * radius;
    const x = (Math.cos(angle) * distance) + radius;
    const y = (Math.sin(angle) * distance) + radius;

    marker.style.left = `${x}px`;
    marker.style.top = `${y}px`;
    valueSlider.value = colorWheelState.value;
    const rgb = hsvToRgb(colorWheelState.hue, colorWheelState.saturation, colorWheelState.value);
    valueSlider.style.background = `linear-gradient(to right, rgb(0,0,0), rgb(${rgb.r}, ${rgb.g}, ${rgb.b}))`;

    if (!isCustom) {
        colorIndex = getNearestColorIndex(rgb.r, rgb.g, rgb.b);
    }
}

function rgbToHsv(r, g, b) {
    r /= 255;
    g /= 255;
    b /= 255;

    const max = Math.max(r, g, b), min = Math.min(r, g, b);
    const d = max - min;
    let h = 0;
    const s = max === 0 ? 0 : d / max;
    const v = max;

    if (d !== 0) {
        if (max === r) {
            h = ((g - b) / d) % 6;
        } else if (max === g) {
            h = ((b - r) / d) + 2;
        } else {
            h = ((r - g) / d) + 4;
        }
        h *= 60;
        if (h < 0) h += 360;
    }

    return { h: Math.round(h), s: Math.round(s * 100), v: Math.round(v * 100) };
}

function hsvToRgb(h, s, v) {
    s /= 100;
    v /= 100;

    const c = v * s;
    const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
    const m = v - c;

    let r = 0, g = 0, b = 0;

    if (h < 60) {
        r = c; g = x; b = 0;
    } else if (h < 120) {
        r = x; g = c; b = 0;
    } else if (h < 180) {
        r = 0; g = c; b = x;
    } else if (h < 240) {
        r = 0; g = x; b = c;
    } else if (h < 300) {
        r = x; g = 0; b = c;
    } else {
        r = c; g = 0; b = x;
    }

    return {
        r: Math.round((r + m) * 255),
        g: Math.round((g + m) * 255),
        b: Math.round((b + m) * 255)
    };
}

function getNearestColorIndex(r, g, b) {
    let nearestIndex = 0;
    let nearestDistance = Number.POSITIVE_INFINITY;

    for (let i = 0; i < flatColorData.length; i++) {
        const [cr, cg, cb] = flatColorData[i];
        const distance = ((r - cr) ** 2) + ((g - cg) ** 2) + ((b - cb) ** 2);
        if (distance < nearestDistance) {
            nearestDistance = distance;
            nearestIndex = i;
        }
    }

    return nearestIndex;
}

function rgbToHsl(r, g, b) {
    r /= 255;
    g /= 255;
    b /= 255;

    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);
    const delta = max - min;

    let l = (max + min) / 2;

    let h, s;

    if (delta === 0) {
        h = 0;
        s = 0;
    } else {
        s = l > 0.5 ? delta / (2 - max - min) : delta / (max + min);

        switch (max) {
            case r:
                h = (g - b) / delta + (g < b ? 6 : 0);
                break;
            case g:
                h = (b - r) / delta + 2;
                break;
            case b:
                h = (r - g) / delta + 4;
                break;
        }
        h *= 60;
    }

    return [Math.round(h), Math.round(s * 100), Math.round(l * 100)];
}

function getRGBFromString(str){
    let match = str.match(/rgba?\((\d{1,3}), ?(\d{1,3}), ?(\d{1,3})\)?(?:, ?(\d(?:\.\d?))\))?/);
    return match ? {
        red: match[1],
        green: match[2],
        blue: match[3]
    } : {};
}

function playSound(soundName, volume) {
    let audioElement = document.createElement('audio');
    audioElement.setAttribute('src', 'sounds/' + soundName + '.ogg');
    audioElement.volume = volume;

    audioElement.addEventListener('ended', function() {
        this.remove();
    }, false);

    audioElement.play();
}
