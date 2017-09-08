class UIScreenListener_Beags_Escalation_RocketScatterLabel extends UIScreenListener;

var protected UIText ScatterText;

event OnInit(UIScreen Screen)
{
	if (Screen.IsA('UITacticalHUD'))
	{
		if (Screen.GetChildByName('UIText_Beags_Escalation_RocketScatter', false) == none)
			Screen.Movie.Pres.Spawn(class'UIText_Beags_Escalation_RocketScatter', Screen).Initialize();
	}
}
