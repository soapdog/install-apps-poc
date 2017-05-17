
local path = require "pl.path"
local file = require "pl.file"
local utils = require "pl.utils"
local stringx = require "pl.stringx"
local pretty = require "pl.pretty"
local log = require "log"
local win = require "win"

stringx.import()

local choco = {}

function choco.is_choco_installed()
    local succ, code, out, err = utils.executeex("choco -v")

    if (succ) then
        return true
    else
        return false
    end
end

function choco.get_installed_packages()
    local succ, code, out, err = utils.executeex("choco list -lo -r")

    if (not choco.is_choco_installed()) then
        return false, "chocolatey not installed"
    end

    if (not succ) then
        return err
    end

    local list = {}
    for line in out:lines() do
        local pair = line:split("|")
        table.insert(list, {package = pair[1], version = pair[2]})
    end

    return list
end

function choco.search_packages(query_string, channel)
    if (channel == nil) then
        channel = ""
    end

    local succ, code, out, err = utils.executeex("choco search " .. query_string .." -r " .. channel)

    if (not choco.is_choco_installed()) then
        return false, "chocolatey not installed"
    end

    if (not succ) then
        return err
    end

    local list = {}
    for line in out:lines() do
        local pair = line:split("|")
        table.insert(list, {package = pair[1], version = pair[2]})
    end

    return list
end

function choco.is_package_installed(package_name)
    local installed_packages = choco.get_installed_packages()

    for _, v in ipairs(installed_packages) do
        if (v["package"] == package_name) then
            return true, v["version"]
        end
    end
    return false
end

function choco.is_package_available(package_name, channel)
    local installed_packages = choco.search_packages(package_name, channel)

    for _, v in ipairs(installed_packages) do
        if (string.lower(v["package"]) == string.lower(package_name)) then
            return true, v["version"]
        end
    end
    return false
end

function choco.install_package(package_name, force_reinstall, extra_args)
    local is_already_installed = choco.is_package_installed(package_name)

    if (is_already_installed and not force_reinstall) then
        return true
    end

    if (not choco.is_package_available(package_name, extra_args)) then
        return false, "package " .. package_name .. " does not exist"
    end

    local cmd = "choco install " .. package_name .. " -y"

    if (force_reinstall) then
        cmd = cmd .. " --force"
    end

    if (extra_args) then
        cmd = cmd .. " " .. extra_args
    end

    local succ, code = utils.execute(cmd)

    if (not succ) then
        return false, code, "could not install package " .. package_name
    end

    return choco.is_package_installed(package_name)
end

function choco.install_packages(packages)
    local result = {}
    for i, v in ipairs(packages) do
        log.info("Installing " .. v .. " (" .. i .. "/" .. #packages ..")")
        local mem = collectgarbage("count") * 1024
        log.debug("Lua memory usage: " .. mem)
        local succ, version = choco.install_package(v)
        if (succ) then
            table.insert(result,{package = v, installed = succ, version = version})
        else
            table.insert(result,{package = v, installed = succ, reason = version})
        end
        collectgarbage()
    end
    pretty.dump(result)
    return result
end

function choco.install_prerelease_packages(packages)
    local result = {}
    for i, v in ipairs(packages) do
        log.info("Installing prerelease " .. v .. " (" .. i .. "/" .. #packages ..")")
        log.debug("Lua memory usage: " .. (collectgarbage("count") * 1024))
        local succ, version = choco.install_package(v, false, "--pre")
        if (succ) then
            table.insert(result,{package = v, installed = succ, version = version})
        else
            table.insert(result,{package = v, installed = succ, reason = version})
        end
        collectgarbage()
    end
    pretty.dump(result)
    return result
end


return choco
