local choco = require "choco"
local pretty = require "pl.pretty"

if (not choco.is_choco_installed()) then
    print("chocolatey not installed")
end

local list = choco.get_installed_packages()

print(list)
print(#list)
pretty.dump(list)

print(choco.is_package_installed("racket"))
print(choco.is_package_available("firefox"))

print(choco.install_package("racket"))