class UIScreenListener_DisableAnyClassWotc extends UIScreenListener;

event OnInit(UIScreen Screen)
{
    local DisableAnyClassWotc_MCMScreen ModConfigScreen;

    // Everything out here runs on every UIScreen. Not great but necessary.
	if (MCM_API(Screen) != none)
	{
		// Everything in here runs only when you need to touch MCM.
        ModConfigScreen = new class'DisableAnyClassWotc_MCMScreen';
        ModConfigScreen.OnInit(Screen);
	}
    
    if (Screen.IsA('UIFacility') || Screen.IsA('UIArmory') || Screen.IsA('UIAfterAction') || Screen.IsA('UISquadSelect') || Screen.IsA('UIPersonnel'))
    {
		class'DisableAnyClassWotc_Utilities'.static.CheckXComHQSoldierClassDeck();
	}
	else if (Screen.IsA('UIStrategyMap') || Screen.IsA('UIMission') || Screen.IsA('UIRecruitSoldiers'))
	{
		class'DisableAnyClassWotc_Utilities'.static.CheckResistanceHQSoldierClassDeck();
	}
}

DefaultProperties
{
    ScreenClass = none;
}