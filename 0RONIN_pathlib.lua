-----------------------
--Made by Hypersniper--
-----Project Ronin-----
-----------------------

local COORDS_ID = 0

if (type(PathLib) ~= "table") then
   PathLib = {}
   PathLib.__index = PathLib
end

---------------------------
--Internal use
---------------------------

function PathLib._DistToPoint(x,y,z,o,x2,y2,z2,o2)
   local posTar = {x, y, z}
   local posNow = {x2, y2, z2}
   local distance = 0
   for i,v in ipairs(posNow) do
      distance = distance + (v-posTar[i])^2
   end
   return math.sqrt(distance) --yards
end

function PathLib._TimeToPoint(x,y,z,o,x2,y2,z2,o2,speed)
   local dist = PathLib._DistToPoint(x,y,z,o,x2,y2,z2,o2)
   return math.floor((dist / speed) * 1000)
end

---------------------------
--Scripter use
---------------------------

function PathLib.Create(pUnit, speed, coords, func)
   if (type(coords) ~= "table" or type(speed) ~= "number" or speed <= 0) then error("PathLib: Invalid argument"); return; end
   local new = {currentNode=0, destNode=0, unit=pUnit, speed=speed, status="running", coords=coords, func=func}
   setmetatable(new, PathLib)
   return new
end

function PathLib:StartPath()
   if (self.unit:IsPlayer()) then self.unit:SetPlayerLock(1); end
   self:MoveToNode(1, true)
end

function PathLib:MoveToNode(dest, autoMoveNext)
   local pUnit = self.unit
   if (not pUnit or not pUnit:IsInWorld()) then return; end
   self.currentNode = self.destNode
   self.destNode = dest
   if (type(self.func) == "function" and self.status ~= "suspended") then
      self.status = "suspended"
      self.func(self)
      return
   end
   if (self.coords[self.destNode] == nil) then
      if (self.unit:IsPlayer()) then self.unit:SetPlayerLock(0); end
      return
   end
   local _coords = self.coords[self.destNode]
   local x1,y1,z1,o1 = pUnit:GetLocation()
   if (not pUnit:IsPlayer()) then
      pUnit:SetMovementFlags(0)
      pUnit:ModifyWalkSpeed(self.speed)
      pUnit:MoveTo(unpack(_coords))
   else --players need special treatment
      local xt, yt, zt, ot = unpack(_coords)
      pUnit:MovePlayerTo(xt, yt, zt, ot, 0, self.speed / 1000)
   end
   if (autoMoveNext == true) then
      local x2,y2,z2,o2 = unpack(_coords)
      local t = PathLib._TimeToPoint(x1,y1,z1,o1, x2, y2, z2, o2, self.speed)
      pUnit:CreateLuaEvent(function() self:MoveToNode(self.destNode + 1, true) end, t, 1)
      self.status = "running"
   end
end

function PathLib:Continue(autoMoveNext)
   if (autoMoveNext == nil) then autoMoveNext = true; end
   if (self.status == "suspended") then
      self:MoveToNode(self.destNode, autoMoveNext)
   end
end

---------------------------
--In-game use
---------------------------

function PathLib.NewCoords(name)
   local f = io.open("PathLib_coords.txt", "a")
   COORDS_ID = COORDS_ID + 1
   name = name or type(name)
   f:write("<coordset name=\""..name.."\" id="..COORDS_ID..">\n{")
   f:close()
end
PLStart = PathLib.NewCoords

function PathLib.AddCoords(x, y, z, o)
   if (type(x) == "userdata") then
      x, y, z, o = x:GetLocation()
   end
   local f = io.open("PathLib_coords.txt", "r")
   local text = f:read("*all")
   local f = io.open("PathLib_coords.txt", "a")
   local _, e = text:find("<coordset.*id="..COORDS_ID..">\n{")
   if (e ~= text:len()) then
      f:write(string.format(",\n   {%.2f,%.2f,%.2f,%.2f}", x, y, z, o))
   else
      f:write(string.format("\n   {%.2f,%.2f,%.2f,%.2f}", x, y, z, o))
   end
   f:close()
end
PLAdd = PathLib.AddCoords

function PathLib.EndCoords()
   local f = io.open("PathLib_coords.txt", "a")
   f:write("\n}\n</coordset>\n\n")
   f:close()
end
PLEnd = PathLib.EndCoords

function PathLib.Clear()
   io.open("PathLib_coords.txt", "w"):close()
   COORDS_ID = 0
end
PLClear = PathLib.Clear
