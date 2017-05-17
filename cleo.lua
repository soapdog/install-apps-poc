
-- sanity check
dofile("check_dependencies.lua")

-- external deps
local lapp = require "pl.lapp"
local path = require "pl.path"
local utils = require "pl.utils"

-- internal deps
local choco = require "choco"
local dotfiles = require "dotfiles"
local log = require "log"
local colors = require "colors"

-- api that is exposed to the Cleofile
local api = {
    choco = choco,
    dotfiles = dotfiles,
    info = function(x) print(x) end
}

local args = lapp [[
    Cleo - tiny provisioning solution-ish
    -v (default false) set verbose output
    <file> configuration to use
]]

local cleofile = args.file or "Cleofile"

if (not path.exists(cleofile)) then
    print("Error: no Cleofile")
    os.exit(1)
end

if (args.v) then
    log.level = "trace"
else
    log.level = "info"
end

print(colors("%{bright cyan}Cleo %{cyan}starting. Processing: " .. cleofile))
local f = assert(loadfile(cleofile))
utils.setfenv(f, api)
f()
