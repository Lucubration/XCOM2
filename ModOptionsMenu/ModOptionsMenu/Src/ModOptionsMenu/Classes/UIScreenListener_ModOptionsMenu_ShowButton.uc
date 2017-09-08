class UIScreenListener_ModOptionsMenu_ShowButton extends UIScreenListener;

var UIOptionsPCScreen ActiveOptionsPCScreen;

event OnInit(UIScreen Screen)
{
	local UIOptionsPCScreen OptionsPCScreen;
	local UIModOptionsMenu_ModOptionsButton ModOptionsButton;

	OptionsPCScreen = UIOptionsPCScreen(Screen);
    if (OptionsPCScreen != none && OptionsPCScreen != ActiveOptionsPCScreen)
    {
		// Update reference to the active options screen
		ActiveOptionsPCScreen = OptionsPCScreen;

		ModOptionsButton = OptionsPCScreen.Spawn(class'UIModOptionsMenu_ModOptionsButton', OptionsPCScreen);

		if (XComMainMenuController(ActiveOptionsPCScreen.PC) != none)
		{
			// Init our Mod Options button panel for the main menu controller
			ModOptionsButton.InitButton(, class'UIModOptionsMenu_ModOptionsMenu'.default.ModOptionsString, MainMenuModOptions);
		}
		else if (XComShellController(ActiveOptionsPCScreen.PC) != none)
		{
			// Init our Mod Options button panel for the shell controller
			ModOptionsButton.InitButton(, class'UIModOptionsMenu_ModOptionsMenu'.default.ModOptionsString, ShellModOptions);
		}
		else if (XComHeadquartersController(ActiveOptionsPCScreen.PC) != none)
		{
			// Init our Mod Options button panel for the strategic controller
			ModOptionsButton.InitButton(, class'UIModOptionsMenu_ModOptionsMenu'.default.ModOptionsString, HQModOptions);
		}
		else if (XComTacticalController(ActiveOptionsPCScreen.PC) != none)
		{
			// Init our Mod Options button panel for the tactical controller
			ModOptionsButton.InitButton(, class'UIModOptionsMenu_ModOptionsMenu'.default.ModOptionsString, TacticalModOptions);
		}
		else if (XComTacticalController(ActiveOptionsPCScreen.PC) != none)
		{
			// Init our Mod Options button panel for the tactical controller
			ModOptionsButton.InitButton(, class'UIModOptionsMenu_ModOptionsMenu'.default.ModOptionsString, TacticalModOptions);
		}
		else if (X2MPLobbyController(ActiveOptionsPCScreen.PC) != none)
		{
			// Init our Mod Options button panel for the multiplayer lobby controller
			ModOptionsButton.InitButton(, class'UIModOptionsMenu_ModOptionsMenu'.default.ModOptionsString, MPLobbyModOptions);
		}
		else if (XComMPTacticalController(ActiveOptionsPCScreen.PC) != none)
		{
			// Init our Mod Options button panel for the multiplayer tactical controller
			ModOptionsButton.InitButton(, class'UIModOptionsMenu_ModOptionsMenu'.default.ModOptionsString, MPTacticalModOptions);
		}

		// Position the Mod Options button
		ModOptionsButton.SetPosition(100, 790);

		`LOG("Mod Options Menu: Mod Options button shown.");
	}
}

simulated function MainMenuModOptions(UIButton Button)
{
	local XComPresentationLayerBase Pres;

	Pres = ActiveOptionsPCScreen.PC.Pres;

	if (ActiveOptionsPCScreen.Movie.Stack.GetScreen(class'UIModOptionsMenu_MainMenuModOptionsMenu') == none)
		ActiveOptionsPCScreen.Movie.Stack.Push(Pres.Spawn(class'UIModOptionsMenu_MainMenuModOptionsMenu', Pres));

	`LOG("Mod Options Menu: Main Menu Mod Options button clicked.");
}

simulated function ShellModOptions(UIButton Button)
{
	local XComPresentationLayerBase Pres;

	Pres = ActiveOptionsPCScreen.PC.Pres;

	if (ActiveOptionsPCScreen.Movie.Stack.GetScreen(class'UIModOptionsMenu_ShellModOptionsMenu') == none)
		ActiveOptionsPCScreen.Movie.Stack.Push(Pres.Spawn(class'UIModOptionsMenu_ShellModOptionsMenu', Pres));

	`LOG("Mod Options Menu: Shell Mod Options button clicked.");
}

simulated function HQModOptions(UIButton Button)
{
	local XComPresentationLayerBase Pres;
	
	Pres = ActiveOptionsPCScreen.PC.Pres;

	if (Pres.Get3DMovie().Stack.GetScreen(class'UIModOptionsMenu_HQModOptionsMenu') == none)
		Pres.Get3DMovie().Stack.Push(Pres.Spawn(class'UIModOptionsMenu_HQModOptionsMenu', Pres));

	`LOG("Mod Options Menu: HQ Mod Options button clicked.");
}

simulated function TacticalModOptions(UIButton Button)
{
	local XComPresentationLayerBase Pres;
	
	Pres = ActiveOptionsPCScreen.PC.Pres;

	if (Pres.Get3DMovie().Stack.GetScreen(class'UIModOptionsMenu_TacticalModOptionsMenu') == none)
		Pres.Get3DMovie().Stack.Push(Pres.Spawn(class'UIModOptionsMenu_TacticalModOptionsMenu', Pres));

	`LOG("Mod Options Menu: Tactical Mod Options button clicked.");
}

simulated function MPLobbyModOptions(UIButton Button)
{
	local XComPresentationLayerBase Pres;
	
	Pres = ActiveOptionsPCScreen.PC.Pres;

	if (Pres.Get3DMovie().Stack.GetScreen(class'UIModOptionsMenu_MPLobbyModOptionsMenu') == none)
		Pres.Get3DMovie().Stack.Push(Pres.Spawn(class'UIModOptionsMenu_MPLobbyModOptionsMenu', Pres));

	`LOG("Mod Options Menu: HQ Mod Options button clicked.");
}

simulated function MPTacticalModOptions(UIButton Button)
{
	local XComPresentationLayerBase Pres;
	
	Pres = ActiveOptionsPCScreen.PC.Pres;

	if (Pres.Get3DMovie().Stack.GetScreen(class'UIModOptionsMenu_MPTacticalModOptionsMenu') == none)
		Pres.Get3DMovie().Stack.Push(Pres.Spawn(class'UIModOptionsMenu_MPTacticalModOptionsMenu', Pres));

	`LOG("Mod Options Menu: HQ Mod Options button clicked.");
}
