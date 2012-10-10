DAYWATCHER = {}
DAYWATCHER.timeIndexes = {}

function DAYWATCHER.doSwap(timeIndex)
   
end

function DAYWATCHER.compareTime()

end

function DAYWATCHER.scanTime()
   local timeNow = GetGameTime()
   for index,time in pairs(DAYWATCHER.timeIndexes) do
      if (timeNow == time) then
         DAYWATCHER.doSwap(k)
         return
      end
   end
end