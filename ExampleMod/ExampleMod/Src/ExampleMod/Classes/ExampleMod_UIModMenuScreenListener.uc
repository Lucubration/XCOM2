class ExampleMod_UIModMenuScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local XGParamTag MenuTextParams;

	if (Screen.IsA('UIModOptionsMenu_ModOptionsMenu'))
	{
		if (Screen.IsA('UIModOptionsMenu_MainMenuModOptionsMenu'))
		{
			`LOG("Mod Options Menu: Example Mod observed Main Menu Mod Options Menu screen. Triggering event.");

			MenuTextParams = new class'XGParamTag';
			MenuTextParams.StrValue0 = "My Example Mod";
			MenuTextParams.StrValue1 = "ExampleMod.ExampleMod_UIMainMenuModOptionsScreen";

			`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);
		}
		else if (Screen.IsA('UIModOptionsMenu_HQModOptionsMenu'))
		{
			`LOG("Mod Options Menu: Example Mod observed HQ Mod Options Menu screen. Triggering event.");

			MenuTextParams = new class'XGParamTag';
			MenuTextParams.StrValue0 = "My Example Mod";
			MenuTextParams.StrValue1 = "ExampleMod.ExampleMod_UIHQModOptionsScreen";

			`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);
		}
		else if (Screen.IsA('UIModOptionsMenu_ShellModOptionsMenu'))
		{
			`LOG("Mod Options Menu: Example Mod observed Shell Mod Options Menu screen. Triggering event.");

			MenuTextParams = new class'XGParamTag';
			MenuTextParams.StrValue0 = "My Example Mod";
			MenuTextParams.StrValue1 = "ExampleMod.ExampleMod_UIShellModOptionsScreen";

			`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);
		}
		else if (Screen.IsA('UIModOptionsMenu_TacticalModOptionsMenu'))
		{
			`LOG("Mod Options Menu: Example Mod observed Tactical Mod Options Menu screen. Triggering event.");

			MenuTextParams = new class'XGParamTag';
			MenuTextParams.StrValue0 = "My Example Mod";
			MenuTextParams.StrValue1 = "ExampleMod.ExampleMod_UITacticalModOptionsScreen";

			`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);
		}
		else if (Screen.IsA('UIModOptionsMenu_MPTacticalModOptionsMenu'))
		{
			`LOG("Mod Options Menu: Example Mod observed MP Tactical Mod Options Menu screen. Triggering event.");

			MenuTextParams = new class'XGParamTag';
			MenuTextParams.StrValue0 = "My Example Mod";
			MenuTextParams.StrValue1 = "ExampleMod.ExampleMod_UIMPTacticalModOptionsScreen";

			`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);
		}
		else if (Screen.IsA('UIModOptionsMenu_MPLobbyModOptionsMenu'))
		{
			`LOG("Mod Options Menu: Example Mod observed MP Lobby Mod Options Menu screen. Triggering event.");

			MenuTextParams = new class'XGParamTag';
			MenuTextParams.StrValue0 = "My Example Mod";
			MenuTextParams.StrValue1 = "ExampleMod.ExampleMod_UIMPLobbyModOptionsScreen";

			`XEVENTMGR.TriggerEvent('ModOptionsMenu_AddItem', MenuTextParams,, none);
		}
	}
}
