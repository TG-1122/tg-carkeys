fx_version 'adamant'
game 'gta5'

name 'RGX Carlock'
author 'RGX'
version '1.0.0'

lua54 'yes'

shared_script {
	'@ox_lib/init.lua'
}

server_script {
	'@oxmysql/lib/MySQL.lua',
	--'config.lua',
	'server.lua'
}

client_scripts {
	--'config.lua',
	'client.lua'
}
