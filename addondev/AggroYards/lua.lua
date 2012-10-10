-- Author      : Hypersniper
-- Create Date : 9/8/2008 4:58:14 PM

function getAggroRadius(tunit) 
	--First check if the unit can give aggro.
	if ((UnitExists(tunit)) and (not UnitIsPlayer(tunit)) and (UnitReaction("player",tunit) < 3) and (UnitHealth(tunit) > 0)) then
		radius = 20;
		tl = UnitLevel(tunit);
		pl = UnitLevel("player");
		--There is roughly a 1 yard of aggro per level difference,
		if (pl > tl) then
			diff = pl-tl;
			radius = radius-diff;
		--with lower level players drawing more aggro.
		elseif (pl < tl) then
			diff = tl-pl;
			radius = radius+diff;
		end
		--Mech have slighly higher aggro radius
		if (UnitCreatureType(tunit) == "Mechanical") then
			radius = radius+3;
		end
		--Mobs with 'starving' in their name have higher aggro radius
		if (strfind(UnitName(tunit), "Starving") ~= nil) then
			radius = radius+3;
		end
		--Elite mobs have higher aggro radius
		if ((UnitClassification(tunit) == "elite") or (UnitClassification(tunit) == "rareelite")) then
			radius = radius+3;
			end
		--If stealth then dramatically reduce aggro radius
		local id = 1
		while true do
			local name, rank, texture, count, type, duration, timeleft = UnitBuff("player", id);
			if not name then
				break;
			end
 			if string.match(texture, "ability_stealth") then
  				radius = radius-30;
				break;
 			end
 			id = id + 1; -- Go for the next index
		end
		--There is a minimum of 5 yards
		if (radius < 5) then
			radius = 5;
		--and a maximum of 45 yards aggro.
		elseif (radius > 45) then
			radius = 45;
		end
		
		return radius;
	end
end

function AggroRing_AddSlashCommand(name, func, ...)
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

function AGGRORINGFRAME_OnLoad()
	this:RegisterEvent("PLAYER_TARGET_CHANGED"); --change target (for updating information)
	this:RegisterEvent("PLAYER_REGEN_DISABLED"); --enter combat
	this:RegisterEvent("ADDON_LOADED");	     --for auto hiding the window
	AggroRing_AddSlashCommand('aggro_reset', function() 
	AGGRORINGFRAME:StopMovingOrSizing();
 
	AGGRORINGFRAME.isMoving = false;
 
	AGGRORINGFRAME:ClearAllPoints();
 
	AGGRORINGFRAME:SetPoint("TOP", "UIParent", "TOP", 0, -45); 
	end, '/aggroreset');
end

function AGGRORINGFRAME_OnEvent()
	if (event == "PLAYER_TARGET_CHANGED") then
		rad = getAggroRadius("target");
		if (rad == nil) then
			AGGRORINGFRAME:Hide();
		else
			AGGRORINGFRAME:Show();
			AGGRORING_Radius:SetText(rad.." yds");
		end
	elseif (event == "PLAYER_REGEN_DISABLED") then
		AGGRORINGFRAME:Hide();
	elseif (event == "ADDON_LOADED" and arg1 == "AggroYards") then
		AGGRORINGFRAME:Hide();
	end
end
		
		
		