local link = COMMUNICATOR:NewLink("CommTyping")

function TypingBossHandleSend(input)
   link:Send("INPUT:"..input)
   TypingInputFrame:Hide()
end

function TypingBossHandleCancel()
   link:Send("INPUT:")
   TypingInputFrame:Hide()
end

local function OnReceive(msg)
   if (msg:find("SHOW") == 1) then
      TypingInputFrame:Show()
   elseif (msg:find("HIDE") == 1) then
      TypingInputFrame:Hide()
   elseif (msg:find("TIMER") == 1) then
      local _, _, sec = msg:find("TIMER:(%d+)")
      sec = tonumber(sec)
      Stopwatch_StartCountdown(0, 0, sec)
      Stopwatch_Play()
   end
end

link:HookOnReceive(OnReceive)