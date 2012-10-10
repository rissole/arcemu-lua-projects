local p = LuaPacket:CreatePacket(706,18); 
p:WriteULong(489)
p:WriteULong(3277)
p:WriteULong(0)
p:WriteUShort(1)
p:WriteULong(2339)
p:WriteULong(1)
PLR:SendPacketToPlayer(p)

local p = LuaPacket:CreatePacket(707, 8)
p:WriteULong(1581)
p:WriteULong(8000)
PLR:SendPacketToPlayer(p)

local p = LuaPacket:CreatePacket(707, 8)
p:WriteULong(1601)
p:WriteULong(8000)
PLR:SendPacketToPlayer(p)
