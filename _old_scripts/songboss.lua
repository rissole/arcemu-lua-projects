--VERSION: FINAL
--BY HYPERSNIPER @ WOW-V.COM
--[[============\\
  *   Script
  *  Variables
\\*===========]]--

--[[
##########  MODIFIABLE: ##################################

IndividualDPS:
--------------
How much DPS you think each character will do. I made this
incase you have imba funserver items.
Default: 2700 
                                          
##########################################################
]]--

local IndividualDPS = 2700
local lock = 0

local RevenantModelEarth = 27392
local RevenantModelAir   = 26382
local RevenantModelFire  = 25680

local MiniElementAir   = 30418
local MiniElementWater = 30419
local MiniElementFire  = 30416

local Thrall
local Saurfang
local Jaina
local Koronus
local gD={} --alliance peeps
local hG={} --temp horde peeps
local TruePlayers = {} --the people legitly in the battle
local FireThings = {} --tornadoes
local minis = {} --adds
--local attackers = {} --temp mounted attackers }rejected

local TeamForBattle
local ChorusNumber = 1

local UNIT_FLAG_DEFAULT
local FireCount = 0
local waited = 0
local stormSaid = 0



function table.find(t, v)
    if type(t) == "table" and v then
        for k, val in pairs(t) do
            if v == val then
                return k
            end
        end
    end
    return false
end

JAINA = {}
JAINA.POOP = {}

--[[============\\
  *  Declaring
  *    Units
\\*===========]]--

function JAINA.POOP.declare(unit, event)
	Jaina = unit
	Jaina:EquipWeapons(2177, 0, 0)
end

function Saurfang_declare(unit, event)
	Saurfang = unit
	Saurfang:EquipWeapons(21580, 0, 0)
	Saurfang:SetPowerType("rage")
end

function Thrall_declare(unit, event)
	Thrall = unit
	Thrall:EquipWeapons(14533, 0, 0)
	if (Thrall:GetZ() < 150) then --if not on platform
		Thrall:RegisterEvent("PreFight_Chat", 60000, 0)
	end
end

function Koronus_declare(unit, event)
	Koronus = unit
	unit:SetOutOfCombatRange(2370)
	UNIT_FLAG_DEFAULT = unit:GetUInt64Value(UNIT_FIELD_FLAGS)
	--unit:SetCombatCapable(1)
	unit:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_2)
end

--These two functions give the soldiers mounts+weps.

function MountedAlliance_setup(unit, event)
	if (unit:GetZ() < 150) then --if not up on the platform yet
		unit:SetUInt32Value( UNIT_FIELD_MOUNTDISPLAYID , 14332)
	end
	unit:EquipWeapons(41791, 35779, 41791)
end

function MountedHorde_setup(unit, event)
	unit:SetUInt32Value( UNIT_FIELD_MOUNTDISPLAYID , 14573)
	unit:EquipWeapons(43296, 0, 0)--40607
end

function Tornado_setup(unit, event)
	unit:SetScale(2.5)
	unit:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE)
	unit:SetCombatMeleeCapable(1)
	unit:CastSpell(56620)
	unit:RegisterEvent("Tornado_DEATH", 6900, 1)
end



--[[============\\
  *   Leader
  *   Gossip
\\*===========]]--

function Jaina_OnGossip(unit, event, player)
	unit:GossipCreateMenu(100, player, 0)
	unit:GossipMenuAddItem(0, "Thrall's situation seemed dire, therefore the Alliance will serve in this battle.", 0, 0)
	unit:GossipSendMenu(player)
end

function AllLeaders_OnSubmenu(unit, event, player, id, intid, code)
	if (intid == 0) then
		unit:SendChatMessageToPlayer(15,0,"Whispering to you", player)
		--unit:PlaySpellVisualByRawGUID(unit:GetRawGUID(),1449)
		--local vehicle = player:SpawnVehicle(32627,player:GetX(),player:GetY(),player:GetZ(),player:GetO(),35,0)
		--player:SetVehicle(vehicle,-1)
		--player:SendLootWindow(unit:GetRawGUID(),1)
		player:GossipComplete()
	elseif (intid == 1) then
		Thrall:RemoveEvents()
		TeamForBattle = player:GetTeam()
		Thrall:SendChatMessage(12, 0, "Good. Jaina! Please teleport us to the Alter. The time has come.")
		player:GossipComplete()
		Jaina:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
		Thrall:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
		Saurfang:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
		Thrall:RegisterEvent("Koronus_begin1", 3000, 1)
	end
end

function Saurfang_OnGossip(unit, event, player)
	unit:GossipCreateMenu(100, player, 0)
	unit:GossipMenuAddItem(0, "This corrupted element must be destroyed. My axe yearns to cleave it's monsterous form.", 0, 0)
	unit:GossipSendMenu(player)
end

function Thrall_OnGossip(unit, event, player)
	unit:GossipCreateMenu(100, player, 0)
	unit:GossipMenuAddItem(0, "I'm ready to begin the battle, Thrall. Take us to the Alter of the Storms!", 1, 0)
	unit:GossipSendMenu(player)
end



--[[============\\
  *  Pre-fight
  *    chat
\\*===========]]--

function PreFight_Chat(unit, event)
	local pick = math.random(1,3)
	if (pick == 1) then
		Saurfang:RegisterEvent("Saurfang_Rally", 500, 1)
	elseif (pick == 2) then
		Jaina:RegisterEvent("Jaina_AnnoyedSoldiers1", 500, 1)
	elseif (pick == 3) then
		Thrall:RegisterEvent("Thrall_ConsultSaurfang1", 500, 1)
	end
end

function Saurfang_Rally(unit, event)
	local Friends = Saurfang:GetInRangeFriends()
	Saurfang:Emote(5, 1500)
	Saurfang:SendChatMessage(14, 0, "War-Brothers of the Horde! Revel in your glory! You are here to fight for the Warchief!")
	Saurfang:PlaySoundToSet(math.random(8573,8574))
	for i=1, #Friends do
	--loops through all friends in range
		if (Friends[i]:GetName() == "Horde War-Brother") then
			Friends[i]:Emote(4, 3000)
		end
	end
end

function Jaina_AnnoyedSoldiers1(unit, event)
	local Friends = Jaina:GetInRangeFriends()
	for i=1, #Friends do
		if (Friends[i]:GetName() == "Alliance Ranger") then
			Friends[i]:Emote(1, 1500)
			Friends[i]:SendChatMessage(12, 0, "I can't believe we have to fight alongside the horde. These orcs are disgust-")
			break
		end
	end
	Jaina:RegisterEvent("Jaina_AnnoyedSoldiers2", 1500, 1)
end

function Jaina_AnnoyedSoldiers2(unit, event)
	Jaina:Emote(1, 1500)
	Jaina:SendChatMessage(12, 0, "Silence, soldier! The Alliance has a pact with Thrall. We will help his cause!")
end

function Thrall_ConsultSaurfang1(unit, event)
	--These SetUInt64Values temporarily disable gossip.

	Thrall:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
	Saurfang:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
	Thrall:MoveTo(Saurfang:GetX()+2, Saurfang:GetY()-2, Saurfang:GetZ(), Thrall:CalcRadAngle(Thrall:GetX(), Thrall:GetY(), Saurfang:GetX(), Saurfang:GetY()))
	Thrall:SendChatMessage(12, 0, "Saurfang, do you agree with sending so many Horde to the battle?")
	Thrall:RegisterEvent("Thrall_ConsultSaurfang2", 5000, 1)
end


function Thrall_ConsultSaurfang2(unit, event)
	Saurfang:SendChatMessage(12, 0, "Remember Thrall, we are not mindless barbarians.")
	Thrall:SetFacing(Thrall:CalcRadAngle(Thrall:GetX(), Thrall:GetY(), Saurfang:GetX(), Saurfang:GetY()))
	Saurfang:SetFacing(Saurfang:CalcRadAngle(Saurfang:GetX(), Saurfang:GetY(), Thrall:GetX(), Thrall:GetY()))
	Saurfang:Emote(1,1500)
	Thrall:RegisterEvent("Thrall_ConsultSaurfang3", 2500, 1)
end

function Thrall_ConsultSaurfang3(unit, event)
	Saurfang:SendChatMessage(12, 0, "The plan will prove sound. We have accounted for minimal fatalities.")
	Saurfang:Emote(1,1500)
	Thrall:RegisterEvent("Thrall_ConsultSaurfang4", 3500, 1)
end

function Thrall_ConsultSaurfang4(unit, event)
	Thrall:SendChatMessage(12, 0, "Excellent. Continue with preparations.")
	Thrall:Emote(1,1500)
	Thrall:RegisterEvent("Thrall_ConsultSaurfang5", 3500, 1)
end

function Thrall_ConsultSaurfang5(unit, event)
	Thrall:SetUInt64Value(UNIT_NPC_FLAGS, 0x01)
	Saurfang:SetUInt64Value(UNIT_NPC_FLAGS, 0x01)
	Thrall:ReturnToSpawnPoint()
	Saurfang:SetFacing(Saurfang:GetSpawnO())
end



--[[============\\
  *  Pre-Boss
  *   Begin
\\*===========]]--

function Koronus_begin1(unit, event)
	Jaina:SendChatMessage(12, 0, "I hope you are all prepared.")
	Jaina:MoveTo(-2351.262783, 8495.782227, -30.346930, 0)
	Jaina:RegisterEvent("Koronus_begin2", 5500, 1)
end

function Koronus_begin2(unit, event)
	Jaina:MoveTo(-2328.521729, 8502.351563, -22.891079, 0)
	Jaina:RegisterEvent("Koronus_begin3", 10000, 1)
end

function Koronus_begin3(unit, event)
	Jaina:MoveTo(-2323.301758, 8512.899414, -17.171537, 1)
	Jaina:RegisterEvent("Koronus_begin4", 6000, 1)
end

function Koronus_begin4(unit, event)
	Jaina:SendChatMessage(12, 0, "Here we go.")
	Jaina:FullCastSpell(61225) --teleporting visual
	Jaina:RegisterEvent("Koronus_begin5", 4100, 1)
end

function Koronus_begin5(unit, event)
	--Teleporting of players and moving of NPCs...
	local Players = Jaina:GetInRangePlayers()
	for i=1, #Players do
		if (Players[i]:GetTeam() == TeamForBattle and Jaina:GetDistance(Players[i]) <= 1800) then --60 yards
			Players[i]:Teleport(530, math.random(-2506.200195,-2468.098145), math.random(8608.417969,8642.384766), 198.438644)
			table.insert(TruePlayers, Players[i])
		end
	end
	local Friends = Jaina:GetInRangeFriends()
	for i=1, #Friends do
		if (Friends[i]:GetName() == "Alliance Ranger" or Friends[i]:GetName() == "Horde War-Brother") then
			Friends[i]:Despawn(0, 360000)
		end
	end
	Thrall:Despawn(0, 360000)
	Thrall = unit:SpawnCreature(84772, -2511.841309, 8628.771484, 192.430511, 2.000413, 35, 0)
	Saurfang:Despawn(0, 360000)
	Saurfang = unit:SpawnCreature(84773, -2482.980713, 8645.184570, 192.340607, 2.085236, 35, 0)
	Jaina = unit:SpawnCreature(84774, -2529.223145, 8611.981445, 189.866821, 1.407439, 35, 0)
	unit:Despawn(0, 360000)
	Jaina:RegisterEvent("Koronus_begin6", 500, 1)
	Thrall:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
	Saurfang:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
	Jaina:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
end

function Koronus_begin6(unit, event)
	gD[1] = Jaina:SpawnCreature(84775, Jaina:GetX()-10, Jaina:GetY(), Jaina:GetZ(), Jaina:GetO(), 35, 0)
	gD[2] = Jaina:SpawnCreature(84775, Jaina:GetX()-5, Jaina:GetY(), Jaina:GetZ(), Jaina:GetO(), 35, 0)
	gD[3] = Jaina:SpawnCreature(84775, Jaina:GetX()+10, Jaina:GetY(), Jaina:GetZ(), Jaina:GetO(), 35, 0)
	gD[4] = Jaina:SpawnCreature(84775, Jaina:GetX()+5, Jaina:GetY(), Jaina:GetZ(), Jaina:GetO(), 35, 0)
	gD[5] = Jaina:SpawnCreature(84775, Jaina:GetX()+5, Jaina:GetY()-5, Jaina:GetZ(), Jaina:GetO(), 35, 0)
	gD[6]= Jaina:SpawnCreature(84775, Jaina:GetX()-5, Jaina:GetY()-5, Jaina:GetZ(), Jaina:GetO(), 35, 0)
	Thrall:EquipWeapons(14533, 0, 0)
	Saurfang:EquipWeapons(21580, 0, 0)
	Jaina:EquipWeapons(2177, 0, 0)
	Saurfang:SetPowerType("rage")
	Jaina:RegisterEvent("Koronus_fight1", 10000, 1) --this gives ample time for teleport laggers.
end



--[[============\\
  *    Boss
  *   events
\\*===========]]--
--Timing throughout is critical

function Koronus_fight1(unit, event)
	Diffo = #TruePlayers-20
	if (Diffo > 0) then
		Koronus:SetMaxHealth(IndividualDPS*314*(15+Diffo)+1000000) --accounts for extra people coming if they want to.
		Koronus:SetHealth(Koronus:GetMaxHealth())        --extra mill HP to account for NPC damage
	else
		Koronus:SetMaxHealth(IndividualDPS*314*15+1000000)
		Koronus:SetHealth(Koronus:GetMaxHealth())
	end
	Thrall:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_2)
	Saurfang:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_2)
	Jaina:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_2)
	Koronus:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_DEFAULT)
	Koronus:Root()
	Koronus:SetCombatCapable(0)
	Koronus:PlaySoundToSet(11803) --begin the song!
	Koronus:SendChatMessage(14, 0, "Storm, earth, and fire...")
	Koronus:RegisterEvent("Koronus_fight2", 2500, 1)
end

function Koronus_fight2(unit, event)
	Koronus:SendChatMessage(14, 0, "Heed my call")
	Koronus:Unroot()
	local plr = Koronus:GetRandomPlayer(0)
	Koronus:AttackReaction(plr, 1, 0) --creates threat
	Thrall:RegisterEvent("Fight_Friendly_chat1", 2000, 1)
	--Song at 0:025
end

function Fight_Friendly_chat1(unit, event)
	Thrall:Emote(45, 16000) --ready weapons
	Saurfang:Emote(45, 16000)
	Jaina:Emote(45, 16000)
	Thrall:SendChatMessage(14, 0, "This has gone on long enough.")
	Thrall:RegisterEvent("Fight_Friendly_chat2", 2000, 1)
	--Song at 0:045
end

function Fight_Friendly_chat2(unit, event)
	Jaina:SendChatMessage(14, 0, "From this day, the spirits shall be disturbed no more.")
	Thrall:RegisterEvent("Fight_Friendly_chat3", 2000, 1)
	--Song at 0:065
end

function Fight_Friendly_chat3(unit, event)
	Saurfang:SendChatMessage(14, 0, "Come on, old friend. Let's finish this!")
	Thrall:RegisterEvent("Fight_Friendly_chat4", 2000, 1)
	--Song at 0:085
end

function Fight_Friendly_chat4(unit, event)
	Jaina:SendChatMessage(14, 0, "Heroes, the Rangers and I will assist from over here. Destroy Koronus!")
	Thrall:RegisterEvent("Fight_Friendly_chat5", 3000, 1)
	--Song at 0:105
end

function Fight_Friendly_chat5(unit, event)
	Thrall:SendChatMessage(14, 0, "Saurfang, what about the other horde forces?")
	Thrall:RegisterEvent("Fight_Friendly_chat6", 2000, 1)
	--Song at 0:135
end

function Fight_Friendly_chat6(unit, event)
	Saurfang:SendChatMessage(14, 0, "They will come when the time is needed. For now we must Fight!")
	Thrall:RegisterEvent("Fight_Friendly_chat7", 3000, 1)
	--Song at 0:155
end

function Fight_Friendly_chat7(unit, event)
	Thrall:SendChatMessage(14, 0, "On with it!")
	Thrall:AttackReaction(Koronus, 1, 0) --creates threat
	Saurfang:AttackReaction(Koronus, 1, 0)
	Jaina:ModifyWalkSpeed(10)
	Jaina:MoveTo((Jaina:GetX()+Koronus:GetX())/2, (Jaina:GetY()+Koronus:GetY())/2, Jaina:GetZ()+2, Jaina:GetO()) --midpoint
	Jaina:RegisterEvent("Jaina_BattleLoop", 1000, 1)
	Saurfang:RegisterEvent("Saurfang_BattleLoop", 1000, 1)
	Thrall:RegisterEvent("Thrall_BattleLoop", 1000, 1)
	Koronus:RegisterEvent("Koronus_GeneralActions", 100, 1)
	Koronus:RegisterEvent("Koronus_ThreatRemover", 500, 0)
	for k,v in pairs(gD) do
		v:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_2)
		v:SetCombatMeleeCapable(1)
		v:AttackReaction(Koronus, 1, 0)
		v:EquipWeapons(35779, 35779, 27987)--41791
	end
	Koronus:RegisterEvent("Koronus_sing1", 25700, 1)
	--Song at 0:185
end

function Koronus_sing1(unit, event)
	Koronus:SendChatMessage(14, 0, "I am the son of the wind and rain...")
	Koronus:RegisterEvent("Koronus_sing2", 2800, 1)
	--Song at 0:442
end

function Koronus_sing2(unit, event)
	Koronus:SendChatMessage(14, 0, "Thunder beckons and I heed the call")
	Koronus:RegisterEvent("Koronus_sing3", 4000, 1)
	--Song at 0:47
end

function Koronus_sing3(unit, event)
	Saurfang:SendChatMessage(14, 0, "And if I die upon this day")
	Koronus:RegisterEvent("Koronus_sing4", 2700, 1)
	--Song at 0:51
end

function Koronus_sing4(unit, event)
	Saurfang:SendChatMessage(14, 0, "In battle I will fall")
	Koronus:RegisterEvent("Koronus_sing5", 3900, 1)
	--Song at 0:537
end

function Koronus_sing5(unit, event)
	Thrall:SendChatMessage(14, 0, "Hear me brothers gather up the wolves")
	hG[1] = Thrall:SpawnCreature(84776, Thrall:GetX()-20, Thrall:GetY()-20, Thrall:GetZ()+2, Thrall:GetO(), 35, 20000)
	hG[2] = Thrall:SpawnCreature(84776, Thrall:GetX()+20, Thrall:GetY()+20, Thrall:GetZ()+2, Thrall:GetO(), 35, 20000)
	for i=1, #hG do
		hG[i]:ModifyWalkSpeed(10)
		hG[i]:CreateWaypoint(Koronus:GetX(), Koronus:GetY(), Koronus:GetZ(), 0, 0, 0, 0)
		hG[i]:MoveToWaypoint(1)
		hG[i]:RegisterEvent("MountedHorde_setup", 100, 1)
	end
	Koronus:RegisterEvent("Koronus_sing6", 3000, 1)
	--Song at 0:576
end

function Koronus_sing6(unit, event)
	Thrall:SendChatMessage(14, 0, "To battle we will ride")
	hG[1]:AttackReaction(Koronus, 1, 0)	
	hG[2]:AttackReaction(Koronus, 1, 0)
	Koronus:RegisterEvent("Koronus_chorus", 10400, 1)
	--Song at 1:006
end

function Koronus_chorus(unit, event)
	Koronus:CastSpell(686) --tag#2
	Koronus:RemoveEvents()
	Koronus:RegisterEvent("Koronus_ThreatRemover", 500, 0)
	Koronus:SetModel(RevenantModelAir)
	Koronus:SetScale(2)
	Koronus:SendChatMessage(42, 0, "STORM!")
	for k,v in pairs(TruePlayers) do
		Koronus:CastSpellAoF(v:GetX(), v:GetY(), v:GetZ(), 48467) --hurricane
		Koronus:SetMana(Koronus:GetMaxMana())
	end
	Koronus:RegisterEvent("Koronus_chorus2", 3500, 1)
	--song at 1:11
end

function Koronus_chorus2(unit, event)
	Koronus:SetModel(RevenantModelEarth)
	Koronus:SetScale(1)
	Koronus:SendChatMessage(42, 0, "EARTH!")
	Koronus:CastSpell(29584) --demoralizing shout
	Koronus:RegisterEvent("Koronus_chorus3", 3500, 1)
	--Gettin the fire 'nadoes ready
	FireThings[1] = Koronus:SpawnCreature(24187, -2518.656494, 8692.708008, 188.344040, 0, 14, 60000)
	FireThings[2] = Koronus:SpawnCreature(24187, -2499.851074, 8688.147461, 188.422668, 0, 14, 60000)
	FireThings[3] = Koronus:SpawnCreature(24187, -2482.028809, 8674.066406, 188.765854, 0, 14, 60000)
	FireThings[4] = Koronus:SpawnCreature(24187, -2468.102051, 8655.274414, 189.920181, 0, 14, 60000)
	FireThings[5] = Koronus:SpawnCreature(24187, -2455.039765, 8637.519531, 189.571823, 0, 14, 60000)
	FireThings[6] = Koronus:SpawnCreature(24187, -2460.225342, 8616.057617, 190.883118, 0, 14, 60000)
	FireThings[7] = Koronus:SpawnCreature(24187, -2486.437012, 8601.309570, 190.703186, 0, 14, 60000)
	FireThings[8] = Koronus:SpawnCreature(24187, -2512.316650, 8603.036133, 190.595291, 0, 14, 60000)
	FireThings[9] = Koronus:SpawnCreature(24187, -2529.263184, 8614.866211, 190.250366, 0, 14, 60000)
	FireThings[10]= Koronus:SpawnCreature(24187, -2542.627441, 8630.514648, 190.693710, 0, 14, 60000)
	FireThings[11]= Koronus:SpawnCreature(24187, -2546.004639, 8653.689453, 190.190063, 0, 14, 60000)
	FireThings[12]= Koronus:SpawnCreature(24187, -2538.928711, 8685.987305, 188.051346, 0, 14, 60000)
	--song at 1:14
end

function Koronus_chorus3(unit, event)
	Koronus:SetModel(RevenantModelFire)
	Koronus:SetScale(1)
	Koronus:SendChatMessage(42, 0, "FIRE!")
	Koronus:RegisterEvent("Koronus_chorus4", 3400, 1)
	--song at 1:175
end

function Tornado_DEATH(unit, event)
	unit:MoveTo(-2505.679932, 8643.129883, 192.942993, 0)
	unit:Despawn(13000, 0) --tag#1	
	--song at 1:209
end

function Koronus_chorus4(unit, event)
	Koronus:SendChatMessage(42, 0, "DEATH!")
	Koronus:RegisterEvent("Koronus_GeneralActions", 1000, 1)
	if (ChorusNumber == 1) then
		Thrall:RegisterEvent("Friendly_chat8", 4100, 1)
		ChorusNumber = 2
	elseif (ChorusNumber == 2) then
		Koronus:RegisterEvent("Saurfang_part1", 6000, 1)
		ChorusNumber = 3
	elseif (ChorusNumber == 3) then
		Koronus:RegisterEvent("Koronus_wipethem", 3500, 1)
	end
	--song at 1:209
end

function Friendly_chat8(unit, event)
	Koronus:StopChannel()
	Koronus:CastSpell(686) --tag#2
	Thrall:SendChatMessage(14, 0, "Koronus has a mastery of the Elements almost as near as our greatest shamans and druids. Remain aware, heroes.")
	Thrall:RegisterEvent("Friendly_chat9", 4500, 1)
	--song at 1:25
end

function Friendly_chat9(unit, event)
	Saurfang:SendChatMessage(14, 0, "We shall fight until he is stopped for good.")
	Thrall:RegisterEvent("Koronus_sing7", 8500, 1)
	--song at 1:29
end

function Koronus_sing7(unit, event)
	Thrall:SendChatMessage(14, 0, "Far-seer to the Warsong clan")
	Thrall:RegisterEvent("Koronus_sing10", 2500, 1)
	--song at 1:375
end

function Koronus_sing10(unit, event)
	Thrall:SendChatMessage(14, 0, "To no man will I yield.")
	Thrall:RegisterEvent("Koronus_sing11", 4000, 1)
	--song at 1:40
end

function Koronus_sing11(unit, event)
	Saurfang:SendChatMessage(14, 0, "Feel the power and the energy")
	Thrall:RegisterEvent("Koronus_sing12", 2900, 1)
	--song at 1:44
end

function Koronus_sing12(unit, event)
	Saurfang:SendChatMessage(14, 0, "For the black god, honour, and steel")
	Thrall:RegisterEvent("Koronus_sing13", 6100, 1)
	--song at 1:469
end

function Koronus_sing13(unit, event)
	Koronus:SendChatMessage(14, 0, "Lightning strikes...")
	Koronus:FullCastSpellOnTarget(59273, Koronus:GetRandomPlayer(0)) --chain lightning
	Thrall:RegisterEvent("Koronus_sing14", 1000, 1)
	--song at 1:53
end

function Koronus_sing14(unit, event)
	Koronus:SendChatMessage(14, 0, "At my command.")
	Koronus:RegisterEvent("Koronus_chorus", 10000, 1)
	--song at 1:54
end

function Koronus_ThreatRemover(unit, event) --called threat remover but really handles all "on tick" stuff
	Thrall:AttackReaction(Koronus, 1, 0) --creates threat
	Saurfang:AttackReaction(Koronus, 1, 0)
	local rand = Koronus:GetRandomPlayer(0)
	Koronus:AttackReaction(rand, 1, 0) --attempt to keep in combat
	Koronus:ModThreat(Thrall, -10000) --these make it so Koronus doesn't attack npcs
	Koronus:ModThreat(Saurfang, -10000)
	Koronus:ModThreat(Jaina, -10000)
	for k,v in pairs(gD) do
		Koronus:ModThreat(v, -10000)
	end
	if (Koronus:GetInRangePlayersCount() > #TruePlayers) then --someone unwanted is here
		local currentplayers = Koronus:GetInRangePlayers()
		for k,v in pairs(currentplayers) do
			if (table.find(TruePlayers, v) == false) then --oh jeez they not original player.
				Koronus:SendChatMessage(15, 0, "You will not interrupt this, insolent pest!", v)
				v:Dismount()
				Koronus:FullCastSpellOnTarget(33382, v) --jump-a-tron spell
			end
		end
	end
end

function Saurfang_part1(unit, event)
	Koronus:RemoveEvents()
	Koronus:StopChannel()
	Koronus:CastSpell(686) --tag#2
	Koronus:Root()
	Koronus:SetCombatCapable(1)
	--Saurfang:ClearThreatList()
	Koronus:RegisterEvent("Koronus_ThreatRemover", 500, 0)
	Thrall:SendChatMessage(14, 0, "THIS IS IT! HEROES, DRINK IN YOUR MIGHT!")
	for k,v in pairs(TruePlayers) do
		for i=1,5 do
			v:CastSpell(58549) --tenacity
		end
	end
	--Koronus:MoveTo(-2460.225342, 8616.057617, 190.883118, 5.873978)
	Saurfang:RegisterEvent("Saurfang_part2", 1000, 0)
	Saurfang:RegisterEvent("Spawn_minis", 3000, 0)
	Saurfang:RegisterEvent("Spawn_minis2", 10000, 0)
	Koronus:RegisterEvent("Koronus_returntofight", 60000, 1)
	--Koronus:RegisterEvent("Koronus_cleave1", 10000, 1) } rejected idea
	--song at 2:20
	Koronus:Emote(64,60000)
	Saurfang:SendChatMessage(42, 0, "Koronus becomes weak from exhaustion!")
	Saurfang:SendChatMessage(14, 0, "Strike now while Koronus is weak. I'll handle these minions.")
end

function Koronus_returntofight(unit, event)
	Koronus:SendChatMessage(42, 0, "Koronus revives!")
	Koronus:Unroot()
	Koronus:SetCombatCapable(0)
	local plr = Koronus:GetRandomPlayer(0)
	Koronus:AttackReaction(plr, 1, 0) --creates threat
	Koronus:RegisterEvent("Koronus_GeneralActions", 1000, 1)
end

function Spawn_minis(unit, event)
	minis[1]=Koronus:SpawnCreature(MiniElementAir, -2491.417236, 8631.875000, 193.269913, 5.633650, 14, 4000)
	minis[2]=Koronus:SpawnCreature(MiniElementWater, -2487.417236, 8631.875000, 193.269913, 5.633650, 14, 4000)
	minis[3]=Koronus:SpawnCreature(MiniElementFire, -2496.417236, 8631.875000, 193.269913, 5.633650, 14, 4000)
	for i=1,3 do
		minis[i]:AttackReaction(Saurfang, 10000, 0)
		Saurfang:AttackReaction(minis[i], 5000, 0)
	end
end

function Spawn_minis2(unit, event)
	minis[4]=Koronus:SpawnCreature(MiniElementAir, -2491.417236, 8631.875000, 193.269913, 5.633650, 14, 11000)
	minis[5]=Koronus:SpawnCreature(MiniElementWater, -2487.417236, 8631.875000, 193.269913, 5.633650, 14, 11000)
	minis[6]=Koronus:SpawnCreature(MiniElementFire, -2496.417236, 8631.875000, 193.269913, 5.633650, 14, 11000)
	for i=4,6 do
		minis[i]:SetHealthPct(50)
		minis[i]:AttackReaction(unit:GetRandomPlayer(0), 10000, 0)
	end
end

function Saurfang_part2(unit, event)
	if (waited >=58000) then
		Saurfang:RegisterEvent("Saurfang_part3", 100, 1)
		waited = -99999999
	else
		waited = waited+1000
	end
	Saurfang:MoveTo(-2491.417236, 8629.875000, 193.269913, 0)
	Saurfang:CastSpell(61076) --whirlwind
	--song at 2:21
	--change at 3:23
end

function Saurfang_part3(unit, event)
	Saurfang:SendChatMessage(14, 0, "Surrounded by the enemy")
	Saurfang:RegisterEvent("Saurfang_part4", 3000, 1)
	--song at 3:23
end

function Saurfang_part4(unit, event)
	Saurfang:SendChatMessage(14, 0, "The wolf among the hounds")
	Saurfang:RegisterEvent("Saurfang_part5", 4000, 1)
	--song at 3:26
end

function Saurfang_part5(unit, event)
	Saurfang:SendChatMessage(14, 0, "Thunder turns to silence, it took")
	Saurfang:RegisterEvent("Saurfang_part6", 2900, 1)
	--song at 3:30
end

function Saurfang_part6(unit, event)
	Saurfang:SendChatMessage(14, 0, "The hundred to bring me down.")
	Saurfang:RegisterEvent("Saurfang_part7", 4000, 1)
	--song at 3:329
end

function Saurfang_part7(unit, event)
	Saurfang:SendChatMessage(14, 0, "Wolf-Brothers falling at my side,")
	Saurfang:RegisterEvent("Saurfang_part8", 2600, 1)
	--song at 3:369
end

function Saurfang_part8(unit, event)
	Saurfang:SendChatMessage(14, 0, "With honour, I WILL DIE!")
	local sX = Saurfang:GetX()
	local sY = Saurfang:GetY()
	local sZ = Saurfang:GetZ()
	--Saurfang:SetDeathState(2)
	Koronus:Kill(Saurfang)
	Jaina:RemoveEvents()
	Jaina:ModifyWalkSpeed(2)
	Jaina:MoveTo(sX, sY, sZ, 0)
	Saurfang:RemoveEvents()
	Jaina:RegisterEvent("Saurfang_part9", 8500, 1)
	--song at 3:395
end

function Saurfang_part9(unit, event)
	Jaina:CastSpell(58854) --resurrection visual
	Saurfang:SetHealth(2000000)
	Saurfang:CastSpell(58854) --resurrection visual
	Saurfang:SetDeathState(0)
	Saurfang:SetCombatCapable(0)
	Saurfang:AttackReaction(Koronus, 500000, 0)
	--[[for k,v in pairs(minis) do
		Saurfang:FullCastSpellOnTarget(24573, v) --big mortal strike
		Saurfang:Kill(v)
	end]]--
	Saurfang:RegisterEvent("Saurfang_BattleLoop", 1000, 1)
	Jaina:RegisterEvent("Jaina_BattleLoop", 1000, 1)
	Koronus:RegisterEvent("Koronus_chorus", 1500, 1)
	Jaina:SetFacing(Jaina:CalcRadAngle(Jaina:GetX(), Jaina:GetY(), Koronus:GetX(), Koronus:GetY()))
	--song at 3:48
	--chorus at 3:495
end

function Koronus_wipethem(unit, event)
	Koronus:RegisterEvent("Koronus_STORM", 1000, 0)
	Koronus:RegisterEvent("Koronus_EARTH", 3000, 1)
	Koronus:RegisterEvent("Koronus_FIRE",  6500, 1)
	Koronus:RegisterEvent("Koronus_DEATH", 9500, 1)
end

function Koronus_STORM(unit, event)
	if (stormSaid == 0) then
		Koronus:SendChatMessage(42, 0, "STORM!")
		stormSaid = 1
	end
	Koronus:FullCastSpellOnTarget(50830, Koronus:GetRandomPlayer(0)) --chain lightning
end

function Koronus_EARTH(unit, event)
	for k,v in pairs(gD) do
		Koronus:Kill(v)
	end
	Koronus:SendChatMessage(42, 0, "EARTH!") --earthquake
	Koronus:CastSpell(55101)
end

function Koronus_FIRE(unit, event)
	Koronus:SendChatMessage(42, 0, "FIRE!")
	for k,v in pairs(TruePlayers) do
		Koronus:CastSpellAoF(v:GetX(), v:GetY(), v:GetZ(), 54099) --rain of fire
	end
end

function Koronus_DEATH(unit, event)
	Koronus:SendChatMessage(42, 0, "DEATH!")
	for k,v in pairs(TruePlayers) do
		Koronus:CastSpellAoF(v:GetX(), v:GetY(), v:GetZ(), 56359) --death and decay
	end
	Koronus:RegisterEvent("Koronus_itsover", 26000, 1)
end

--[[
rejected idea
function Koronus_cleave1(unit, event)
	Koronus:RegisterEvent("Koronus_cleave2", 2000, 0)
	--song at 2:30
end

function Koronus_cleave2(unit, event)
	waited = waited+2000
	if (waited >= 48000) then
		Koronus:RemoveEvents()
		Koronus:SetCombatCapable(0)
		local randy = Koronus:GetRandomPlayer(0)
		Koronus:AttackReaction(randy,20,0)
		Koronus:RegisterEvent("Koronus_ThreatRemover", 500, 0)
		Koronus:RegisterEvent("Koronus_GeneralActions", 500, 1)
	end
	attackers[1] = Koronus:SpawnCreature(84776, -2442.296387, 8605.511719, 188.217224, 2.642066, 35, 2000)
	attackers[2] = Koronus:SpawnCreature(84776, -2448.343994, 8594.429688, 189.120056, 2.642066, 35, 2000)
	attackers[3] = Koronus:SpawnCreature(84776, -2436.991455, 8615.233398, 187.367386, 2.642066, 35, 2000)
	Koronus:CastSpell(845) --cleave
	for k,v in pairs(attackers) do 
		v:SetUInt32Value( UNIT_FIELD_MOUNTDISPLAYID , 14573)
		v:ModifyWalkSpeed(7)
		v:MoveTo(Koronus:GetX(), Koronus:GetY(), Koronus:GetZ(), v:GetO())
	end
	Koronus:RegisterEvent("Koronus_cleave3", 1000, 1)
end

function Koronus_cleave3(unit, event)
	for k,v in pairs(attackers) do 
		v:CastSpell(33382) --jump-a-tron
	end
	--cleaves need to end at 3:20. 48 sec worth
end
]]--



--[[============\\
  *  Functions
  *   combat
\\*===========]]--

--[[function Alliance_range(unit, event) --zzOld
	unit:FullCastSpellOnTarget(6660, Koronus) --shoot bow
end]]--

function Koronus_GeneralActions(unit, event)
	Koronus:RegisterEvent("Koronus_spell1", 3000, 0)
	Koronus:RegisterEvent("Koronus_spell2", 8000, 0)
	Koronus:RegisterEvent("Koronus_spell3", 12000, 0)
end

function Koronus_spell1(unit, event)
	Koronus:SetModel(RevenantModelEarth)
	Koronus:SetScale(1)
	Koronus:CastSpell(39047) --cleave
end

function Koronus_spell2(unit, event)
	Koronus:SetModel(RevenantModelAir)
	Koronus:SetScale(2)
	local randy = Koronus:GetRandomPlayer(0)
	if (Koronus:GetCurrentSpellId() == nil) then
		Koronus:FullCastSpellOnTarget(59024, randy) --lightning bolt
	end
end

function Koronus_spell3(unit, event)
	Koronus:SetModel(RevenantModelFire)
	Koronus:SetScale(1)
	Koronus:CastSpell(38536) --blast wave
end

function Jaina_BattleLoop(unit, event)
	FireCount = 0
	Jaina:RegisterEvent("Jaina_spell_fire", 2000, 3)
end

function Jaina_spell_fire(unit, event)
	Jaina:RemoveAllAuras()
	local rand = math.random(1,2)
	if (rand == 1) then
		Jaina:FullCastSpellOnTarget(44237, Koronus) --fire ball
	else
		Jaina:FullCastSpellOnTarget(57376, Koronus) --holy bolt
	end
	FireCount = FireCount+1
	if (FireCount == 3) then
		Jaina:RegisterEvent("Jaina_spell_arcane", 2000, 1)
	end
end

function Jaina_spell_arcane(unit, event)
	FireCount = 0
	Jaina:CastSpell(51019) --arcane visual
	Jaina:FullCastSpellOnTarget(44781, Koronus) --arcane barrage
	Jaina:SetMana(Jaina:GetMaxMana())
	Jaina:RegisterEvent("Jaina_spell_fire", 2000, 3)
end

function Saurfang_BattleLoop(unit, event)
	Saurfang:RegisterEvent("Saurfang_spell1", 6000, 0)
	Saurfang:RegisterEvent("Saurfang_spell2", 13000, 0)
end

function Saurfang_spell1(unit, event)
	Saurfang:FullCastSpellOnTarget(39171, Koronus) --mortal strike
end

function Saurfang_spell2(unit, event)
	Saurfang:FullCastSpellOnTarget(56352, Koronus) --"storm punch"
end

function Thrall_BattleLoop(unit, event)
	Thrall:RegisterEvent("Thrall_spell1", 6000, 0)
	Thrall:RegisterEvent("Thrall_spell2", 13000, 0)
end

function Thrall_spell1(unit, event)
	Thrall:FullCastSpellOnTarget(51876, Koronus) --stormstrike
end

function Thrall_spell2(unit, event)
	Thrall:FullCastSpellOnTarget(59717, Koronus) --"shock"
end



--[[============\\
  * After it's
  *    over
\\*===========]]--

function Koronus_itsover(unit, event)
	if (Koronus:IsAlive() == true) then --uh oh spaghetti o
		unit:RegisterEvent("Koronus_endbad", 100, 1)
	else
		Thrall:SendChatMessage(12, 0, "Thank goodness that's over.")
		Thrall:RegisterEvent("Koro_end2", 3000, 1)
		Jaina:RemoveEvents()
	end
end

function Koro_end2(unit, event)
	Jaina:SendChatMessage(12, 0, "Agreed, old friend. Let's get out of here. We all have things to do.")
	Thrall:RegisterEvent("Koro_end3", 5000, 1)
end

function Koro_end3(unit, event)
	Saurfang:SendChatMessage(12, 0, "The young lady is right. Thrall, we must get back as soon as possible.")
	Thrall:RegisterEvent("Koro_end4", 3000, 1)
end

function Koro_end3(unit, event)
	Saurfang:SendChatMessage(12, 0, "We have many fronts and battles that need our command.")
	Thrall:RegisterEvent("Koro_end4", 3000, 1)
end

function Koro_end4(unit, event)
	Thrall:SendChatMessage(12, 0, "Right. Jaina, if you please?")
	Thrall:RegisterEvent("Koro_end5", 3000, 1)
end

function Koro_end4(unit, event)
	Jaina:SendChatMessage(12, 0, "Of course.")
	Jaina:FullCastSpell(61225) --tele visual
	Thrall:RegisterEvent("Koronus_endbad", 4000, 1)
end

function Koronus_endbad(unit, event)
	if (Koronus:IsAlive() == true) then 
		--Koronus:SetCombatCapable(1)
		Koronus:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_2)
		for k,v in pairs(TruePlayers) do
			Koronus:Kill(v) --wipe.
		end
	end
	Thrall:Despawn(0,0)
	Saurfang:Despawn(0,0)
	Jaina:Despawn(0,0)
	for k,v in pairs(minis) do
		if (v:IsInWorld() == true) then
			v:Despawn(0,0)
		end
	end
	for k,v in pairs(gD) do
		if (v:IsInWorld() == true) then
			v:Despawn(0,0)
		end
	end
	unit:RemoveEvents()
	unit:Despawn(360000, 240000)
end



--[[============\\
  * Registering
  *   events
\\*===========]]--

RegisterUnitGossipEvent(84772, 1, "Thrall_OnGossip")
RegisterUnitGossipEvent(84772, 2, "AllLeaders_OnSubmenu")

RegisterUnitGossipEvent(84773, 1, "Saurfang_OnGossip")
RegisterUnitGossipEvent(84773, 2, "AllLeaders_OnSubmenu")

RegisterUnitGossipEvent(84774, 1, "Jaina_OnGossip")
RegisterUnitGossipEvent(84774, 2, "AllLeaders_OnSubmenu")


RegisterUnitEvent(84771, 18, "Koronus_declare")
RegisterUnitEvent(84771, 2, "Koronus_itsover")
RegisterUnitEvent(84771, 4, "Koronus_itsover")
RegisterUnitEvent(84772, 18, "Thrall_declare")
RegisterUnitEvent(84773, 18, "Saurfang_declare")
RegisterUnitEvent(84774, 18, "JAINA.POOP.declare")
RegisterUnitEvent(84775, 18, "MountedAlliance_setup")
RegisterUnitEvent(84776, 18, "MountedHorde_setup")
RegisterUnitEvent(24187, 18, "Tornado_setup")