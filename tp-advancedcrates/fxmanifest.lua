fx_version 'bodacious'
games { 'gta5' }

author 'Nosmakos'
description 'Titans Productions Advanced Crates'
version '1.0.0'

ui_page 'html/index.html'

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
	'locales/gr.lua',
    'config.lua',
    'client/tp-client_main.lua',
    'client/tp-client_inventory.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'locales/en.lua',
	'locales/gr.lua',
	'config.lua',
    'server/tp-server_main.lua',
    'server/tp-server_inventory.lua'
}

files {
	'html/index.html',
	'html/js/script.js',
	'html/css/*.css',
	'html/font/Prototype.ttf',
    'html/img/background.jpg',
    'html/img/background_loading.png',
    'html/img/items/*.png',
    'html/img/shortcuts/*.png',
}


dependency 'es_extended'