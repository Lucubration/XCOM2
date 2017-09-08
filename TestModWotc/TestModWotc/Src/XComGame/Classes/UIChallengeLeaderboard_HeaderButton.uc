class UIChallengeLeaderboard_HeaderButton extends UILeaderboard_HeaderButton
	dependson (UIMPShell_Leaderboards);

simulated function OnMouseEvent(int cmd, array<string> args)
{
	local int i;
	local array<UIPanel> arrHeaderButtons;

	if (IsDisabled)
		return;

	if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
	{
		// deselect all other buttons
		screen.GetChildrenOfType(class'UIChallengeLeaderboard_HeaderButton', arrHeaderButtons);

		for(i = 0; i < arrHeaderButtons.Length; ++i)
		{
			if(arrHeaderButtons[i] != self)
				UIChallengeLeaderboard_HeaderButton(arrHeaderButtons[i]).Deselect();
		}

		// if we were previously selected, flip the sort
		if(IsSelected())
		{
			UIChallengeLeaderboards(screen).m_bFlipSort = !UIChallengeLeaderboards(screen).m_bFlipSort;
			SetArrow(UIChallengeLeaderboards(screen).m_bFlipSort );
		}
		else
			Select();

		UIChallengeLeaderboards(screen).UpdateData();
	}
	else
		super.OnMouseEvent(cmd, args);
}

simulated function Select()
{
	OnReceiveFocus();

	// if we were previously NOT selected, reset the sort flip
	UIChallengeLeaderboards(screen).m_bFlipSort = class'UIChallengeLeaderboards'.default.m_bFlipSort;
	UIChallengeLeaderboards(screen).m_eSortType = SortType;

	mc.FunctionBool("setArrowVisible", true);
	SetArrow(UIChallengeLeaderboards(screen).m_bFlipSort );
}

simulated function bool IsSelected()
{
	return UIChallengeLeaderboards(screen).m_eSortType == SortType;
}

defaultproperties
{
	//mouse events are processed by the button's bg in flash
	bProcessesMouseEvents = false;
}