local link = COMMUNICATOR:NewLink("Cinematics")

local function OnReceive(message)
   if (message:find("START:(.+)")) then
      local _, _, fname = message:find("START:(.+)")
      print(fname)
      CommCinematic_StartCinematic(fname)
   end
end

link:HookOnReceive(OnReceive)

--------

function CommCinematic_StartCinematic(filename)
   if (CommMovieFrame:StartMovie(filename, 255)) then
      UIParent:Hide()
      CommCinematicFrame:Show()
   end
end

function CommMovieFrame_NaturalFinish(self)
   UIParent:Show()
   CommCinematicFrame:Hide()
end