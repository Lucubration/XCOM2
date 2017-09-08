class UIScreenListener_Lucu_Garage_MainMenu extends UIScreenListener;

var UIArmory_MainMenu						ArmoryMainMenu;
var delegate<UIList.OnItemSelectedCallback>	ArmoryMainMenuItemClickedCallback;

event OnInit(UIScreen Screen)
{
	local UIArmory_MainMenu ArmoryMainMenuTemp;

	ArmoryMainMenuTemp = UIArmory_MainMenu(Screen);
	if (ArmoryMainMenuTemp != none)
	{
		ArmoryMainMenu = ArmoryMainMenuTemp;
		ArmoryMainMenuItemClickedCallback = ArmoryMainMenu.List.OnItemClicked;
		ArmoryMainMenu.List.OnItemClicked = OnArmoryMainMenuItemClicked;

		`LOG("Xtopod Garage: Updated armory main menu list clicked delegate.");
	}
}

simulated function OnArmoryMainMenuItemClicked(UIList ContainerList, int ItemIndex)
{
	if (ItemIndex == 4 && ArmoryMainMenu.GetUnit().GetMyTemplateName() == 'Lucu_Garage_Xtopod')
	{
		// Not sure why Firaxis' UI goes back through the history here to grab the unit state again,
		// but I guess I should do the same?
		ShowModulesUI(ArmoryMainMenu.GetUnit().GetReference());

		`LOG("Xtopod Garage: Showing modules screen.");
	}
	else
	{
		ArmoryMainMenuItemClickedCallback(ContainerList, ItemIndex);
	}
}

function ShowModulesUI(StateObjectReference UnitRef, optional bool bInstantTransition)
{
	local UIArmory_Lucu_Garage_Modules	ModulesUI;
	
	if (ArmoryMainMenu.Movie.Pres.ScreenStack.IsNotInStack(class'UIArmory_Lucu_Garage_Modules'))
	{
		ModulesUI = UIArmory_Lucu_Garage_Modules(ArmoryMainMenu.Movie.Pres.ScreenStack.Push(ArmoryMainMenu.Spawn(class'UIArmory_Lucu_Garage_Modules', ArmoryMainMenu), ArmoryMainMenu.Movie));
		ModulesUI.InitModules(UnitRef, bInstantTransition);
	}
}
