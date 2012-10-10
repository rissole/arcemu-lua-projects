--[[
  * COMMUNICATOR - Extensible client-server communication for Arcemu.
  * Communicator allows you to do stuff when client side things happen, and vice-versa.
  * How it works, is that both the client and server 'modules' are given a particular 'linkname'.
  * The modules then send and receive messages over that link name. You can hook your own functions
  * to occur when messages are received!
  * This file provides infrastructure for client-side aspects of the system.
--]]

-- The namespace of the system
COMMUNICATOR = {}

-- Table that associates 'link names' to message handler functions
-- [linkName] = handlerFunction
local COMMS = {}

-- Metatable that handles Communicator Client Module methods
local CommSpawn = {}

--[[
  * Simply returns a new Comm module using the specified linkname (sName).
  * Throws an error if linkname is invalid (use only letters).
--]]
function COMMUNICATOR:NewLink(sName)
   assert(sName:match("^%w+$"), "Invalid link name (use letters only)")
   local new = {name = sName}
   setmetatable(new, {__index = CommSpawn})
   return new
end

--[[
  * This method fires whenever the addon frame receives an event update.
  * Whenever an addon message is received with a COMMLINK S header, this method
  * calls the appropriate linkname's listen function.
--]]
function COMMUNICATOR.OnReceive()
   -- Now we capture the name using regular expressions.
   -- string.find returns (startIndex, endIndex, capture). startIndex will be nil if this is the wrong header.
   local s, _, name = string.find(arg1, "COMMLINK_(%w+)S")
   
   if (s == nil) then return; end
   
   -- Special case: LINKEXISTS message. Send back true/false if link does/does not exist.
   if (arg2 == "LINKEXISTS") then
      local exists = tostring(COMMS[name] ~= nil)
      SendAddonMessage("COMMLINK_"..name.."C", "LINKEXISTS:"..exists, "WHISPER", UnitName("player"))
      return;
   end

   -- Other cases: call the listener
   pcall(COMMS[name], arg2)
end

--[[
  * Sets the listener for the Comm Client module to the specified function.
  * Will throw an error if func is not a function.
--]]
function CommSpawn:HookOnReceive(func)
   assert(type(func) == "function", "Invalid argument to HookOnReceive, expected function, got "..type(func))
   COMMS[self.name] = func
end

--[[
  * Sends the specified message over the Comm module.
--]]
function CommSpawn:Send(msg)
   SendAddonMessage("COMMLINK_"..self.name.."C", msg, "WHISPER", UnitName("player"))
   --DEFAULT_CHAT_FRAME:AddMessage("CLIENT ["..self.name.."]: Sent \""..msg.."\"")
end

-- Hook up receiving addon messages.
local frame = CreateFrame("Frame", nil, UIParent)
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", COMMUNICATOR.OnReceive)