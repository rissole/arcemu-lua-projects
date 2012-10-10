-----------------------
--Made by Hypersniper--
-----Project Ronin-----
-----------------------

RONIN_HEAVENWALKER = {}
local id = 85771

function RONIN_HEAVENWALKER.OnSpawn(pUnit, event)
   pUnit:RegisterEvent("RONIN_HEAVENWALKER.ChannelRes", 1000, 1)
end

function RONIN_HEAVENWALKER.ChannelRes(pUnit, event)
   pUnit:ChannelSpell(22011, pUnit) --rez channel visual
   pUnit:RegisterEvent("RONIN_HEAVENWALKER.CastRes", 14000, 1)
end

function RONIN_HEAVENWALKER.CastRes(pUnit, event)
   pUnit:StopChannel()
   local players = pUnit:GetInRangePlayers()
   for k,v in pairs(players) do
      if (pUnit:GetDistanceYards(v) <= 15 and (v:HasAura(8326) or v:HasAura(20584))) then
         v:ResurrectPlayer()
         v:CastSpell(58854) --rez visual
      end
   end
   pUnit:RegisterEvent("RONIN_HEAVENWALKER.ChannelRes", 2000, 1)
end

RegisterUnitEvent(id, 18, "RONIN_HEAVENWALKER.OnSpawn")