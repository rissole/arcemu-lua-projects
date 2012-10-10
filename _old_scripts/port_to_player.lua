local P2PPortMessage = "#port"

function OnPortMessage(Event, player, Message, Type, Language)
    local startpos, endpos = string.find(Message, P2PPortMessage)
    if (startpos == 1) then --if the message starts with the command
        local args = {} --setup table
        string.gsub(Message, "(%w+)", function(c) table.insert(args,c) end) --store all words in that table
	local Name = args[2] --the second word should be the name
        local plr = GetPlayer(Name)
	if (plr) then
            	player:Teleport(plr:GetMapId(),plr:GetX(),plr:GetY(),plr:GetZ())
        else
            	player:SendAreaTriggerMessage("Error. Check that the name is correct and that the target is online.")
            	player:SendBroadcastMessage("Error. Check that the name is correct and that the target is online.")
        end
    end
end

if (GetLuaEngine() ~= "LuaHypArc") then
	print("LuaEngine: LuaHypArc is not installed.")
	print("LuaEngine: Please visit http://luahyparc.zapto.org/ for more information.")
else
	RegisterServerHook(16, "OnPortMessage")
end
