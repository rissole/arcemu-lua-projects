for i,v in ipairs(_G._offsets) do
   local entry, x1, y1, z, o1, scale, pO = unpack(v)
   local o = o1+math.pi
   local x0 = x1 * math.cos(math.pi) - y1 * math.sin(math.pi)
   local y0 = x1 * math.sin(math.pi) + y1 * math.cos(math.pi)
   local x, y = PLR:GetX()-x0, PLR:GetY()-y0
   PLR:SpawnGameObject(entry,x,y,z,o,0,scale,1,1)
end