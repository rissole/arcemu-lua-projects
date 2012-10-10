function DistanceToPoint(pUnit, x, y, z)
    local dx = x-pUnit:GetX()
    local dy = y-pUnit:GetY()
    local dz = z-pUnit:GetZ()
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function Onyxia_OnEnterCombat(pUnit, event)
local Spelltimer=math.random(10000, 20000)
    pUnit:SendChatMessage(14, 0, "How fortuitous, usually I must leave my lair to feed!")
	pUnit:RegisterEvent("Onyxia_Run", 10000, 1)
	--pUnit:RegisterEvent("Tailswipe_Check", 1000, 0) commented out for now, better fix will be implemented later
    local n = CharDBQuery("SELECT name FROM characters", 2)
    pUnit:SendChatMessage(14, 0, n)
end

-------------------------------
--------[[Run Waypoint]]-------
-------------------------------

function Onyxia_Run(pUnit, event)
    pUnit:SetCombatMeleeCapable(1)
	pUnit:SetMovementFlags(1)
    pUnit:MoveTo(-33.81, -206.90, -54.48, 0) --change to moveto
	pUnit:RegisterEvent("Onyxia_TakeOff", 1000, 0)

end

function Onyxia_TakeOff(pUnit, event)
if (DistanceToPoint(pUnit, -33.81, -206.90, -54.48) <= 1) then
pUnit:RemoveEvents()
pUnit:SetCombatMeleeCapable(1)
pUnit:RegisterEvent("FLY_PHASE_BEGIN", 1, 1)
end
end

function FLY_PHASE_BEGIN(pUnit, event)
    pUnit:SetMovementFlags(2)
    pUnit:MoveTo(24.504204, -208.138290, 70.8550342, 0) --fly flag
	pUnit:RegisterEvent("FLY_PHASE_SPELLS", 1000, 0)
end

function FLY_PHASE_SPELLS(pUnit, event)
if (DistanceToPoint( pUnit, 24.504204, -208.138290, 70.8550342) <= 1) then
pUnit:RemoveEvents()
pUnit:RegisterEvent("Onyxia_FlyPhase", 1, 1)
end
end

-------------------------------
---------[[Fire Ball]]---------
-------------------------------

function Onyxia_Fireball(pUnit, event)
local player=pUnit:GetRandomPlayer(0);
local px = player:GetX();
local py = player:GetY();
local pz = player:GetZ();
    pUnit:StopChannel()
    pUnit:FullCastSpellAoF(px, py, pz, 18392)
local ScenePart = ScenePart + 1
end

-------------------------------
--------[[Deep Breath]]--------
-------------------------------

function Onyxia_DeepBreath(pUnit, event)
    pUnit:FullCastSpell(17086)
    pUnit:RegisterEvent("Onyxia_inferno", 8100, 1)
end

function Onyxia_inferno(pUnit, event)
local infernox = player:GetX();
local infernoy = player:GetY();
local infernoz = player:GetZ();
    pUnit:CastSpellAoF(-19.419708, -219.152191, -88.856476, 18392)
local ScenePart = ScenePart + 1
end

function Onyxia_WhelpPackOne(pUnit, event)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
end

function Onyxia_WhelpPackTwo(pUnit, event)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
end

function Onyxia_WhelpPackThree(pUnit, event)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
end

function Onyxia_WhelpPackFour(pUnit, event)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
end

function Onyxia_WhelpPackFive(pUnit, event)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
	pUnit:SpawnCreature(11262, -19.419708, -219.152191, -88.856476, 14, 0)
end

-------------------------------
-----[[Second Deep Breath]]----
-------------------------------

function Onyxia_SecondDeepBreath(pUnit, event)
    pUnit:FullCastSpell(17086)
    pUnit:RegisterEvent("Onyxia_Secondinferno", 8100, 1)
end

function Onyxia_Secondinferno(pUnit, event)
local px = player:GetX();
local py = player:GetY();
local pz = player:GetZ();
    pUnit:CastSpellAoF(px, py, pz, 18392)
    pUnit:RegisterEvent("Onyxia_Land", 2000, 1)
end

-------------------------------
--------[[Flying Phase]]-------
-------------------------------

function Onyxia_FlyPhase(pUnit, Event)
if(ScenePart == 1) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_Fireball", 10000, 1)
    ScenePart = 2
elseif(ScenePart == 2) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_Fireball", 10000, 1)
    ScenePart = 3
elseif(ScenePart == 3) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_Fireball", 10000, 1)
    ScenePart = 4
elseif(ScenePart == 4) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_DeepBreath", 1000, 1)
    ScenePart = 5
elseif(ScenePart == 5) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_Fireball", 10000, 1)
    ScenePart = 6
elseif(ScenePart == 6) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_Fireball", 10000, 1)
    ScenePart = 7
elseif(ScenePart == 7) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_Fireball", 10000, 1)
    ScenePart = 8
elseif(ScenePart == 8) and (Fly == 1) then
    pUnit:RegisterEvent("Onyxia_SecondDeepBreath", 1000, 1)
    end
end

-------------------------------
---------[[Land Phase]]--------
-------------------------------

function Onyxia_LandPhase(pUnit, event)
local Spelltimer=math.random(10000, 20000)
local randomspell=math.random(1, 3);
if randomspell == 1 then
	pUnit:StopChannel()
	pUnit:FullCastSpell(68970, pUnit:GetMainTank()) --Flame Breath
end
if randomspell == 2 then
	pUnit:StopChannel()
	pUnit:FullCastSpell(18500, pUnit:GetMainTank()) --Wing Buffet
end
if randomspell == 3 then
	pUnit:StopChannel()
	pUnit:CastSpellOnTarget(68868, pUnit:GetMainTank()) --Cleave
	end
end

-------------------------------
---------[[Tailsweep]]---------
-------------------------------

function Tailswipe_Check(pUnit, event)
local whelpplayer = pUnit:GetRandomPlayer(0)
	if whelpplayer ~= nil then
			if (pUnit:GetDistanceYards(whelpplayer)) < 10 and (whelpplayer:IsInBack()) then
			pUnit:CastSpell(50155)
			whelpplayer:SetHealth(whelpplayer:GetHealth()/2)
			whelpplayer:KnockBack(300)
			end
		else
	end
end

-------------------------------
-------[[Landing Phase]]-------
-------------------------------

function Onyxia_Land(pUnit, Event)
local Fly = 0
local ScenePart = 0
    pUnit:Land() 
end

RegisterUnitEvent(10185, 1, "Onyxia_OnEnterCombat")