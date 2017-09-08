class UIText_Beags_Escalation_RocketScatter extends UIText;

function Initialize()
{
	local Object ListenObj;

	InitText('');
	SetColor("0xff0000");
	Hide();
			
	ListenObj = self;
	`XEVENTMGR.RegisterForEvent(ListenObj, 'Beags_Escalation_RocketScatter', OnRocketScatter, ELD_Immediate);
}

function EventListenerReturn OnRocketScatter(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local Beags_Escalation_RocketScatterDisplay RocketScatter;
	local vector2D ScreenPos, TargetOnScreen;
	const WORLD_X_OFFSET = -140;
	const WORLD_Y_OFFSET = 100;

	RocketScatter = Beags_Escalation_RocketScatterDisplay(EventData);
	if (RocketScatter.Show && class'UIUtilities'.static.IsOnscreen(RocketScatter.Center, TargetOnScreen, WORLD_X_OFFSET, WORLD_Y_OFFSET))
	{
		ScreenPos = `PRES.GetModalMovie().ConvertNormalizedScreenCoordsToUICoords(TargetOnScreen.X, TargetOnScreen.Y, false);
		SetPosition(ScreenPos.X + WORLD_X_OFFSET + 20, ScreenPos.Y + WORLD_Y_OFFSET - 10);
		SetText("+/- " $ Left(string(RocketScatter.StdDev), InStr(string(RocketScatter.StdDev), ".") + 2));
		Show();
	}
	else
	{
		Hide();
	}

	return ELR_NoInterrupt;
}
