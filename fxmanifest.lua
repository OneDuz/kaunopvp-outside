fx_version 'cerulean'
game 'gta5'

lua54 "yes"

author "onecodes"
version "1.0.5"
description 'Simple npcs with markers storage wardrobe sellguns store and wardrobe system with import export codes for outfits'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    'config.lua'
}

shared_script '@ox_lib/init.lua'
