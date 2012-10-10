-----------------------
--Made by Hypersniper--
-------wow-v.com-------
--For Burning Heavens--
-----------------------
--===NEW STANDARDS===--
-----------------------

THASVAL = {}

function THASVAL.combat(pUnit)
	pUnit:SendChatMessage(14, 0, "Give in, you have no chance!")
	pUnit:RegisterEvent("THASVAL.phase1", 1000, 0)
end

function THASVAL.phase1(pUnit)
	pUnit:RemoveEvents()
	pUnit:RegisterEvent("THASVAL.dcoil", math.random(6000,8000), 0)
	pUnit:RegisterEvent("THASVAL.danddecay", 60000, 0)
	pUnit:RegisterEvent("THASVAL.plaguestrike", 45000, 3)
	pUnit:RegisterEvent("THASVAL.phase2", 1000, 0)
end

function THASVAL.phase2(pUnit)
	if (pUnit:GetHealthPct() <= 50) then
		pUnit:RemoveEvents()
		pUnit:RegisterEvent("THASVAL.icytouch", math.random(14000,18000), 0)
		pUnit:RegisterEvent("THASVAL.hungering", 30000, 0)
		pUnit:RegisterEvent("THASVAL.howling", 32000, 0)
	end
end

function THASVAL.kill(pUnit, event, pMisc)
	pUnit:SendChatMessage(14, 0, "Don't worry, nothing will go to waste here!")
	THASVAL.summonghoul(pUnit, pMisc)
end

function THASVAL.death(pUnit)
	pUnit:SendChatMessage(14, 0, "I... deny... death!")
	pUnit:RemoveEvents()
end

function THASVAL.leavecombat(pUnit)
	pUnit:RemoveEvents()
end

function THASVAL.dcoil(pUnit)
	pUnit:FullCastSpellOnTarget(53769, pUnit:GetRandomPlayer(0))
end

function THASVAL.danddecay(pUnit)
	pUnit:CastSpellAoF(pUnit:GetX(), pUnit:GetY(), pUnit:GetZ(), 56359)
end

function THASVAL.plaguestrike(pUnit)
	pUnit:FullCastSpellOnTarget(55255, pUnit:GetMainTank())
end

function THASVAL.icytouch(pUnit)
	pUnit:FullCastSpellOnTarget(60845, pUnit:GetRandomPlayer(0))
end

function THASVAL.hungering(pUnit)
	pUnit:CastSpell(61058)
end

function THASVAL.howling(pUnit)
	pUnit:FullCastSpellOnTarget(61061, pUnit:GetMainTank())
end

function THASVAL.summonghoul(pUnit, target)
	pUnit:SpawnCreature(28565, target:GetX(), target:GetY(), target:GetZ(), target:GetO(), 14, 180000)
end

RegisterUnitEvent(8000015, 1, "THASVAL.combat")
RegisterUnitEvent(8000015, 1, "THASVAL.leavecombat")
RegisterUnitEvent(8000015, 3, "THASVAL.kill")
RegisterUnitEvent(8000015, 4, "THASVAL.death")