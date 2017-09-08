class XComGameState_Lucu_Garage_XtopodUnitState extends XComGameState_BaseObject;

var StateObjectReference		UnitRef;
var int							BankedKills;
var array<StateObjectReference>	InstalledModules;
var array<StateObjectReference> InventoryItems;
var int							PowerCurrent, PowerMax, AmmoReserve;

function XComGameState_Lucu_Garage_XtopodUnitState InitComponent(StateObjectReference Unit)
{
	UnitRef = Unit;

	RegisterEvents();

	`LOG("Xtopod Garage: Xtopod state for unit " @ XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Unit.ObjectID)).GetFullName() @ " initialized.");

	return self;
}

function RegisterEvents()
{
	//local X2EventManager EventMgr;
	//local Object ThisObj;
	
	//ThisObj = self;
	
	//EventMgr = `XEVENTMGR;
}

simulated function XComGameState_Unit GetUnitGameState(optional XComGameState CheckGameState, optional bool bExcludeHistory = false)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(CheckGameState.GetGameStateForObjectID(UnitRef.ObjectID));
	if (Unit == none && !bExcludeHistory)
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	return Unit;
}

function int GetNumAllowedUtilityItems(optional XComGameState CheckGameState, optional bool bExcludeHistory = false)
{
	local XComGameState_Item Item;

	Item = GetItemInCategory('lucu_garage_chassis', CheckGameState, bExcludeHistory);
	if (Item != none)
		return X2ChassisUpgradeTemplate_Lucu_Garage(Item.GetMyTemplate()).UtilitySlots;
	
	return 0;
}

function XComGameState_Item GetItemByName(name ItemTemplateName)
{
	local XComGameStateHistory History;
	local XComGameState_Item InventoryItemState;
	local int i;

	History = `XCOMHISTORY;

	for (i = 0; i < InventoryItems.Length; i++)
	{
		InventoryItemState = XComGameState_Item(History.GetGameStateForObjectID(InventoryItems[i].ObjectId));

		if (InventoryItemState != none && InventoryItemState.GetMyTemplateName() == ItemTemplateName)
		{
			return InventoryItemState;
		}
	}

	return none;
}

function int GetNumItemInInventory(name ItemTemplateName)
{
	local XComGameState_Item ItemState;

	ItemState = GetItemByName(ItemTemplateName);
	if (ItemState != none)
	{
		return ItemState.Quantity;
	}

	return 0;
}
simulated function XComGameState_Item GetItemGameState(StateObjectReference ItemRef, optional XComGameState CheckGameState, optional bool bExcludeHistory = false)
{
	local XComGameState_Item Item;

	Item = XComGameState_Item(CheckGameState.GetGameStateForObjectID(ItemRef.ObjectID));
	if (Item == none && !bExcludeHistory)
		Item = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemRef.ObjectID));

	return Item;
}

simulated function XComGameState_Item GetItemInCategory(name ItemCat, optional XComGameState CheckGameState, optional bool bExcludeHistory = false)
{
	local int i;
	local XComGameState_Item kItem;
	
	for (i = 0; i < InventoryItems.Length; ++i)
	{
		kItem = GetItemGameState(InventoryItems[i], CheckGameState, bExcludeHistory);
		if (kItem != none && kItem.GetMyTemplate().ItemCat == ItemCat)
			return kItem;
	}
	return none;
}

simulated function array<XComGameState_Item> GetAllItemsInCategory(name ItemCat, optional XComGameState CheckGameState, optional bool bExcludeHistory=false, optional bool bHasSize = false)
{
	local int i;
	local XComGameState_Item kItem;
	local array<XComGameState_Item> Items;
	
	for (i = 0; i < InventoryItems.Length; ++i)
	{
		kItem = GetItemGameState(InventoryItems[i], CheckGameState, bExcludeHistory);
		if (kItem != none && kItem.GetMyTemplate().ItemCat == ItemCat && (!bHasSize || kItem.GetMyTemplate().iItemSize > 0))
			Items.AddItem(kItem);
	}
	return Items;
}

function bool AddItemToInventory(XComGameState_Item Item, name ItemCat, XComGameState NewGameState)
{
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Unit Unit;
	local XComGameState_Item Chassis;

	ItemTemplate = Item.GetMyTemplate();
	if (CanAddItemToInventory(ItemTemplate, ItemCat, NewGameState, Item.Quantity))
	{
		Item.OwnerStateObject = UnitRef;

		// Add the item here for bookkeeping
		InventoryItems.AddItem(Item.GetReference());

		// Add the item as an "weapon upgrade" to the chassis
		Unit = GetUnitGameState(NewGameState);
		Chassis = Unit.GetItemInSlot(eInvSlot_Armor, NewGameState);
		Chassis.ApplyWeaponUpgradeTemplate(X2WeaponUpgradeTemplate(ItemTemplate));

		return true;
	}
	return false;
}

simulated function bool CanAddItemToInventory(const X2ItemTemplate ItemTemplate, const name ItemCat, optional XComGameState CheckGameState, optional int Quantity=1)
{
	local int i, iUtility;
	local XComGameState_Item kItem;

	if (ItemTemplate != none)
	{
		switch (ItemCat)
		{
			case 'lucu_garage_utility':
				iUtility = 0;
				for (i = 0; i < InventoryItems.Length; ++i)
				{
					kItem = GetItemGameState(InventoryItems[i], CheckGameState);
					if (kItem != none && kItem.GetMyTemplate().ItemCat == 'lucu_garage_utility')
						iUtility += kItem.GetItemSize();
				}
				return (iUtility + ItemTemplate.iItemSize <= GetNumAllowedUtilityItems());

			default:
				return (GetItemInCategory(ItemCat, CheckGameState) == none);
		}
	}
	return false;
}

simulated function bool RemoveItemFromInventory(XComGameState_Item Item, optional XComGameState CheckGameState)
{
	local int i;
	local XComGameState_Unit Unit;
	local XComGameState_Item Chassis;
	local array<name> UpgradeTemplateNames;

	if (CanRemoveItemFromInventory(Item, CheckGameState))
	{		
		for (i = 0; i < InventoryItems.Length; ++i)
		{
			if (InventoryItems[i].ObjectID == Item.ObjectID)
			{
				// Remove the item here for bookkeeping
				InventoryItems.Remove(i, 1);
				Item.OwnerStateObject.ObjectID = 0;
				Item.InventorySlot = eInvSlot_Unknown;
				
				// Remove the item as an "weapon upgrade" from the chassis
				Unit = GetUnitGameState(CheckGameState);
				Chassis = Unit.GetItemInSlot(eInvSlot_Armor, CheckGameState);
				UpgradeTemplateNames = Chassis.GetMyWeaponUpgradeTemplateNames();
				i = UpgradeTemplateNames.Find(Item.GetMyTemplateName());
				if (i != INDEX_NONE)
					Chassis.DeleteWeaponUpgradeTemplate(i);

				return true;
			}
		}
	}
	return false;
}

simulated function bool CanRemoveItemFromInventory(XComGameState_Item Item, optional XComGameState CheckGameState)
{
	local StateObjectReference Ref;

	// Check for bad items due to outdated saves
	if (Item.GetMyTemplate() == none)
		return true;

	foreach InventoryItems(Ref)
	{
		if (Ref.ObjectID == Item.ObjectID)
			return true;
	}
	return false;
}

function bool UpgradeEquipment(XComGameState NewGameState, XComGameState_Item CurrentEquipment, array<X2ItemTemplate> UpgradeTemplates, name ItemCat, optional out XComGameState_Item UpgradeItem)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item EquippedItem;
	local X2ItemTemplate UpgradeTemplate;
	local int idx;

	if (UpgradeTemplates.Length == 0)
	{
		return false;
	}

	// Grab HQ Object
	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}
	
	if (CurrentEquipment == none)
	{
		// Make an instance of the best equipment we found and equip it
		UpgradeItem = UpgradeTemplates[0].CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(UpgradeItem);
		
		return AddItemToInventory(UpgradeItem, ItemCat, NewGameState);
	}
	else
	{
		for (idx = 0; idx < UpgradeTemplates.Length; idx++)
		{
			UpgradeTemplate = UpgradeTemplates[idx];

			if (UpgradeTemplate.Tier > CurrentEquipment.GetMyTemplate().Tier)
			{
				if (X2WeaponTemplate(UpgradeTemplate) != none && X2WeaponTemplate(UpgradeTemplate).WeaponCat != X2WeaponTemplate(CurrentEquipment.GetMyTemplate()).WeaponCat)
					continue;

				// Remove the equipped item and put it back in HQ inventory
				EquippedItem = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', CurrentEquipment.ObjectID));
				NewGameState.AddStateObject(EquippedItem);
				RemoveItemFromInventory(EquippedItem, NewGameState);
				XComHQ.PutItemInInventory(NewGameState, EquippedItem);

				// Make an instance of the best equipment we found and equip it
				UpgradeItem = UpgradeTemplate.CreateInstanceFromTemplate(NewGameState);
				NewGameState.AddStateObject(UpgradeItem);
				
				return AddItemToInventory(UpgradeItem, ItemCat, NewGameState);
			}
		}
	}

	return false;
}

function ValidateLoadout(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Item EquippedChassis, EquippedPlating, UtilityItem; // Special slots
	local array<XComGameState_Item> EquippedUtilityItems; // Utility Slots
	local int idx;

	// Grab HQ Object
	History = `XCOMHISTORY;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}

	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);

	// Chassis Upgrade Slot
	EquippedChassis = GetItemInCategory('lucu_garage_chassis', NewGameState);
	if (EquippedChassis == none)
	{
		EquippedChassis = GetDefaultChassis(NewGameState);
		AddItemToInventory(EquippedChassis, 'lucu_garage_chassis', NewGameState);
	}

	// Plating Slot
	EquippedPlating = GetItemInCategory('lucu_garage_plating', NewGameState);
	if (EquippedPlating == none)
	{
		EquippedPlating = GetDefaultPlating(NewGameState);
		AddItemToInventory(EquippedPlating, 'lucu_garage_plating', NewGameState);
	}

	// Remove Extra Utility Items
	EquippedUtilityItems = GetAllItemsInCategory('lucu_garage_utility', NewGameState);
	for (idx = GetNumAllowedUtilityItems(NewGameState); idx < EquippedUtilityItems.Length; idx++)
	{
		if(idx >= EquippedUtilityItems.Length)
			break;

		UtilityItem = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', EquippedUtilityItems[idx].ObjectID));
		NewGameState.AddStateObject(UtilityItem);
		RemoveItemFromInventory(UtilityItem, NewGameState);
		Facility.PutItemInInventory(NewGameState, UtilityItem);
		UtilityItem = none;
		EquippedUtilityItems.Remove(idx, 1);
		idx--;
	}
}

function array<X2ItemTemplate> GetBestGearForItemCat(name ItemCat)
{
	local array<X2ItemTemplate> EmptyList;

	switch (ItemCat)
	{
		case 'lucu_garage_chassis':
			return GetBestChassisTemplates();
			break;
		case 'lucu_garage_plating':
			return GetBestPlatingTemplates();
			break;
		case 'lucu_garage_utility':
			return GetBestUtilityItemTemplates();
			break;
	}

	EmptyList.Length = 0;

	return EmptyList;
}

function XComGameState_Item GetDefaultChassis(XComGameState NewGameState)
{
	local array<X2ItemTemplate> ChassisTemplates;
	local XComGameState_Item ItemState;

	ChassisTemplates = GetBestChassisTemplates();

	if (ChassisTemplates.Length == 0)
		return none;

	ItemState = ChassisTemplates[`SYNC_RAND(ChassisTemplates.Length)].CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(ItemState);
	
	return ItemState;
}
function array<X2ItemTemplate> GetBestChassisTemplates()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local array<X2ItemTemplate> BestChassisTemplates;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	BestChassisTemplates.AddItem(ItemTemplateManager.FindItemTemplate('Lucu_Garage_BasicChassisUpgrade'));

	return BestChassisTemplates;
}

function XComGameState_Item GetDefaultPlating(XComGameState NewGameState)
{
	local array<X2ItemTemplate> PlatingTemplates;
	local XComGameState_Item ItemState;

	PlatingTemplates = GetBestPlatingTemplates();

	if (PlatingTemplates.Length == 0)
		return none;

	ItemState = PlatingTemplates[`SYNC_RAND(PlatingTemplates.Length)].CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(ItemState);
	
	return ItemState;
}
function array<X2ItemTemplate> GetBestPlatingTemplates()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local array<X2ItemTemplate> BestPlatingTemplates;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	BestPlatingTemplates.AddItem(ItemTemplateManager.FindItemTemplate('Lucu_Garage_BasicPlating'));

	return BestPlatingTemplates;
}

function array<X2ItemTemplate> GetBestUtilityItemTemplates()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local array<X2ItemTemplate> BestUtilityItemTemplates;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	BestUtilityItemTemplates.AddItem(ItemTemplateManager.FindItemTemplate('Lucu_Garage_MiniRocket'));

	return BestUtilityItemTemplates;
}

function AddKills(int NumKills)
{
	BankedKills += NumKills;
}

function int GetNumInstalledModules()
{
	return InstalledModules.Length;
}

function XComGameState_Item GetInstalledModule(int Slot)
{
	if (Slot < InstalledModules.Length)
		return XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(InstalledModules[Slot].ObjectID));
	return none;
}
