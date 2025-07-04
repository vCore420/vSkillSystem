fx_version 'cerulean'
game 'gta5'

author 'Vcore'
description 'FiveM Skill System created by Vcore'
version '1.0.0'

client_scripts {
    'client/client.lua',
    'client/effects.lua'
}

server_scripts {
    'server/server.lua'
}

shared_scripts {
    'shared/config.lua'
}

ui_page     'html/index.html'

files {
    'html/images/*.png',
    'html/index.html',
    'html/script.js',
    'html/skills.js,
    'html/style.css'
}
