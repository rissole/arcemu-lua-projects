-----------------------
--Made by Hypersniper--
-------wow-v.com-------
---For Project Ronin---
-----------------------

local npc1id = 35065
local npc2id = 35066
local npc3id = 35067

RONIN_TELEPORTERS = {}

function RONIN_TELEPORTERS.Tele1_OnGossipTalk(pUnit, event, player)
	pUnit:GossipCreateMenu(85701, player, 0)
	pUnit:GossipMenuAddItem(3, "Eclipse (Western)", 1, 0)
	pUnit:GossipMenuAddItem(3, "Ryuusei (Southern)", 2, 0)
	pUnit:GossipSendMenu(player)
end

function RONIN_TELEPORTERS.Tele2_OnGossipTalk(pUnit, event, player)
	pUnit:GossipCreateMenu(85702, player, 0)
	pUnit:GossipMenuAddItem(3, "Suusei (Northern)", 3, 0)
	pUnit:GossipMenuAddItem(3, "Ryuusei (Southern)", 2, 0)
	pUnit:GossipSendMenu(player)
end

function RONIN_TELEPORTERS.Tele3_OnGossipTalk(pUnit, event, player)
	pUnit:GossipCreateMenu(85703, player, 0)
	pUnit:GossipMenuAddItem(3, "Eclipse (Western)", 1, 0)
	pUnit:GossipMenuAddItem(3, "Suusei (Northern)", 3, 0)
	pUnit:GossipSendMenu(player)
end

function RONIN_TELEPORTERS.OnGossipSelect(pUnit, event, player, id, intid, code)
	if (intid == 1) then
		player:Teleport(1, 2789.6, -354.3, 107.3)
	elseif (intid == 2) then
		player:Teleport(0, -9282.4, -2939.9, 163.9)
	elseif (intid == 3) then
		player:Teleport(0, -910.3, -3528.4, 72.6)
	end
end

RegisterUnitGossipEvent(npc1id, 1, "RONIN_TELEPORTERS.Tele1_OnGossipTalk")
RegisterUnitGossipEvent(npc2id, 1, "RONIN_TELEPORTERS.Tele2_OnGossipTalk")
RegisterUnitGossipEvent(npc3id, 1, "RONIN_TELEPORTERS.Tele3_OnGossipTalk")

RegisterUnitGossipEvent(npc1id, 2, "RONIN_TELEPORTERS.OnGossipSelect")
RegisterUnitGossipEvent(npc2id, 2, "RONIN_TELEPORTERS.OnGossipSelect")
RegisterUnitGossipEvent(npc3id, 2, "RONIN_TELEPORTERS.OnGossipSelect")