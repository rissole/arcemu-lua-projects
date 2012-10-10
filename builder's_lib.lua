-----------------------
--Made by Hypersniper--
-----Project Ronin-----
-----------------------

--Chat Lua extension: Builder commands

NORTH = 2 * math.pi;
NORTHEAST = math.pi / 4;
EAST = 3 * math.pi / 2; --according to minimap
SOUTHEAST = 3 * math.pi / 2 + math.pi / 4;
SOUTH = math.pi;
SOUTHWEST = math.pi + math.pi / 4;
WEST = math.pi / 2; --according to minimap

function SpawnGO(entry, dir, dist, scale)
   if (not PLR) then return; end
   local x = PLR:GetX() + dist * math.cos(PLR:GetO()+dir)
   local y = PLR:GetY() + dist * math.sin(PLR:GetO()+dir)
   local z = PLR:GetZ()
   scale = scale or 100
   local go = PLR:SpawnGameObject(entry, x, y, z, PLR:GetO(), 0, scale, PLR:GetPhase(), 1)
   PLR:SetSelectedGO(go)
end

function MoveGO(dir, dist)
   if (not PLR) then return; end
   local go = PLR:GetSelectedGO()
   if (not go) then PLR:SendBroadcastMessage("No GO selected"); return; end
   local x = go:GetX() + dist * math.cos(dir)
   local y = go:GetY() + dist * math.sin(dir)
   local z = go:GetZ()
   go:SetPosition(x, y, z, go:GetO(), 1)
   PLR:SetSelectedGO(go)
end

function MoveUnit(dir, dist)
   if (not PLR) then return; end
   local go = PLR:GetSelection()
   if (not go) then PLR:SendBroadcastMessage("No unit selected"); return; end
   local x = go:GetX() + dist * math.cos(go:GetO()+dir)
   local y = go:GetY() + dist * math.sin(go:GetO()+dir)
   local z = go:GetZ()
   go:SetPosition(x, y, z, go:GetO())
end

function RiseGO(dist)
   if (not PLR) then return; end
   local go = PLR:GetSelectedGO()
   if (not go) then PLR:SendBroadcastMessage("No GO selected"); return; end
   go:SetPosition(go:GetX(), go:GetY(), go:GetZ()+dist, go:GetO(), 1)
   PLR:SetSelectedGO(go)
end

function TurnMe(degs)
   if (not PLR) then return; end
   PLR:SetFacing(PLR:GetO()-math.rad(degs))
end

function SetDir(dir)
   if (not PLR) then return; end
   PLR:SetFacing(dir)
end

function FillOffsets(p, min_entry, max_entry)
   local offsets = {}
   for k,v in pairs(p:GetInRangeObjects()) do
      if ( (v:GetEntry() >= min_entry or min_entry == 0) and (v:GetEntry() <= max_entry or max_entry == 0) ) then
         local x1,y1,z1 = -13205.188476563, 272.10614013672, 21.86 --z originally 43
         local x2,y2,z2,o = v:GetLocation()
         local x, y, z = x1-x2, y1-y2, z1-z2
         local scale = v:GetScale()*100
         table.insert(offsets, {v:GetEntry(), x, y, z, o, scale})
      end
   end
   return offsets
end

function FillOffsetsAbsolute(p, min_entry, max_entry)
   local offsets = {}
   for k,v in pairs(p:GetInRangeObjects()) do
      if ( (v:GetEntry() >= min_entry or min_entry == 0) and (v:GetEntry() <= max_entry or max_entry == 0) ) then
         local x,y,z,o = v:GetLocation()
         local scale = v:GetScale()*100
         table.insert(offsets, {v:GetEntry(), x, y, z, o, scale})
      end
   end
   return offsets
end


function FileWriteOffsets(name, offsets)
   local f = io.open("offsetdump_"..name..".txt", "w")
   f:write(name:upper().."_FIELD_OFFSETS = {")
   for i,v in ipairs(offsets) do
      f:write("\n   {")
      for j=1, #v do
         f:write(v[j])
         if (j ~= #v) then f:write(", "); end
      end
      f:write("}")
      if (i ~= #offsets) then f:write(","); end
   end
   f:write("\n}")
   f:close()
end

function ClearField(p, min_entry, max_entry)
   for k,v in pairs(p:GetInRangeObjects()) do
      if ( (v:GetEntry() >= min_entry or min_entry == 0) and (v:GetEntry() <= max_entry or max_entry == 0) ) then
         v:Despawn(1, 0)
         local res = WorldDBQuery("SELECT entry FROM gameobject_spawns WHERE id="..v:GetSpawnId())
         if (res and res:GetColumn(0):GetULong() == v:GetEntry()) then
            WorldDBQuery("DELETE FROM gameobject_spawns WHERE id="..v:GetSpawnId())
         end
      end
   end
end

function SpawnByOffsets(p, offsets)
   for i,v in ipairs(offsets) do
      local entry, x1, y1, z1, o, scale = unpack(v)
      local x0,y0,z0 = -13205.188476563, 272.10614013672, 21.86 --z originally 43
      local x, y, z = x0-x1, y0-y1, z0-z1
      p:SpawnGameObject(entry,x,y,z,o,0,scale,p:GetPhase())
   end
end

function SpawnByOffsetsAbsolute(p, offsets)
   for i,v in ipairs(offsets) do
      local entry, x, y, z, o, scale = unpack(v)
      p:SpawnGameObject(entry,x,y,z,o,0,scale,p:GetPhase())
   end
end