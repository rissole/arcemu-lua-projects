--------------------
--Execute Chat Lua--
-----hypersniper----
--------------------

--PREFIX: This is to tell the server that this chat message 
--should be executed as Lua. You must put this at the start
--of a chat message for it to be executed as Lua.
--DEFAULT: "@@ "

local PREFIX = "@@ "

--LOGGING: Set this to true if you would like console
--messages every time someone executes chat Lua.
--DEFAULT: true

local LOGGING = true

os.execute = nil --remove this so people can't destroy us
function ExecuteChatLua(event, plr, message, type, language)
   PLR = plr
   SEL = plr:GetSelection()
   plmsg = function(m) PLR:SendBroadcastMessage(m) end
   if (string.find(message, PREFIX) == 1) then
      local execute_string = message:gsub(PREFIX, "")
      local t = os.date("%H:%M")
      plr:SendBroadcastMessage("|cFFFF0000Executing:|r "..execute_string)
      if (LOGGING) then
         logcol(10)
         print(t.." "..plr:GetName().." executed Lua: "..execute_string)
         logcol(7)
      end
      loadstring(execute_string)()
      return 0
   end
end

RegisterServerHook(16, ExecuteChatLua)