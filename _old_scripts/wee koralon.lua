
-----------------------------------------------------
------------[[Koralon the Flame Watcher]]------------
-----------------------------------------------------

-----------------------------------------------------
----------------------[[Define]]---------------------
-----------------------------------------------------

function KoralonDefine(Unit, event)
	Koralon = Unit
end

-----------------------------------------------------
----------------------[[Combat]]---------------------
-----------------------------------------------------

function KoralonCombat(Unit, event)
	Koralon:SendChatMessage(14, 0, "The expendible have perished... So be it! Now I shall succeed where Emalon could not! I will bleed this wretched world, the end has come! Let the unraveling of this world commence!")
	Koralon:RegisterEvent("SpecialSpinChannel", 15000, 1)
	Koralon:RegisterEvent("MeteorFist_Visual", 30000, 1)
	Koralon:RegisterEvent("MassiveFlamingCinder", 100, 1)
	Koralon:RegisterEvent("BurningFury", 20000, 0)
end

-----------------------------------------------------
--------------------[[Lava Burst]]-------------------
-----------------------------------------------------

function LavaBurst(Unit, event)
local PlayersAllAround = Koralon:GetInRangePlayers()
	for a, plr in pairs(PlayersAllAround) do
	Koralon:FullCastSpellOnTarget(67330, plr)
	end
end

-----------------------------------------------------
------------------[[Meteor Fists]]-------------------
-----------------------------------------------------

function MeteorFist_Visual(Unit, event)
   Koralon:FullCastSpell(66725)
   Koralon:SendChatMessage(42, 0, "Koralon the Flame Watcher casts Meteor Fists")
   Koralon:RegisterEvent("MeteorFist_Attack", 1500, 1)
   Koralon:RegisterEvent("MeteorFist_Repeat", 15000, 1)
   Koralon:RegisterEvent("ContinuedSpinChannelSpell", 20000, 1)
end

function MeteorFist_Repeat(Unit, event)
	Koralon:RegisterEvent("MeteorFist_Visual", 25000, 1)
end

function MeteorFist_Attack(Unit, event)
	Koralon:FullCastSpell(67331)
	Koralon:RegisterEvent("MeteorFist_Continued", 4000, 3)
end
	
function MeteorFist_Continued(Unit, event)
	Koralon:FullCastSpell(67331)
end

-----------------------------------------------------
----------------------[[Spinn]]----------------------
-----------------------------------------------------

function SpecialSpinChannel(Unit, event)
   Koralon:FullCastSpell(66665)
   Koralon:RegisterEvent("Spin_Casttime_delay", 1500, 1)
   Koralon:RegisterEvent("LavaBurst", 4400, 1)
end

function ContinuedSpinChannelSpell(Unit, event)
   Koralon:FullCastSpell(66665)
   Koralon:RegisterEvent("Spin_Casttime_delay", 1500, 1)
   Koralon:RegisterEvent("LavaBurst", 3400, 1)
end

function Spin_Casttime_delay(Unit, event)
   Koralon:RegisterEvent("PerformSpin", 1, 30) --40 x 9 degree rotations = 360
end

function PerformSpin(Unit, event)
   Koralon:SetFacing(Koralon:GetO() + math.rad(15))     --both these funcs are basically the same, just doing 
   Koralon:SetOrientation(Koralon:GetO() + math.rad(15))
end

-----------------------------------------------------
---------------------[[Cinders]]---------------------
-----------------------------------------------------

function MassiveFlamingCinder(Unit, Event)
	Koralon:RegisterEvent("TanksFlamingCinder", 5000, 1)
	Koralon:RegisterEvent("ShortFlamingCinder", 10000, 1)
	Koralon:RegisterEvent("MiddleFlamingCinder", 15000, 1)
	Koralon:RegisterEvent("LongFlamingCinder", 20000, 1)
end

function TanksFlamingCinder(Unit, Event)
local TankCinder = Koralon:GetMainTank()
	if TankCinder ~= nil then
		local Tankx = TankCinder:GetX()
		local Tanky = TankCinder:GetY()
		local Tankz = TankCinder:GetZ()
		Koralon:CastSpellAoF(Tankx, Tanky, Tankz, 67332)
		Koralon:RegisterEvent("TanksFlamingCinder", 5000, 1)
		else
	end
end

function ShortFlamingCinder(Unit, Event)
local ShortCinder = Koralon:GetRandomPlayer(1)
	if ShortCinder ~= nil then
		local Shortx = ShortCinder:GetX()
		local Shorty = ShortCinder:GetY()
		local Shortz = ShortCinder:GetZ()
		Koralon:CastSpellAoF(Shortx, Shorty, Shortz, 67332)
		Koralon:RegisterEvent("ShortFlamingCinder", 5000, 1)
		else
	end
end

function MiddleFlamingCinder(Unit, Event)
local MiddleCinder = Koralon:GetRandomPlayer(2)
	if MiddleCinder ~= nil then
		local Middlex = MiddleCinder:GetX()
		local Middley = MiddleCinder:GetY()
		local Middlez = MiddleCinder:GetZ()
		Koralon:CastSpellAoF(Middlex, Middley, Middlez, 67332)
		Koralon:RegisterEvent("MiddleFlamingCinder", 5000, 1)
		else
	end
end

function LongFlamingCinder(Unit, Event)
local LongCinder = Koralon:GetRandomPlayer(3)
	if LongCinder ~= nil then
		local Longx = LongCinder:GetX()
		local Longy = LongCinder:GetY()
		local Longz = LongCinder:GetZ()
		Koralon:CastSpellAoF(Longx, Longy, Longz, 67332)
		Koralon:RegisterEvent("LongFlamingCinder", 5000, 1)
		else
	end
end

-----------------------------------------------------
-----------------[[Burning Fury]]--------------------
-----------------------------------------------------

function BurningFury(Unit, event)
	Koralon:FullCastSpell(66721)
	Koralon:RegisterEvent("FlameBuffet", 1000, 1)
	Koralon:RegisterEvent("SlagPot", 5000, 1)
end

-----------------------------------------------------
--------------------[[Flamebuffet]]------------------
-----------------------------------------------------

function FlameBuffet(Unit, event)
	Koralon:FullCastSpell(64023)
end

-----------------------------------------------------
---------------------[[Slagpot]]---------------------
-----------------------------------------------------

function SlagPot(Unit, Event)
local Player = Koralon:GetRandomPlayer(0)
	if Player ~= nil then
		Koralon:FullCastSpellOnTarget(63477, Player)
		Koralon:RegisterEvent("SlagPotRemoveHp", 1000, 0)
		else
	end
end

function SlagPotRemoveHp(Unit, event)
local plr = Koralon:GetRandomPlayer(0)
	if plr:HasAura(63477) == true then
		plr:SetHealth(plr:GetHealth()*0.9)
	end
end

-----------------------------------------------------
-------------------[[Leave Target]]------------------
-----------------------------------------------------

function KoralonLeaveCombat(Unit, Event)
	Koralon:RemoveEvents() 
end

-----------------------------------------------------
------------------[[Killing Target]]-----------------
-----------------------------------------------------

function KoralonKilledTarget(Unit, Event)
end
-----------------------------------------------------
-----------------------[[Died]]----------------------
-----------------------------------------------------

function KoralonDied(Unit, Event)
	Koralon:RemoveEvents()
end

-----------------------------------------------------
--------------------[[Registrets]]-------------------
-----------------------------------------------------

RegisterUnitEvent(29503, 4, "KoralonDied")
RegisterUnitEvent(29503, 1, "KoralonCombat")
RegisterUnitEvent(29503, 18, "KoralonDefine")
RegisterUnitEvent(29503, 2, "KoralonLeaveCombat")
RegisterUnitEvent(29503, 3, "KoralonKilledTarget")