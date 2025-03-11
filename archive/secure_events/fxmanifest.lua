fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'

games { "gta5" }
lua54 'yes'

name 'Secure Events'
author 'Trent'

files {
  "external/**/*.lua",
}

client_scripts {
  "javascript/dist/client/client.js" 
}

server_scripts {
  "javascript/dist/client/client.js" 
}