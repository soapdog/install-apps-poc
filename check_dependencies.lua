local required_modules_list = {
    "pl.lapp",
    "pl.pretty",
    "pl.path",
    "pl.lapp",
    "pl.utils",
}

local colors = require "colors"
local choco = require "choco"

function isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

local has_error = false
for _, v in ipairs(required_modules_list) do
    if not isModuleAvailable(v) then
        print(colors("%{red}Error: %{white}module not found: " .. v))
        has_error = true
    end
end

if (not choco.is_choco_installed()) then
      print(colors("%{red}Error: %{white}chocolatey not installed"))
end

if has_error then
    print(colors("%{cyan}Please install missing modules with luarocks before using cleo"))
    os.exit(1)
end
