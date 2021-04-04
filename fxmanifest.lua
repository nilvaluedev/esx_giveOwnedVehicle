fx_version 'cerulean'
game 'gta5'

client_scripts {
    'client/code.lua'
}

server_scripts {
    '@mysql-async/Lib/MySQL.lua',
    'server/code.lua'
}

dependencies {
    'mysql-async',
    'es_extended',
    'esx_vehicleshop'
}