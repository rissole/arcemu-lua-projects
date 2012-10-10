--[[
      __                        __  __                  ______                 
     /\ \                      /\ \/\ \                /\  _  \                 
     \ \ \      __  __     __  \ \ \_\ \  __  __  _____\ \ \_\ \  _____  ___   
      \ \ \  __/\ \/\ \  /'__`\ \ \  _  \/\ \/\ \/\ '__`\ \  __ \/\`'__\/'___\  
       \ \ \_\ \ \ \_\ \/\ \_\.\_\ \ \ \ \ \ \_\ \ \ \_\ \ \ \/\ \ \ \//\ \__/  
        \ \____/\ \____/\ \__/ \_\\ \_\ \_\/`____ \ \  __/\ \_\ \_\ \_\\ \____\ 
         \/___/  \/___/  \/__/\/_/ \/_/\/_/`/___// \ \ \/  \/_/\/_/\/_/ \/____/ 
                                              /\___/\ \_\                       
                                              \/__/  \/_/   .zapto.org 
Example 2: Personal weather effects
Utilises "SetPlayerWeather"
]]--
local ITEMID = 75000

function Snowglobe_OnGossipTalk(pUnit, event, player)
	player:SetPlayerWeather(8, 1.5) --snow, 70% intensity
end

--Registering events
if (GetLuaEngine() ~= "LuaHypArc") then --we gotta make sure they're using LuaHypArc!
	print("LuaEngine: Did not load 'Incarcera - Statue Activation' script - LuaHypArc not installed.")
	print("LuaEngine: Please visit http://luahyparc.zapto.org/ for more information.")
else
	RegisterItemGossipEvent(ITEMID, 1, "Snowglobe_OnGossipTalk")
end