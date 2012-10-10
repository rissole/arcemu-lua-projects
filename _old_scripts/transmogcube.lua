local CUBEENTRYID = 133703
local TRIGGERENTRYID = 133700

local info = {
{118, 4, 858}, --4x Minor Healing -> Lesser Healing
{858, 4, 929}, --4x Lesser Healing -> Healing
{929, 4, 1710}, --4x Healing -> Greater Healing
{1710, 4, 3928}, --4x Greater Healing -> Superior Healing
{3928, 4, 13446}, --4x Superior Healing -> Major Healing
{13446, 4, 22829}, --4x Major Healing -> Super Healing
{22829, 4, 33447}, --4x Super Healing -> Runic Healing
{2455, 4, 3385}, --4x Minor Mana -> Lesser Mana
{3385, 4, 3827}, --4x Lesser Mana -> Mana
{3827, 4, 6149}, --4x Mana -> Greater Mana
{6149, 4, 13443}, --4x Greater Mana -> Superior Mana
{13443, 4, 13444}, --4x Superior Mana -> Major Mana
{13444, 4, 22832}, --4x Major Mana -> Super Mana
{22832, 4, 33448}, --4x Super Mana -> Runic Mana
{2456, 10, 18253}, --10x Minor Rejuv = 1 Major Rejuv
{ {118, 2455}, {2, 2}, 2456}, --2x Minor Healing + 2x Minor Mana = Minor Rejuv
{ {13446, 13444}, {2, 2}, 18253} --2x Major Healing + 2x Major Mana = Major Rejuv
}

function hasEnough(pItem, item, reqamt)
   if (type(item) == "table" and type(reqamt) == "table") then
      for i,v in ipairs(item) do
         if (pItem:GetContainerItemCount(v) < reqamt[i]) then
            return false
         end
      end
   elseif (type(item) == "number" and type(reqamt) == "number") then
      if (pItem:GetContainerItemCount(item) < reqamt) then
         return false
      end
   end
   return true
end

function getMultiples(pItem, item, reqamt)
   if (type(item) == "table" and type(reqamt) == "table") then
      local sortMe = {}
      for i,v in ipairs(item) do
         table.insert(sortMe, math.floor(pItem:GetContainerItemCount(v) / reqamt[i]))
      end
      table.sort(sortMe)
      return sortMe[1]
   elseif (type(item) == "number" and type(reqamt) == "number") then
      return (math.floor(pItem:GetContainerItemCount(item) / reqamt))
   end
end

function doItemSwap(player, inItem, multiples, reqamt, outItem)
   if (type(inItem) == "table" and type(reqamt) == "table") then
      for i,v in ipairs(inItem) do
         player:RemoveItem(v, multiples * reqamt[i])
      end
      player:AddItem(outItem, multiples)
   elseif (type(inItem) == "number" and type(reqamt) == "number") then
      player:RemoveItem(inItem, multiples * reqamt)
      player:AddItem(outItem, multiples)
   end
end

function Cube(item, event, player)
   local cube = player:GetInventoryItemById(CUBEENTRYID)
   if (cube == nil) then 
      player:SendAreaTriggerMessage("|cFFFF0000You don't have the Transmogrification Cube.|r")
      return
   end
   if (cube:GetEquippedSlot() == -1) then
      player:SendAreaTriggerMessage("|cFFFF0000You don't have the Transmogrification Cube equipped.|r")
      return
   end
   local created = false
   for i,v in ipairs(info) do
      if (hasEnough(cube, v[1], v[2])) then
         local multiples = getMultiples(cube, v[1], v[2])
         doItemSwap(player, v[1], multiples, v[2], v[3])
         created = true
      end
   end
   if (created) then
      player:SendAreaTriggerMessage("The Transmogrification Cube successfully crafted new items!")
   else
      player:SendAreaTriggerMessage("|cFFFF0000You don't have any items that can be mixed.|r")
   end
end

RegisterItemGossipEvent(TRIGGERENTRYID, 1, "Cube")