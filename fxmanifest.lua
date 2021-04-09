fx_version 'adamant'

game 'gta5'

description 'Jobs by InVek'

version '1.1.0'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/*.lua'
}

dependency 'es_extended'

export 'GeneratePlate'
