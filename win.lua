local alien = require 'alien'
local luacom = require "luacom"
local shell32 = alien.load('Shell32.dll')
shell32.ShellExecuteA:types("pointer","pointer","pointer","pointer","pointer","pointer","int")
local exec = shell32.ShellExecuteA
local win = {}

function win.execute_with_shell32(cmd, open)
  if open then
    -- execute opening a window
    exec(0,"open","cmd.exe","/C "..cmd,0,3)
  else
    -- execute, no window opened
    exec(0,"open","cmd.exe","/C "..cmd,0,0)
  end
end

function win.execute_with_com(cmd, open)
  Shell = luacom.CreateObject("WScript.Shell")
  if open then
    Shell:Run ("cmd /C " .. cmd, 0)
  else
    Shell:Run ("cmd /C " .. cmd, 0)
  end
end

return win
