local unsafe = {}
local log = require"log"

local unsafe.enable_wsl()
    local cmd = [[ Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux ]]
end

local unsafe.enable_dev_mode()
    local step1 = [[ reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"]]
    local step2 = [[ reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowAllTrustedApps" /d "1" ]]
end

local unsafe.is_wsl_enabled()
    return false
end

function unsafe.install_from_url(urls)
    return false
end

return unsafe