local ox, oy = -13205.188476563, 272.10614013672
local z = 43

for i=0, 2*math.pi, 0.1 do
   if ((not (i >= 3.3 and i <= 5.0)) and (not (i <= 0.3 or i >= 5.9)) and (not (i >= 2.0 and i <= 2.5))) then
      local x = ox + 71 * math.cos(i)
      local y = oy + 71 * math.sin(i)
      local o = PLR:CalcRadAngle(x, y, ox, oy)
      local u = PLR:SpawnGameObject(24610,x,y,z,o,20000,100,1)
   end
end

--origin: -13205.188476563 272.10614013672 21.856956481934 3.7543723583221

--restrictions:
--3.3 -> 5.0
--5.9 -> 0.3
--2.0 -> 2.4

--radius: 71
--34 seats