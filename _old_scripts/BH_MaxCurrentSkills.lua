function MaxCurrentSkills(pPlayer)
	local PLAYER_SKILLS = {433,44,172,45,46,54,160,229,43,55,136,473,173,176,226,228,95,162}
	for k,v in pairs(PLAYER_SKILLS) do
		if pPlayer:HasSkill(v) then
			pPlayer:AdvanceSkill(v,450)
		end
	end
end