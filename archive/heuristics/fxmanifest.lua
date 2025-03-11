fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'

games { "gta5" }
lua54 'yes'

name 'Heuristics'
author 'Trent'

client_scripts {
  "@hook_patch/hook.lua",
  "c_research.lua"
}