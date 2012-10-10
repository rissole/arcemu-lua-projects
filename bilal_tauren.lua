--A test at an object-oriented approach

function create_object(unit, object_ai)
   if (not type(object_ai.Create) == "function") then
      print(string.format("Failed to create ai object for unit #%d", unit:GetEntry()));
      return;
   end
   local new = {};
   setmetatable(new, object_ai);
   new.mUnit = unit;
   new:Create(unit);
end

tauren_ai = {
   __index = tauren_ai,
   id = 74101,
};

function tauren_ai:Create(unit)
   print("new object created "..tostring(self));
end

RegisterUnitEvent(tauren_ai.id, 18, function(unit) create_object(unit, tauren_ai) end);