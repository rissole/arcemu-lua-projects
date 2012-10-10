-----------------------
--Made by Hypersniper--
-------wow-v.com-------
---For Project Ronin---
-----------------------

function ClassDisabler(event, name, race, class)
   if (class ~= 1 and class ~= 4) then
      return 0
   end
end

RegisterServerHook(1, "ClassDisabler")