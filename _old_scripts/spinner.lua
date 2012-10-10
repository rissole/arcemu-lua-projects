function Combat(Unit, Event)
	Unit:RegisterEvent("SpinChannelSpell", 1009, 1)
end

function SpinChannelSpell(Unit, event)
   Unit:FullCastSpell(66665)
   Unit:RegisterEvent("Spin_Casttime_delay", 1500, 1)
end

function Spin_Casttime_delay(Unit, event)
   Unit:RegisterEvent("PerformSpin", 55, 55) --40 x 9 degree rotations = 360
end

function PerformSpin(Unit, event)
   Unit:SetFacing(Unit:GetO() + math.rad(15))     --both these funcs are basically the same, just doing 
   Unit:SetOrientation(Unit:GetO() + math.rad(15)) --both for safety.
end


RegisterUnitEvent(544, 1, "Combat")