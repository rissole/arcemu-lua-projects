
function CommCinematicFrame_OnLoad(self)

	local width = GetScreenWidth();
	local height = GetScreenHeight();
   local blackBarHeight = 0;
	
	if ( width / height > 4 / 3) then
		local desiredHeight = width / 2;
		if ( desiredHeight > height ) then
			desiredHeight = height;
		end
		
		blackBarHeight = ( height - desiredHeight ) / 2;

		UpperBlackBar:SetHeight( blackBarHeight );
		UpperBlackBar:SetWidth( width );
		LowerBlackBar:SetHeight( blackBarHeight );
		LowerBlackBar:SetWidth( width );
	end
	
   CommMovieFrame:SetPoint("TOPLEFT", 0, blackBarHeight);
   CommMovieFrame:SetWidth(GetScreenWidth());
   CommMovieFrame:SetHeight(height - (2 * blackBarHeight));

end

function CommCinematicFrame_UnnaturalFinish()
   UIParent:Show()
   CommCinematicFrame:Hide()
   CommMovieFrame:StopMovie()
end
