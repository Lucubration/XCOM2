class UIScreenListener_DisableAnyClass extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local XGParamTag										MenuTextParams;

	if (Screen.IsA('UIModOptionsMenu_HQModOptionsMenu') ||
		Screen.IsA('UIModOptionsMenu_TacticalModOptionsMenu') ||
		Screen.IsA('UIModOptionsMenu_ShellModOptionsMenu') ||
		Screen.IsA('UIModOptionsMenu_MainMenuModOptionsMenu'))
	{
		`LOG("Disable Any Class: Observed Mod Options Menu screen; showing Mod Options menu item.");

		MenuTextParams = new class'XGParamTag';
		MenuTextParams.StrValue0 = "Disable Any Class";
		MenuTextParams.StrValue1 = "DisableAnyClass.UIModOptionsScreen_DisableAnyClass";

		`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);
	}

    if (Screen.IsA('UIArmory') || Screen.IsA('UIAfterAction') || Screen.IsA('UISquadSelect') || Screen.IsA('UIPersonnel'))
    {
		class'DisableAnyClass_Utilities'.static.CheckXComHQSoldierClassDeck();
	}
	else if (Screen.IsA('UIStrategyMap') || Screen.IsA('UIMission') || Screen.IsA('UIRecruitSoldiers'))
	{
		class'DisableAnyClass_Utilities'.static.CheckResistanceHQSoldierClassDeck();
	}
}
