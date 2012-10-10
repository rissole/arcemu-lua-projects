function HandlePlayerCommands(event, plr, message, type, language)
	--RELOADING LUA SCRIPTS
	if (message == "#reload") then
		if (plr:IsGm() == true) then
			ReloadLuaEngine()
			plr:SendAreaTriggerMessage("Lua engine reloaded!")
			plr:SendBroadcastMessage("Lua engine reloaded!")
		end
		return 0
	end
	--PRINTING ZONE ID
	if (message == "#zone") then
		if (plr:IsGm() == true) then
			local zone = plr:GetZoneId()
			plr:SendAreaTriggerMessage("Current zone id: "..zone)
			plr:SendBroadcastMessage("Current zone id: "..zone)
		end
		return 1
	end
	--PRINTING AREA ID
	if (message == "#area") then
		if (plr:IsGm() == true) then
			local area = plr:GetAreaId()
			plr:SendAreaTriggerMessage("Current area id: "..area)
			plr:SendBroadcastMessage("Current area id: "..area)
		end
		return 1
	end
	--PRINTING LAND HEIGHT
	if (message == "#lheight") then
		local area = plr:GetLandHeight(plr:GetX(), plr:GetY())
		plr:SendAreaTriggerMessage("Current land height: "..area)
		plr:SendBroadcastMessage("Current land height: "..area)
		return 1
	end
	--PLAYERS IN WORLD
	if (message == "#players") then
		if (plr:IsGm() == true) then
			local players = GetPlayersInWorld()
			for k,v in pairs(players) do
				print(v:GetName())
			end
		end
	end
	--GENDER SWAP
	if (message == "#gender") then
		local gender = plr:GetGender()
		if (gender == 0) then
			plr:SetGender(1)
			plr:SendAreaTriggerMessage("Gender changed to: Female. Please relog to make it take effect.")
		else
			plr:SetGender(0)
			plr:SendAreaTriggerMessage("Gender changed to: Male. Please relog to make it take effect.")
		end
	end
	--GUILD INVITE
	local startpos, endpos = string.find(message, "#ginvite")
    	if (startpos == 1) then --if the message starts with the command
        	local args = {} --setup table
        	string.gsub(message, "(%w+)", function(c) table.insert(args,c) end) --store all words in that table
		local Name = args[2] --the second word should be the name
		plr:SendGuildInvite(GetPlayer(Name))
	end
	--ARCEMU REVISION
	if (message == "#revision") then
		print(GetArcemuRevision())
		plr:SendBroadcastMessage(GetArcemuRevision())
		plr:SendAreaTriggerMessage(GetArcemuRevision())
		return 0
	end
	--JUMP
	if (message == "#jump") then
		plr:Jump(5)
		plr:SendAreaTriggerMessage("Jumped.")
	end
	--[[MAP -> INSTANCE MAP TEST
	if (message == "#iids") then
		local iids = GetInstanceIdsByMap(plr:GetMapId())
		for k,v in pairs(iids) do
			plr:SendAreaTriggerMessage(v)
		end
		plr:SendAreaTriggerMessage("|cffFF0000"..plr:GetInstanceID())
	end]]--
	--CIRCLE DEBUG
	if (message == "#circle") then
           for i=0,20 do
              plr:SpawnCreature(2572, plr:GetX()+60*3*(math.cos(i*17)*math.pi/180), plr:GetY()+60*3*(math.sin(i*17)*math.pi/180), plr:GetZ()+2, plr:GetO(), 35, 0);
           end
	end
	--GO test
	if (message == "#gotest") then
              PerformIngameSpawn(2,181598,plr:GetMapId(),plr:GetX(),plr:GetY(),plr:GetZ(),plr:GetO(),100,0,0,0,0,plr:GetInstanceID())
	end
	--QUERY TEST
	if (message == "#query") then
		local ret = CharDBQueryTable("SELECT online FROM characters WHERE name = 'Locktest'")
		print(ret[1][1])
		plr:PlayerSendChatMessage(1, 0, "Online: "..ret[1][1])
	end
	--PHASE SET TEST
	if (message == "#phase") then
		plr:PhaseSet(1)
	end
	--GUILD LEADER TEST
	if (message == "#glead") then
		plr:SendAreaTriggerMessage(plr:GetGuildLeader())
	end
	--GUILD MEMBER TEST
	if (message == "#gmem") then
		for k,v in pairs(plr:GetGuildMembers()) do
			plr:SendAreaTriggerMessage(v)
		end
	end
end

RegisterServerHook(16, "HandlePlayerCommands")