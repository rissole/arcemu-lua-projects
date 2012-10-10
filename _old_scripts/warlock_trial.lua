local Sakra
local Master
local Player
local phase = 1
local waited = 0
local PetTable = { [1]={"Imp",688,74774}, [2]={"Voidwalker",697,74775}, [3]={"Succubus",712,74776}, [4]={"Felhunter",691,74777} }
local lockPetGUID
local Boss = 0
local UNIT_FLAG_DEFAULT
local voidShield = 0
local succFrenzy = 0

--[[                \\
     Initial Gossip 
         Stuff
  \\                 ]]--

function Trial_On_Gossip(unit, event, player)
	if (player:GetPlayerClass() ~= "Warlock" or player:HasSpell(1002) == true) then
		player:GossipComplete()
	else
		unit:GossipCreateMenu(100, player, 0)
		unit:GossipMenuAddItem(0, "I'm ready to begin the trial, Sakra'nal.", 0, 0)
		unit:GossipSendMenu(player)
	end
end

function Trial_Gossip_Submenus(unit, event, player, id, intid, code)
	if (intid == 0) then
		Sakra = unit
		Player = player
		unit:SpawnCreature(74773, Sakra:GetX(), Sakra:GetY(), Sakra:GetZ()-25, Sakra:GetO(), 35, 0)
		player:GossipComplete()
	end
end


--[[                \\
     Initial Trial 
         Stuff
  \\                 ]]--

function Trial_Trial_begin(unit, event)
	Master = unit
	Master:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE)
	Sakra:SetUInt64Value(UNIT_NPC_FLAGS, 0x00)
	Sakra:Emote(2, 1500)
	Master:RegisterEvent("Trial_Incantation_1", 2500, 1)
end

function Trial_Incantation_1(unit, event)
	Sakra:ChannelSpell(686, Sakra)
	Sakra:SendChatMessage(12, 0, "The burning darkness they once held")
	Master:RegisterEvent("Trial_Incantation_2", 2500, 1)
end

function Trial_Incantation_2(unit, event)
	Sakra:SendChatMessage(12, 0, "Was lost; their powers quelled.")
	Master:RegisterEvent("Trial_Incantation_3", 2500, 1)
end

function Trial_Incantation_3(unit, event)
	Sakra:SendChatMessage(12, 0, "Now the legion calls to their domain:")
	Master:RegisterEvent("Trial_Incantation_4", 2500, 1)
end

function Trial_Incantation_4(unit, event)
	Sakra:SendChatMessage(12, 0, "Show us the power we must obtain!")
	Master:RegisterEvent("Trial_Create_portal", 2500, 1)
end

--[[                \\
      Generalised 
       Functions
  \\                 ]]--

function Trial_Create_portal(unit, event)
	if (Boss ~= 0) then
		Boss:Despawn(0, 0)
	end
	Sakra:CastSpell(40280)
	Sakra:SendChatMessage(12, 0, "The following trial is of the "..PetTable[phase][1]..". Allow me to summon your "..PetTable[phase][1].." at no cost to you.")
	Master:RegisterEvent("Trial_Begin_summon", 5000, 1)
end

function Trial_Begin_summon(unit, event)
	Player:CastSpell(33338)
	Master:RegisterEvent("Trial_Summon", 5000, 1)
end

function Trial_Summon(unit, event)
	Player:CastSpell(PetTable[phase][2])
	if (phase > 1) then
		Player:AddItem(6265,1)	
	end
	Player:RemoveAura(33338)
	Sakra:SendChatMessage(12, 0, "Good. Your "..PetTable[phase][1].." is here.")
	lockPetGUID = Player:GetUInt64Value(UNIT_FIELD_SUMMON)
	Master:RegisterEvent("Trial_Check", 500, 0)
	Master:RegisterEvent("Trial_Summon_boss", 3000, 1)
end

function Trial_Check(unit, event)
	waited = waited+500
	if (Player:GetUInt64Value(UNIT_FIELD_SUMMON) ~= lockPetGUID and Player:GetUInt64Value(UNIT_FIELD_SUMMON) ~= 0) then
		Sakra:SendChatMessage(12, 0, "No! This is the trial of the "..PetTable[phase][1].."! You can't change your pet!")
		Player:CastSpell(PetTable[phase][2])
		if (phase > 1) then
			Player:AddItem(6265,1)	
		end
		lockPetGUID = Player:GetUInt64Value(UNIT_FIELD_SUMMON)
	end
	if (Player:IsDead() == true) then
		Master:RegisterEvent("Trial_Trial_reset", 500, 1)
	end
	if (waited > 180000) then
		Master:RegisterEvent("Trial_Trial_reset", 500, 1)
	end
end

function Trial_Summon_boss(unit, event)
	Sakra:SendChatMessage(12, 0, "The dark one comes!")
	Master:SpawnCreature(PetTable[phase][3], Sakra:GetX(), Sakra:GetY(), Sakra:GetZ(), Sakra:GetO(), 14, 0)
end

function Trial_boss_init(unit, event)
	waited = 0
	Boss = unit
	UNIT_FLAG_DEFAULT = Boss:GetUInt64Value(UNIT_FIELD_FLAGS)
	Boss:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_2)
	Boss:MoveTo(Sakra:GetX() + 5, Sakra:GetY(), Sakra:GetZ(), Sakra:GetO())
	Boss:RegisterEvent("Trial_boss_"..PetTable[phase][1], 3000, 1)
end

function Trial_Trial_reset(unit, event)
	Sakra:RemoveAllAuras()
	Sakra:StopChannel()
	if (phase ~= 5) then
		Sakra:SendChatMessage(12, 0, "It is over...")
		Boss:Despawn(0, 0)
	else
		Sakra:SendChatMessage(12, 0, "You have mastered the darkness well, Warlock.")
	end
	Sakra:RemoveEvents()
	Sakra:Despawn(2000,5000)
	phase = 1
	waited = 0
	Master:RemoveEvents()
	Master:Despawn(0,0)
end

function Trial_boss_died(unit, event)
	unit:RemoveEvents()
	waited = 0
	phase = phase+1
	if (phase == 5) then
		Sakra:SendChatMessage(12, 0, "Congratulations, "..Player:GetName()..". The trial is complete.")
		Master:RegisterEvent("Trial_closing_1", 3000, 1)
	else
	Sakra:SendChatMessage(12, 0, "Good. That dark one is down, but I'll summon the next one soon.")
	Master:RegisterEvent("Trial_Create_portal", 30000, 1)
	end
end

--[[                \\
        = Imp =
         Boss
  \\                 ]]--

function Trial_boss_Imp(unit, event)
	Boss:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_DEFAULT)
	unit:SetScale(2)
	Boss:CastSpell(27128)
	unit:RegisterEvent("Trial_boss_Imp_spell1", 5000, 0)
	unit:RegisterEvent("Trial_boss_Imp_spell2", 8000, 0)
end

function Trial_boss_Imp_spell1(unit, event)
	Boss:CastSpellAoF(Player:GetX(), Player:GetY(), Player:GetZ(), 37279)
end

function Trial_boss_Imp_spell2(unit, event)
	Boss:FullCastSpellOnTarget(20623, unit:GetMainTank())
end
--[[                \\
        = Void =
          Boss
  \\                 ]]--

function Trial_boss_Voidwalker(unit, event)
	unit:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_DEFAULT)
	unit:RegisterEvent("Trial_boss_Voidwalker_spell1", 500, 0)
	unit:RegisterEvent("Trial_boss_Voidwalker_spell2", 5000, 0)
	unit:RegisterEvent("Trial_boss_Voidwalker_spell3", 5000, 0)
end

function Trial_boss_Voidwalker_spell1(unit, event)
	if (unit:GetHealthPct() <= 40 and voidShield == 0) then
		unit:CastSpell(52634)
		voidShield = 1
	end
end

function Trial_boss_Voidwalker_spell2(unit, event)
	unit:FullCastSpellOnTarget(51339, unit:GetMainTank())
end

function Trial_boss_Voidwalker_spell3(unit, event)
	unit:CastSpell(34109)
end

--[[                \\
      = Succubus =
          Boss
  \\                 ]]--

function Trial_boss_Succubus(unit, event)
	Boss:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_DEFAULT)
	Boss:CastSpell(32612)
	unit:RegisterEvent("Trial_boss_Succubus_spell1", 5000, 0)
	unit:RegisterEvent("Trial_boss_Succubus_spell2", 500, 0)
end

function Trial_boss_Succubus_spell1(unit, event)
	Boss:FullCastSpellOnTarget(53333, unit:GetMainTank())
end

function Trial_boss_Succubus_spell2(unit, event)
	if (unit:GetHealthPct() <= 40 and succFrenzy == 0) then
		unit:CastSpell(41305)
		succFrenzy = 1
	end
end

--[[                \\
      = Felhunter =
          Boss
  \\                 ]]--

function Trial_boss_Felhunter(unit, event)
	Boss:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_DEFAULT)
	unit:CastSpell(16592)
	unit:SetScale(2)
	unit:RegisterEvent("Trial_boss_Felhunter_spell1", 10000, 0)
	unit:RegisterEvent("Trial_boss_Felhunter_spell2", 5000, 0)
	unit:RegisterEvent("Trial_boss_Felhunter_spell3", 8000, 0)
end

function Trial_boss_Felhunter_spell1(unit, event)
	Boss:FullCastSpellOnTarget(47476, Player)
end

function Trial_boss_Felhunter_spell2(unit, event)
	Boss:FullCastSpellOnTarget(8129, unit:GetMainTank())
end

function Trial_boss_Felhunter_spell3(unit, event)
	unit:CastSpell(44314)
end

--[[                \\
        Ending
       Cinematics
  \\                 ]]--

function Trial_closing_1(unit, event)
	Boss:Despawn(0,0)
	Sakra:RemoveAllAuras()
	Sakra:StopChannel()
	Sakra:CastSpell(686)
	Master:RegisterEvent("Trial_closing_2", 3500, 1)
end


function Trial_closing_2(unit, event)
	Sakra:SendChatMessage(12, 0, "I am now able to bestow upon you the reward of this trial.")
	Master:RegisterEvent("Trial_closing_3", 3500, 1)
end

function Trial_closing_3(unit, event)
	Sakra:SendChatMessage(12, 0, "Your tie with your demon is outstanding. I hereby give you this reward:")
	Master:RegisterEvent("Trial_closing_4", 3500, 1)
end

function Trial_closing_4(unit, event)
	Player:LearnSpell(1002)
	Player:CastSpell(58854)
	Master:RegisterEvent("Trial_Trial_reset", 3500, 1)
end

--[[                 \\
     Registering Unit 
         Events
  \\                  ]]--

RegisterUnitGossipEvent(74772, 1, "Trial_On_Gossip")
RegisterUnitGossipEvent(74772, 2, "Trial_Gossip_Submenus")

RegisterUnitEvent(74773, 18, "Trial_Trial_begin")

RegisterUnitEvent(74774, 18, "Trial_boss_init")
RegisterUnitEvent(74774, 4, "Trial_boss_died")

RegisterUnitEvent(74775, 18, "Trial_boss_init")
RegisterUnitEvent(74775, 4, "Trial_boss_died")

RegisterUnitEvent(74776, 18, "Trial_boss_init")
RegisterUnitEvent(74776, 4, "Trial_boss_died")

RegisterUnitEvent(74777, 18, "Trial_boss_init")
RegisterUnitEvent(74777, 4, "Trial_boss_died")