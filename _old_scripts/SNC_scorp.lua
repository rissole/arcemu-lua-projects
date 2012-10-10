--[[
He With No Life: Summon Scorpions
Team Pheonix & hypersniper
Recommended Item: http://wow-v.com/item.php?id=########
YOU MUST USE LuaHypArc as your Lua Engine
]]--
--DO NOT CHANGE ANYTHING BEYOND THIS POINT UNLESS OTHERWISE STATED
-- LOCALS
local entryid = 76276 -- ADD YOUR ENTRYID FOR THE ITEM, DO NOT INCLUDE BRACKETS
local scorpion = 7078 -- ADD YOUR ENTRYID FOR THE NPC, DO NOT INCLUDE BRACKETS

local scorpions = {}
local t = 0
local Player

function scorpion_OnSpawn(pUnit, event)
pUnit:RegisterEvent("scorpion_checkcombat", 1000, 0)
end

function scorpion_checkcombat(pUnit, event)
--print(pUnit:GetUnitToFollow())
local tar = Player:GetPrimaryCombatTarget()
if tar ~= nil and Player:IsInCombat() then
pUnit:AttackReaction(tar,1000,0)
else
pUnit:SetUnitToFollow(Player,5,1) --set em to follow.
end
end

-- FUNCTIONS
function summon_scorpions_item(item, event, player)
   Player = player
   if (t+180 < player:GetGameTime() or t == 0) then --this enforces cooldown
   t = player:GetGameTime()
   player:CastSpell(34656)
   local faction = player:GetFaction() -- Allows both factions to use the item
   local MapID = player:GetMapId() -- DO NOT CHANGE
   local Z = player:GetZ() -- Get the Submerged/Aerial height of the player using the item
   local O = player:GetO() -- Get the Orientation of the player using the item

   -- Top Left Scorpion
   local X_TL = player:GetX()-5
   local Y_TL = player:GetY()
   -- Top Center Scorpion
   local X_TC = player:GetX()+5
   local Y_TC = player:GetY()
   -- Top Right Scorpion
   local X_TR = player:GetX()-5
   local Y_TR = player:GetY()-5
   -- Bottom Left Scorpion
   local X_BL = player:GetX()
   local Y_BL = player:GetY()-5
   -- Bottom Center Scorpion
   local X_BC = player:GetX()+5
   local Y_BC = player:GetY()+5
   -- Bottom Right Scorpion
   local X_BR = player:GetX()
   local Y_BR = player:GetY()+5

   player:PlayerSendChatMessage(10, 0, "has summoned six scorpions to their aid!")
   scorpions[1] = PerformIngameSpawn(1, scorpion, MapID, X_TL, Y_TL, Z+3, O, faction, 90000)
   scorpions[2] = PerformIngameSpawn(1, scorpion, MapID, X_TC, Y_TC, Z+3, O, faction, 90000)
   scorpions[3] = PerformIngameSpawn(1, scorpion, MapID, X_TR, Y_TR, Z+3, O, faction, 90000)
   scorpions[4] = PerformIngameSpawn(1, scorpion, MapID, X_BL, Y_BL, Z+3, O, faction, 90000)
   scorpions[5] = PerformIngameSpawn(1, scorpion, MapID, X_BC, Y_BC, Z+3, O, faction, 90000)
   scorpions[6] = PerformIngameSpawn(1, scorpion, MapID, X_BR, Y_BR, Z+3, O, faction, 90000)
   scorpions[6]:SetUnitToFollow(player,5,5) --set em to follow. spec
   scorpions[5]:SetUnitToFollow(player,5,1) --set em to follow.

   for k,v in pairs(scorpions) do
         v:SetUInt64Value( UNIT_FIELD_SUMMONEDBY, player:GetGUID() )
	 v:SetUInt64Value( UNIT_FIELD_CREATEDBY, player:GetGUID() )
	 local tar = player:GetPrimaryCombatTarget()
         if tar ~= nil and player:IsInCombat() then --if the player has an IN-COMBAT target
             v:AttackReaction(tar,1000,0) --make 1000 damage worth of threat
         else
             v:SetUnitToFollow(player,5,1) --set em to follow.
         end
         --would like angle to work as (-1)^k*k*50*(math.pi/180)
   end
   else
      player:SendAreaTriggerMessage("|cFFFF0000Item is not ready yet.|r")
   end
end

-- REGISTER ITEM GOSSIP EVENTS
if GetLuaEngine() ~= "LuaHypArc" then --to check that they're using LHA
print("LuaEngine: Did not load 'He With No Life: Summon Scorpions' script - LuaHypArc not installed.")
print("LuaEngine: Please visit http://luahyparc.zapto.org/ for more information.")
else
RegisterItemGossipEvent(entryid, 1, "summon_scorpions_item")
RegisterUnitEvent(scorpion, 18, "scorpion_OnSpawn")
end