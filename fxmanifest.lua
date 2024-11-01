fx_version 'cerulean'
game 'gta5'

name "lfd-CutScenesViewer"
description "Developer script for FiveM to play cutscenes"
author "Mathu_lmn"
version "1.0.0"
lua54 'yes'

client_scripts {
    'client.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
ui_page 'html/index.html'
files {
    'html/index.html',
    'html/style.css',
    'html/menu.js'
}

dependency 'ox_lib'