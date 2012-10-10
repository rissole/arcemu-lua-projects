-----------------------
--Made by Hypersniper--
-------wow-v.com-------
--For Burning Heavens--
-----------------------
--===NEW STANDARDS===--
-----------------------

ALTHOD = {}

function ALTHOD.combat(pUnit)
	pUnit:SendChatMessage(14, 0, "I lost then, but now... I will win!")
	pUnit:CastSpell(64919) --ice nova1
	pUnit:RegisterEvent("ALTHOD.phase1", 1000, 0)
end

function ALTHOD.phase1(pUnit)
	pUnit:RemoveEvents()
	pUnit:RegisterEvent("ALTHOD.frostbolt", math.random(4000,6000), 0)
	pUnit:RegisterEvent("ALTHOD.icenova", 15000, 0)
	pUnit:RegisterEvent("ALTHOD.phase2", 1000, 0)
end

function ALTHOD.phase2(pUnit)
	if (pUnit:GetHealthPct() <= 50) then
		pUnit:RemoveEvents()
		pUnit:RegisterEvent("ALTHOD.shadowbolt", math.random(4000,7000), 0)
		pUnit:RegisterEvent("ALTHOD.shadownova", 15000, 0)
	end
end

function ALTHOD.kill(pUnit)
	pUnit:SendChatMessage(14, 0, "If only you were him...")
end

function ALTHOD.death(pUnit)
	pUnit:SendChatMessage(12, 0, "Finally... rest...")
	pUnit:RemoveEvents()
end

function ALTHOD.leavecombat(pUnit)
	pUnit:RemoveEvents()
end

function ALTHOD.frostbolt(pUnit)
	local tar = pUnit:GetRandomPlayer(0)
	if (tar == nil) then return; end
	pUnit:FullCastSpellOnTarget(46035, tar)
end

function ALTHOD.icenova(pUnit)
	pUnit:CastSpell(66346)
end

function ALTHOD.shadowbolt(pUnit)
	local tar = pUnit:GetRandomPlayer(0)
	if (tar == nil) then return; end
	pUnit:FullCastSpellOnTarget(51432, tar)
end

function ALTHOD.shadownova(pUnit)
	pUnit:CastSpell(60845)
end

RegisterUnitEvent(800013, 1, "ALTHOD.combat")
RegisterUnitEvent(800013, 2, "ALTHOD.leavecombat")
RegisterUnitEvent(800013, 3, "ALTHOD.kill")
RegisterUnitEvent(800013, 4, "ALTHOD.death")