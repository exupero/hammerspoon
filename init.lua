package.path = package.path .. ";/opt/homebrew/Cellar/fennel/1.5.1/share/lua/5.1/?.lua"

fennel = require('fennel')
fennel.path = package.path .. ";" .. os.getenv("HOME") .. "/code/dotfiles/hammerspoon/?.fnl;" .. os.getenv("HOME") .. "/code/hammerspoon/?.fnl;"
table.insert(package.loaders or package.searchers, fennel.searcher)

require 'main'
