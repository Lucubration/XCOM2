class X2ChassisTemplate_Lucu_Garage extends X2ArmorTemplate;

// The chassis is just the bag for other inventory items
function int GetUIStatMarkup(ECharStatType Stat, optional XComGameState_Item Item)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Owner;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState_Item InventoryItem;
	local X2ItemTemplate_Lucu_Garage ItemTemplate;
	local int i, StatMarkup;

	History = `XCOMHISTORY;

	Owner = XComGameState_Unit(History.GetGameStateForObjectID(Item.OwnerStateObject.ObjectID));
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(Owner, Facility);

	StatMarkup = 0;
	for (i = 0; i < Xtopod.InventoryItems.Length; i++)
	{
		InventoryItem = XComGameState_Item(History.GetGameStateForObjectID(Xtopod.InventoryItems[i].ObjectID));
		ItemTemplate = X2ItemTemplate_Lucu_Garage(InventoryItem.GetMyTemplate());
		StatMarkup += ItemTemplate.GetUIStatMarkup(Stat, InventoryItem);
	}

	return StatMarkup;
}
