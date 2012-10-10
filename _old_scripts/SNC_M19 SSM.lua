--REQUIRES LUAHYPARC R11+
OBJECT_END = 0x0006
UNIT_FIELD_FLAGS = OBJECT_END + 0x0034
UNIT_FLAG_NOT_ATTACKABLE_9 = 0x00000100

--ITEM
local entryid = 0
local ammo = 133701

--ROCKET
--DisplayID: 26611
local Rocket
local rocket_target
local firer
local rocket_ID = 133703
local t = 0

function Rocket_Launcher_Trigger(item, event, player)
   firer = player
   if (not player:GetSelection()) then
      player:SendAreaTriggerMessage("|cFFFF0000Failed to launch. No appropriate target.|r")
   else
      if (player:CanAttack(player:GetSelection())) then
         rocket_target = player:GetSelection()
         if (player:GetItemCount(ammo) < 1 or rocket_target:IsAlive() == false) then
            player:SendAreaTriggerMessage("|cFFFF0000Failed to launch. Out of ammo or target already dead.|r")
         else
            if (t+180 < GetGameTime() or t == 0) then --this enforces cooldown
               if (player:GetDistanceYards(rocket_target) <= 30) then
                  t = GetGameTime()
                  player:CastSpell(34602) --visual
                  player:CastSpell(11428) --knockdown
                  player:RemoveItem(ammo, 1)
                  PerformIngameSpawn(1, rocket_ID, player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO(), player:GetFaction(), 10000)
               else
                  player:SendAreaTriggerMessage("|cFFFF0000Failed to launch. Target out of range.|r")
               end
            else
               player:SendAreaTriggerMessage("|cFFFF0000Failed to launch. Device cooling down.|r")
            end
         end
      else
         player:SendAreaTriggerMessage("|cFFFF0000Failed to launch. No appropriate target.|r")
      end
   end
end

function Rocket_OnSpawn(pUnit, event)
   Rocket = pUnit
   Rocket:SetUInt32Value(UNIT_FIELD_LEVEL, firer:GetPlayerLevel())
   Rocket:SetCombatCapable(1) --can't be affected by aggro
   Rocket:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_ATTACKABLE_9)
   Rocket:ModifyWalkSpeed(15) --make it move fast
   Rocket:RegisterEvent("Rocket_HomeInOnTarget", 500, 0)
end

function Rocket_HomeInOnTarget(pUnit, event)
   Rocket:MoveTo(rocket_target:GetX(), rocket_target:GetY(), rocket_target:GetZ(), rocket_target:GetO())
   if (Rocket:GetDistanceYards(rocket_target) <= 5) then
      Rocket:CastSpell(25699) --Sacrifices the caster's life in order to inflict Fire damage to nearby enemies.
      if (rocket_target:IsPlayer()) then
          Rocket:DealDamage(rocket_target, math.random(4688, 5312), 25699)
      end
      rocket_target:AttackReaction(firer, math.random(4688, 5312), 25699) --the player gets threat
      Rocket:Despawn(0, 0)
      Rocket:RemoveEvents()
   end
end

if GetLuaEngine() ~= "LuaHypArc" then --to check that they're using LHA
   print("LuaEngine: Did not load 'M19 SSM Rocket Launcher' script - LuaHypArc not installed.")
   print("LuaEngine: Please visit luahyparc.zapto.org for more information.")
else
   RegisterUnitEvent(rocket_ID, 18, "Rocket_OnSpawn")
   RegisterItemGossipEvent(entryid, 1, "Rocket_Launcher_Trigger")
end 