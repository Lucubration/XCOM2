class UIScreenListener_Lucu_Garage_Loadout extends UIScreenListener;

var UIArmory_Loadout						ArmoryLoadout;
var delegate<UIList.OnItemSelectedCallback>	ArmoryLoadoutItemClickedCallback;

event OnInit(UIScreen Screen)
{
	local UIArmory_Loadout ArmoryLoadoutTemp;

	ArmoryLoadoutTemp = UIArmory_Loadout(Screen);
	if (ArmoryLoadoutTemp != none)
	{
		ArmoryLoadout = ArmoryLoadoutTemp;

		ArmoryLoadoutItemClickedCallback = ArmoryLoadout.EquippedList.OnItemClicked;
		ArmoryLoadout.EquippedList.OnItemClicked = OnEquippedItemClicked;

		`LOG("Xtopod Garage: Updated armory loadout list item clicked delegate.");
	}
}

simulated function OnEquippedItemClicked(UIList ContainerList, int ItemIndex)
{
	if (ArmoryLoadout.GetUnit().GetMyTemplateName() == 'Lucu_Garage_Xtopod')
	{
		if (ArmoryLoadout.GetSelectedSlot() == eInvSlot_Armor)
		{
			// Not sure why Firaxis' UI goes back through the history here to grab the unit state again,
			// but I guess I should do the same?
			ShowLoadoutUI(ArmoryLoadout.GetUnit().GetReference());

			`LOG("Xtopod Garage: Showing loadout screen.");
			
			return;
		}
	}

	ArmoryLoadoutItemClickedCallback(ContainerList, ItemIndex);
}

function ShowLoadoutUI(StateObjectReference UnitRef)
{
	local UIArmory_Lucu_Garage_Loadout	LoadoutUI;
	
	if (ArmoryLoadout.Movie.Pres.ScreenStack.IsNotInStack(class'UIArmory_Lucu_Garage_Loadout'))
	{
		LoadoutUI = UIArmory_Lucu_Garage_Loadout(ArmoryLoadout.Movie.Pres.ScreenStack.Push(ArmoryLoadout.Spawn(class'UIArmory_Lucu_Garage_Loadout', ArmoryLoadout), ArmoryLoadout.Movie));
		LoadoutUI.InitArmory(UnitRef, '', '', '', '', '', true);
	}
}
