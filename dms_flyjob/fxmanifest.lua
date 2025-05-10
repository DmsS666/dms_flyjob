
fx_version 'adamant'

game 'gta5'
version '1.0.0'
description "airjob by dms666"
lua54 "yes"	

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'server.lua'
}

escrow_ignore {
	'config.lua',
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target',
    'oxmysql'
}

shared_script '@es_extended/imports.lua'

