-----------------------
--Made by Hypersniper--
----Duel Creatures-----
-----------------------

--randomise array elements... great for shuffling deck
function table.random(t)
   for i=1,10 do
      for i=1, #t do
         local temp = t[i]
         local n = math.random(#t)
         t[i] = t[n]
         t[n] = temp
      end
   end
end

--new table with same elements as passed table... also copies sub-tables
function table.copy(t)
   if (type(t) ~= "table") then
      error("table.copy expected table, got "..type(t))
	   return
   end
   local new = {}
   for k, v in pairs(t) do
      if (type(v) == "table") then
         new[k] = table.copy(v)
      else
         new[k] = v
      end
   end
   return new
end


--Module loader

module("DUELCREATURES", package.seeall)
print("Duel Creatures Loader:")

local par = getfenv(1)
local directory = "scripts/DuelCreatures/"
local modules = { "DC_Shared.script", "DC_Manager.script", "DC_Console.script", "DC_Field.script", "DC_Debug.script", "DC_ScriptMgr.script" }
for _,v in pairs(modules) do
   local loader_function, errormsg = loadfile(directory..v)
   if (loader_function == nil) then
      print(errormsg)
   else
      setfenv(loader_function, par)
      local ret, errormsg = pcall(loader_function)
      if (ret == false) then
         print(errormsg)
      else
         print(string.format("Successfully loaded script file: \"%s\"", v))
      end
   end
end

DC_DB_CACHE = {}
local DC_DB_COL_COUNT = 15

--running this will can not only be used to initially load the table but also clear and reload it if needed.
function LoadDBCache()
   local res = WorldDBQuery("SELECT * FROM duel_creatures")
   if (res == nil) then logcol(12); print("Error: No duel_creatures table data found, no card data loaded."); logcol(7); return; end
   if (res:GetColumnCount() ~= DC_DB_COL_COUNT) then
      logcol(15)
      print("Warning: column count mismatch in duel_creatures table (expected/actual) ("..DC_DB_COL_COUNT.."/"..res:GetColumnCount()..")")
      logcol(7)
      if (res:GetColumnCount() > DC_DB_COL_COUNT) then
         logcol(15)
         print("We have enough data anyway, proceeding.")
         logcol(7)
      elseif (res:GetColumnCount() < DC_DB_COL_COUNT) then
         logcol(12)
         print("Error: not enough data found, no card data loaded.")
         logcol(7)
         return
      end
   end
   DC_DB_CACHE = {}
   repeat
      local id = res:GetColumn(0):GetULong()
      DC_DB_CACHE[id] = {}
      DC_DB_CACHE[id].ItemID = res:GetColumn(1):GetULong()
      DC_DB_CACHE[id].Type = res:GetColumn(2):GetULong() --monster, spell, trap
      DC_DB_CACHE[id].Name = res:GetColumn(3):GetString()
      DC_DB_CACHE[id].EffectText = res:GetColumn(4):GetString() --if empty -> use item description
      if (DC_DB_CACHE[id].EffectText == "") then
         local res2 = WorldDBQuery(string.format("SELECT description FROM items WHERE entry='%d'", DC_DB_CACHE[id].ItemID))
         if (res2) then DC_DB_CACHE[id].EffectText = res2:GetColumn(0):GetString() end
      end
      DC_DB_CACHE[id].M_Element = res:GetColumn(5):GetULong() --dark, earth, fire, light, water, wind
      DC_DB_CACHE[id].M_Type = res:GetColumn(6):GetULong()  --beast, demon, dragonkin, elemental, humanoid, mechanical, undead
      DC_DB_CACHE[id].M_Level = res:GetColumn(7):GetULong() --stars
      DC_DB_CACHE[id].M_Display = res:GetColumn(8):GetULong()
      DC_DB_CACHE[id].M_Scale = res:GetColumn(9):GetFloat() --forced scale
      DC_DB_CACHE[id].M_KillSpell = res:GetColumn(10):GetULong() --this spell will be used as the attack visual
      DC_DB_CACHE[id].M_Attack = res:GetColumn(11):GetULong()
      DC_DB_CACHE[id].M_Defense = res:GetColumn(12):GetULong()
      DC_DB_CACHE[id].Flags = res:GetColumn(13):GetULong()
      DC_DB_CACHE[id].S_Type = res:GetColumn(14):GetULong() --SPELL_TYPE / TRAP_TYPE enums
   until (res:NextRow() == false)
   local suffix = "y"
   if (res:GetRowCount() > 1) then
      suffix = "ies"
   end
   logcol(10)
   print("Successfully loaded "..res:GetRowCount().." Duel Creatures entr"..suffix..".")
   logcol(7)
end

function RegisterCardItemGossip()
   for k,v in pairs(DC_DB_CACHE) do
      if (v.ItemID) then
         RegisterItemGossipEvent(v.ItemID, 1, function(i, e, p) par.SHARED.ShowCardInfo(k, i, p) end)
      end
   end
end

LoadDBCache()
RegisterCardItemGossip()
if (SCRIPTMGR) then SCRIPTMGR.LoadCardScripts(); end