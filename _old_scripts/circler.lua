
----------User Config area---------
local npc_entry = 133702
local item_entry = 133702
----------------END----------------

local OrbitingGnome = {}
OrbitingGnome.__index = OrbitingGnome

local GNOMES = {}
local MOVE_NODE_MAX = 30
local MOVE_SPEED = 10
local MOVE_RADIUS = 5

function OrbitingGnome.Create(owner,me,move_node)
   local gnome = {}
   setmetatable(gnome, OrbitingGnome)
   gnome.owner = owner
   gnome.me = me
   gnome.move_node = move_node
   gnome.tar_X = 0
   gnome.tar_Y = 0
   gnome.tar_Z = 0
   return gnome
end

function OrbitingGnome:IncrementMoveNode()
   self.move_node = self.move_node+1
end

function OrbitingGnome:ResetMoveNode()
   self.move_node = 2
end

function OrbitingGnome:SetTarget(tar_X, tar_Y, tar_Z)
   self.tar_X = tar_X
   self.tar_Y = tar_Y
   self.tar_Z = tar_Z
end

function OrbitingGnome:MoveToTarget()
   self.me:MoveTo(self.tar_X, self.tar_Y, self.tar_Z, self.owner:GetO())
end

function OrbitingGnome:SetToTarget()
   self.me:SetPosition(self.tar_X, self.tar_Y, self.tar_Z)
end

function FindGnome(unit)
   for k,v in pairs(GNOMES) do
      if (v.me == unit) then
         return v
      end
   end
   return false
end

OBJECT_END = 0x0006
UNIT_FIELD_FLAGS = OBJECT_END + 0x0034
UNIT_FLAG_NOT_AtACKABLE_9 = 0x00000100

function Circling_Gnome_OnSpawn(pUnit)      
   pUnit:RegisterEvent("Circling_Gnome_Move", 80, 0)
   pUnit:RegisterEvent("Circling_Gnome_Search", 500, 0)
end

function Gnome_Defender_OnGossip(item, event, player)
   local spawn = player:SpawnCreature(npc_entry, player:GetX(), player:GetY(), player:GetZ(), player:GetO(), player:GetFaction(), 120000)
   local gnome = OrbitingGnome.Create(player, spawn, math.random(1, MOVE_NODE_MAX))
   gnome:SetTarget(gnome.owner:GetX()+MOVE_RADIUS*(math.cos(gnome.move_node*360/(MOVE_NODE_MAX+1)*math.pi/180)), gnome.owner:GetY()+MOVE_RADIUS*(math.sin(gnome.move_node*360/(MOVE_NODE_MAX+1)*math.pi/180)), gnome.owner:GetZ()+1)
   gnome:SetToTarget()
   spawn:ModifyFlySpeed(MOVE_SPEED)
   spawn:ModifyWalkSpeed(MOVE_SPEED)
   spawn:SetCombatCapable(1)
   spawn:SetUInt64Value(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_AtACKABLE_9)
   table.insert(GNOMES, gnome)
end

function Circling_Gnome_Search(pUnit, event)
   local gnome = FindGnome(pUnit)
   for k,v in pairs(gnome.me:GetInRangePlayers()) do
      if (gnome.me:GetDistanceYards(v) <= 5 and v ~= gnome.owner and gnome.owner:CanAtack(v)) then
         gnome.me:CastSpellOnTarget(38806, v)
         gnome.me:CastSpell(26059)
         gnome.me:RemoveEvents()
         gnome.me:Despawn(500, 0)
      end
   end
end

function Circling_Gnome_Move(pUnit)
   local gnome = FindGnome(pUnit)
   local MV = gnome.owner:GetPlayerMovementVector()
   print(MV.x..gnome.owner:GetX())
   gnome:IncrementMoveNode()
   if (gnome.move_node > MOVE_NODE_MAX) then
      gnome:ResetMoveNode()
   end
   gnome:SetTarget(MV.x+gnome.owner:GetX()+MOVE_RADIUS*(math.cos(gnome.move_node*360/(MOVE_NODE_MAX+1)*math.pi/180)), MV.y+gnome.owner:GetY()+MOVE_RADIUS*(math.sin(gnome.move_node*360/(MOVE_NODE_MAX+1)*math.pi/180)), MV.z+gnome.owner:GetZ()+1)
   if (gnome.owner:IsPlayerMoving() == false) then --if player is still
      gnome:MoveToTarget()
   else
      gnome:SetToTarget()
   end
end

RegisterUnitEvent(npc_entry, 18, "Circling_Gnome_OnSpawn")
RegisterItemGossipEvent(item_entry, 1, "Gnome_Defender_OnGossip")