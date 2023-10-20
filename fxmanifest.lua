fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Jax Danger'
description 'A script to auto give names to players in the server.'

-- Config File
shared_scripts {
	'shared/config.lua',
    '@ox_lib/init.lua',
}
-- Server File
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua',
} 
-- Client File
client_script 'client/client.lua'
-- Dependencies
dependencies {
	'ox_lib',
	'oxmysql'
}
