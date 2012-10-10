--WhispAutoReply by Hypersniper on wow-v.com
WHISP_AUTO_REPLY_GUILD_INFO = "ENTER GUILD INFO HERE"

function WhispAutoReply_OnEvent()
	--This fires whenever ANY Lua event happens, so we have to select the one we want:
	if (event == "CHAT_MSG_WHISPER") then
		--arg1 = message, arg2 = sender
		if (arg1:lower() == "#guild") then
			SendChatMessage(WHISP_AUTO_REPLY_GUILD_INFO,"WHISPER",nil,arg2)
		elseif (arg1:lower() == "#invite") then
			GuildInvite(arg2) --send a guild invite
		elseif (arg1:lower() == "!summon") then --appendment for BitCrash
			SendChatMessage(".summon "..arg2, "SAY", nil)
		end 
	end
end

--This is equivelent to XML, we don't actually need XML because this is a simple frame with no fancy visual components.

local WhispAutoReply_frame = CreateFrame("Frame", nil, UIParent)
WhispAutoReply_frame:RegisterEvent("CHAT_MSG_WHISPER")
WhispAutoReply_frame:SetScript("OnEvent", WhispAutoReply_OnEvent)

--END FAKE XML




