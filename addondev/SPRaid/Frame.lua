-- Author      : Hypersniper
-- Create Date : 4/23/2008 7:41:42 AM

function B_SCISSORS_OnClick()
	local psel = 0;
	local csel = math.random(0,2);
	PLAYERC:SetText("Scissors");
	if (csel==0) then
		COMPC:SetText("Scissors");
		S_OUTCOME:SetText("Draw!");
	elseif (csel==1) then
		COMPC:SetText("Paper");
		S_OUTCOME:SetText("Win!");
		wins = wins+1;
		streak = streak+1;
		if (streak > maxstreak) then
			maxstreak = streak;
		end
	elseif (csel==2) then
		COMPC:SetText("Rock");
		S_OUTCOME:SetText("Lose!");
		losses = losses+1;
		streak = 0;		
	end
	S_COUNT:SetText("Wins: " .. wins .. "  Losses: " .. losses);
	S_STREAK:SetText("Streak: " .. streak .. "\nRecord: " .. maxstreak);
end

function B_PAPER_OnClick()
	local psel = 1;
	local csel = math.random(0,2);
	PLAYERC:SetText("Paper");
	if (csel==0) then
		COMPC:SetText("Scissors");
		S_OUTCOME:SetText("Lose!");
		losses = losses+1;
		streak = 0;
	elseif (csel==1) then
		COMPC:SetText("Paper");
		S_OUTCOME:SetText("Draw!");
	elseif (csel==2) then
		COMPC:SetText("Rock");
		S_OUTCOME:SetText("Win!");
		wins = wins+1;
		streak = streak+1;
		if (streak > maxstreak) then
			maxstreak = streak;
		end
	end
	S_COUNT:SetText("Wins: " .. wins .. "  Losses: " .. losses);
	S_STREAK:SetText("Streak: " .. streak .. "\nRecord: " .. maxstreak);
end

function B_ROCK_OnClick()
	local psel = 2;
	local csel = math.random(0,2);
	PLAYERC:SetText("Rock");
	if (csel==0) then
		COMPC:SetText("Scissors");
		S_OUTCOME:SetText("Win!");
		wins = wins+1;
		streak = streak+1;
		if (streak > maxstreak) then
			maxstreak = streak;
		end
	elseif (csel==1) then
		COMPC:SetText("Paper");
		S_OUTCOME:SetText("Lose!");
		losses = losses+1;
		streak = 0;
	elseif (csel==2) then
		COMPC:SetText("Rock");
		S_OUTCOME:SetText("Draw!");
	end
	S_COUNT:SetText("Wins: " .. wins .. "  Losses: " .. losses);
	S_STREAK:SetText("Streak: " .. streak .. "\nRecord: " .. maxstreak);
end

function SPRAIDFRAME_OnLoad()
	-- Initialize the random number generator
	math.randomseed( time() )
	math.random(); math.random(); math.random()
	wins = 0;
	losses = 0;
	streak = 0;
	maxstreak = 0;
	S_COUNT:SetText("Wins: " .. wins .. "  Losses: " .. losses);
	S_STREAK:SetText("Streak: " .. streak .. "Record: " .. maxstreak);
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("VARIABLES_LOADED");
	SPRAID_AddSlashCommand('SPR_PLAY', function() 	
	local sel = 0;
	local pname = UnitName("player");
	sel = math.random(0,2);
	if (sel == 0) then
		SendChatMessage('SPRaid Game (Random): ' .. pname .. ' played Scissors!');
	elseif (sel == 1) then
		SendChatMessage('SPRaid Game (Random): ' .. pname .. ' played Paper!');
	elseif (sel == 2) then
		SendChatMessage('SPRaid Game (Random): ' .. pname .. ' played Rock!');
	end 
	end, '/sprplay');
	SPRAID_AddSlashCommand('SPR_SHOW', function() SPRAIDFRAME:Show(); end, '/sprshow');
	SPRAID_AddSlashCommand('SPR_HIDE', function() SPRAIDFRAME:Hide(); end, '/sprhide');
	SPRAID_AddSlashCommand('SPR_PVP' , function()
	local pname = UnitName("player");
	local tname = UnitName("target");
	local choice = spr_random();
	SendAddonMessage('SPRaid Game', ' (Private): ' .. pname .. ' played ' .. choice,
	"WHISPER", tname);
	end, '/sprpvp');
	SPRAID_AddSlashCommand('SPR_HELP' , function() 
	DEFAULT_CHAT_FRAME:AddMessage("SPRaid Help",255,255,0);
	DEFAULT_CHAT_FRAME:AddMessage("  /sprplay ... Play a public game of SPR.",0,255,0);
	DEFAULT_CHAT_FRAME:AddMessage("  /sprshow ... Show the PvE SPR window.",0,255,0);
	DEFAULT_CHAT_FRAME:AddMessage("  /sprhide ... Hide the PvE SPR window.",0,255,0);
	DEFAULT_CHAT_FRAME:AddMessage("  /sprpvp  ... Play SPR privately against your current target.",0,255,0);
	end, '/sprhelp');
end

function SPRAID_AddSlashCommand(name, func, ...)
    SlashCmdList[name] = func;
    local command = '';
    for i = 1, select('#', ...) do
        command = select(i, ...);
        if strsub(command, 1, 1) ~= '/' then
            command = '/' .. command;
        end
        _G['SLASH_'..name..i] = command;
    end
end

function B_CLOSE_OnClick()
	SPRAIDFRAME:Hide();
end

function spr_random()
	local sel = math.random(0,2);
	if (sel == 0) then
		return 'Scissors!';
	elseif (sel == 1) then
		return 'Paper!';
	elseif (sel == 2) then
		return 'Rock!';
	end
end

function SPRAIDFRAME_OnEvent()
	if (event == "CHAT_MSG_ADDON" and arg1 == "SPRaid Game") then
		local pname = UnitName("player");
		local choice = spr_random();
		DEFAULT_CHAT_FRAME:AddMessage("SPRaid: Recieved SPR challenge from " .. arg4 .."!",255,255,0);
		DEFAULT_CHAT_FRAME:AddMessage(arg1 .. arg2,150,0,150);
		DEFAULT_CHAT_FRAME:AddMessage("Auto responding...",255,255,0);
		SendChatMessage('SPRaid Game (Private): ' .. pname .. ' played ' .. choice,
		"WHISPER",nil,arg4);
	end
	if (event == "VARIABLES_LOADED") then
		DEFAULT_CHAT_FRAME:AddMessage("SPRaid loaded. Use /sprhelp to start.",255,255,0);
		S_STREAK:SetText("Streak: " .. streak .. "\nRecord: " .. maxstreak);
		SPRAIDFRAME:Hide();
	end
end
