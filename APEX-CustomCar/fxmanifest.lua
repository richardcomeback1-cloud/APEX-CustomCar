fx_version 'cerulean'
games { 'gta5' }

author 'VAL Script'
name 'APEX-CustomCar'
description 'APEX-CustomCar'
version '2.0.0'

lua54 'on'
is_cfxv2 'yes'
use_fxv2_oal 'true'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
	'config/core.lua',
	'config/prices.lua',
	'config/menu-labels.lua',
	'config/labels.lua',
	'config/menus.lua',
	
	'client/helper.lua',
	'client/job.lua',
	'client/core.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config/core.lua',
	'server/core.lua'
}

ui_page 'ui/index.html'
files {
	'ui/index.html',
	'ui/js/**/*.js',
	'ui/css/**/*.css',
	'ui/font/**/*.ttf',
	'ui/img/**/*.png',
	'ui/sounds/**/*.ogg',
}