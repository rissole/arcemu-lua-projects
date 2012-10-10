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

function ExecuteChatLua(event, plr, message, type, language)
   PLR = plr
   local startpos, endpos = string.find(message, PREFIX)
   if (startpos == 1 and plr:CanUseCommand("AZ")) then
      local execute_string = message:gsub(PREFIX, "")
      local t = os.date("*t", os.time())
      if (t.hour < 10) then
         t.hour = "0"..t.hour
      end
      if (t.min < 10) then
         t.min = "0"..t.min
      end
      plr:SendBroadcastMessage("|cFFFF0000Executing:|r "..execute_string)
      if (LOGGING) then
         logcol(10)
         print(t.hour..":"..t.min.." "..plr:GetName().." executed Lua: "..execute_string)
         logcol(7)
      end
      loadstring(execute_string)()
      return 0
   end
end

if (GetLuaEngine() == "LuaHypArc" or GetLuaEngine() == "ArcScripts") then
   RegisterServerHook(16, "ExecuteChatLua")
else
   print("LuaEngine: Did not load 'Execute Chat Lua' script - LuaHypArc not installed.")
   print("LuaEngine: Please visit luahyparc.zapto.org for more information.")
end