-----------------------
-----Made by Trinn-----
-------wow-v.com-------
--For Burning Heavens--
-----------------------
--===NEW STANDARDS===--
--Made by Hypersniper--
-----------------------

IMMOLATUS = {}

--  Immolatus Spells  --
--Growth         36300--
--Fireblast      64773--
--Melt Armor     46469--
--Blast Wave     33061--
--Flame Jets     62680 (Possible)--

function IMMOLATUS.OnCombat(pUnit, Event)
	local timer = math.random(18000, 30000)
	pUnit:SendChatMessage(14, 0, "Insolent whelps! Your blood will temper the weapons used to reclaim this world!")
	pUnit:PlaySoundToSet(15564)
	pUnit:RegisterEvent("IMMOLATUS.Fireblast", 20000, 0)
	pUnit:RegisterEvent("IMMOLATUS.MeltArmor", timer, 0)
	pUnit:RegisterEvent("IMMOLATUS.Blastwave", 25000, 0)
	pUnit:RegisterEvent("IMMOLATUS.Phase2", 1000, 0)
end

function IMMOLATUS.Fireblast(pUnit, Event)
	local target = pUnit:GetRandomPlayer(7)
	if (target ~= nil) then
		if (target:IsDead() == false) then
			pUnit:FullCastSpellOnTarget(64773, target)
		else
			IMMOLATUS.Fireblast(pUnit, Event)
		end
	else
		IMMOLATUS.Fireblast(pUnit, Event)
	end
end

function IMMOLATUS.MeltArmor(pUnit, Event)
	local target = Immolatus:GetMainTank()
	if (target ~= nil) then
		if (target:IsDead() == false) then
			pUnit:FullCastSpellOnTarget(46469, target)
		else
			IMMOLATUS.MeltArmor(pUnit, Event)
		end
	else
		IMMOLATUS.MeltArmor(pUnit, Event)
	end
end

function IMMOLATUS.Blastwave(pUnit, Event)
	pUnit:CastSpell(33061)
end

function IMMOLATUS.Phase2(pUnit, Event)
	if (pUnit:GetHealthPct() <= 75) then
		pUnit:RemoveEvents()
		pUnit:SetCombatTargetingCapable(1)
		pUnit:SetCombatCapable(1)
		pUnit:MoveTo(1294.910034, 666.945007, 189.608002, -1.570796)
		pUnit:SendChatMessage(42, 0,"The pipes begin to boil and spew molten ash")
		pUnit:PlaySoundToSet(15565)
		pUnit:RegisterEvent("IMMOLATUS.Summon", 1000, 1)
	end
end

function IMMOLATUS.Summon(pUnit, Event)
	IMMOLATUS[pUnit].creature1 = pUnit:SpawnCreature(84000018, 1294.735229, 734.304138, 199.258362, 0, 14, 0)
	IMMOLATUS[pUnit].creature2 = pUnit:SpawnCreature(84000018, 1293.272705, 598.016296, 199.266037, 0, 14, 0)
	pUnit:RegisterEvent("IMMOLATUS.EndSummon", 1000, 0)
end

function IMMOLATUS.EndSummon(pUnit,event)
	if (IMMOLATUS[pUnit].creature1:IsDead() and IMMOLATUS[pUnit].creature2:IsDead()) then
		local timer = math.random(18000, 30000)
		pUnit:RemoveAllAuras()
		pUnit:SetCombatTargetingCapable(0)
		pUnit:SetCombatCapable(0)
		pUnit:RegisterEvent("IMMOLATUS.Fireblast", 20000, 0)
		pUnit:RegisterEvent("IMMOLATUS.MeltArmor", timer, 0)
		pUnit:RegisterEvent("IMMOLATUS.Blastwave", 25000, 0)
		if (pUnit:GetHealthPct() <= 50 and pUnit:GetHealthPct() > 25) then
			pUnit:RegisterEvent("IMMOLATUS.Phase4", 1000, 0)
		elseif (pUnit:GetHealthPct() > 50) then
			pUnit:RegisterEvent("IMMOLATUS.Phase3", 1000, 0)
		end
	end
end

function IMMOLATUS.Phase3(pUnit, Event)
	if (pUnit:GetHealthPct() <= 50) then
		IMMOLATUS.Phase2(pUnit, Event)
	end
end


function IMMOLATUS.Phase4(pUnit, Event)
	if (pUnit:GetHealthPct() <= 25) then
		IMMOLATUS.Phase2(pUnit, Event)
	end
end

function IMMOLATUS.OnDeath(pUnit, Event)
	pUnit:SendChatMessage(14, 0, "I... Have... Failed...")
	pUnit:PlaySoundToSet(15572)
	pUnit:RemoveEvents()
end

function IMMOLATUS.OnKilledTarget(pUnit, Event)
	pUnit:SendChatMessage(14, 0, "Your bones will serve as kindling!")
	pUnit:PlaySoundToSet(15570)
end

function IMMOLATUS.OnLeaveCombat(pUnit)
	pUnit:RemoveEvents()
end

--------------Register Events------------
RegisterUnitEvent(84000016, 1, "IMMOLATUS.OnCombat")
RegisterUnitEvent(84000016, 2, "IMMOLATUS.OnLeaveCombat")
RegisterUnitEvent(84000016, 3, "IMMOLATUS.OnKilledTarget")
RegisterUnitEvent(84000016, 4, "IMMOLATUS.OnDeath")