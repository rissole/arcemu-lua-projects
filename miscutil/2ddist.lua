local x1,y1 = PLR:GetLocation()
local x2,y2 = SEL:GetLocation()
dist = math.sqrt( (x1-x2)^2 + (y1-y2)^2 )
print(dist)

