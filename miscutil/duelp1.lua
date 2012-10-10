_G._offsets = {}
for k,v in pairs(PLR:GetInRangeObjects()) do
   if (v:GetEntry() >= 550000) then
      local x1,y1,z1,pO = PLR:GetLocation()
      local x2,y2,z2,o = v:GetLocation()
      local x, y, z = x1-x2, y1-y2, z2
      local scale = v:GetScale()*100
      table.insert(_G._offsets, {v:GetEntry(), x, y, z, o, scale, pO})
   end
end