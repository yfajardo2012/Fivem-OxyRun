fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'oxyrun'
author 'Community'
version '1.0.1'

shared_script 
    '@ox_lib/init.lua'

client_scripts {
    'config.lua',
    'client/*.lua',
}

server_scripts {
    'config.lua',
    'server/*.lua',
}
