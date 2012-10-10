-----------------------
--Made by Hypersniper--
-------wow-v.com-------
---For Project Ronin---
-----------------------

local npc1id = 85704
local npc2id = 85705

RONIN_WARRIORS = {}

function RONIN_WARRIORS.findPartner(pUnit)
   for k,v in pairs(pUnit:GetInRangeFriends()) do
      if ( (pUnit:GetEntry() == npc1id and v:GetEntry() == npc2id) or (pUnit:GetEntry() == npc2id and v:GetEntry() == npc1id) ) then
         return v
      end
   end
   return false
end

function RONIN_WARRIORS.b1_OnSpawn(pUnit, event)
   RONIN_WARRIORS[pUnit].partner = RONIN_WARRIORS.findPartner(pUnit)
   pUnit:ModifyWalkSpeed(8)
end

function RONIN_WARRIORS.b2_OnSpawn(pUnit, event)
   RONIN_WARRIORS[pUnit].partner = RONIN_WARRIORS.findPartner(pUnit)
   pUnit:ModifyWalkSpeed(8)
end

function RONIN_WARRIORS.b1_OnCombat(pUnit, event)
   pUnit:RegisterEvent("RONIN_WARRIORS.Thrash", 10000, 0)
   pUnit:RegisterEvent("RONIN_WARRIORS.Charge_1", 1000, 1)
   RONIN_WARRIORS[pUnit].partner:RegisterEvent("RONIN_WARRIORS.Charge_1", 6000, 1)
end

function RONIN_WARRIORS.b2_OnCombat(pUnit, event)
   pUnit:RegisterEvent("RONIN_WARRIORS.Rend", 15000, 0)
end

function RONIN_WARRIORS.OnLeave(pUnit, event)
   pUnit:RemoveEvents()
end

function RONIN_WARRIORS.b1_OnDeath(pUnit, event)
   if (RONIN_WARRIORS[pUnit].partner:IsAlive()) then
      RONIN_WARRIORS[pUnit].partner:CastSpell(57086) --frenzy
   end
   pUnit:RemoveEvents()
end

function RONIN_WARRIORS.b2_OnDeath(pUnit, event)
   if (RONIN_WARRIORS[pUnit].partner:IsAlive()) then
      RONIN_WARRIORS[pUnit].partner:CastSpell(57086) --frenzy
   end
   pUnit:RemoveEvents()
end

function RONIN_WARRIORS.Charge_1(pUnit, event)
   pUnit:MoveTo(pUnit:GetX(), pUnit:GetY()-20, pUnit:GetZ(), pUnit:GetO())
   pUnit:RegisterEvent("RONIN_WARRIORS.Charge_2", 2000, 1)
end

function RONIN_WARRIORS.Charge_2(pUnit, event)
   pUnit:FullCastSpellOnTarget(43807, pUnit:GetMainTank())
end

function RONIN_WARRIORS.Thrash(pUnit, event)
   pUnit:CastSpell(3391)
end

function RONIN_WARRIORS.Rend(pUnit, event)
   pUnit:FullCastSpellOnTarget(11977, pUnit:GetMainTank())
end

RegisterUnitEvent(npc1id, 18, "RONIN_WARRIORS.b1_OnSpawn")
RegisterUnitEvent(npc2id, 18, "RONIN_WARRIORS.b2_OnSpawn")
RegisterUnitEvent(npc1id, 1, "RONIN_WARRIORS.b1_OnCombat")
RegisterUnitEvent(npc2id, 1, "RONIN_WARRIORS.b2_OnCombat")
RegisterUnitEvent(npc1id, 2, "RONIN_WARRIORS.OnLeave")
RegisterUnitEvent(npc2id, 2, "RONIN_WARRIORS.OnLeave")
RegisterUnitEvent(npc1id, 4, "RONIN_WARRIORS.b1_OnDeath")
RegisterUnitEvent(npc2id, 4, "RONIN_WARRIORS.b2_OnDeath")