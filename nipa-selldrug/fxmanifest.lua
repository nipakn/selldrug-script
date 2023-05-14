fx_version 'adamant'
games { 'gta5' }

lua54 'on'

author 'nipa#0453'
description 'jsgudghudgjd'

client_scripts {
    "cl_main/*.lua"
} 

server_scripts {
    "sv_main/*.lua"
} 

shared_script {
    '@es_extended/imports.lua',
    'config.lua'
}