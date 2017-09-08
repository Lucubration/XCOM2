class UIArmory_Lucu_Garage_Loadout extends UIArmory
	config(Lucu_Garage_DefaultConfig);

struct TUILockerItem
{
	var bool CanBeEquipped;
	var string DisabledReason;
	var XComGameState_Item Item;
};

var UIList ActiveList;

var UIPanel EquippedListContainer;
var UIList EquippedList;

var UIPanel LockerListContainer;
var UIList LockerList;

var UIArmory_LoadoutItemTooltip InfoTooltip;

var localized string m_strInventoryTitle;
var localized string m_strLockerTitle;
var localized array<string> m_strItemCatLabels;
var localized string m_strDisabledNotAnUpgrade;
var localized string m_strDisabledUtilityItemLimit;
var localized string m_strConfirmDialogTitle;
var localized string m_strConfirmDialogDescription;
var localized string m_strReplaceUpgradeTitle;
var localized string m_strReplaceUpgradeText;

var config array<name> ItemCatNames;

var XGParamTag LocTag; // optimization

simulated function InitArmory(StateObjectReference UnitRef, optional name DispEvent, optional name SoldSpawnEvent, optional name NavBackEvent, optional name HideEvent, optional name RemoveEvent, optional bool bInstant = false, optional XComGameState InitCheckGameState)
{
	super.InitArmory(UnitRef, DispEvent, SoldSpawnEvent, NavBackEvent, HideEvent, RemoveEvent, bInstant, InitCheckGameState);

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	InitializeTooltipData();
	InfoTooltip.SetPosition(1250, 430);

	MC.FunctionString("setLeftPanelTitle", m_strInventoryTitle);

	EquippedListContainer = Spawn(class'UIPanel', self);
	EquippedListContainer.bAnimateOnInit = false;
	EquippedListContainer.InitPanel('leftPanel');
	EquippedList = CreateList(EquippedListContainer);
	EquippedList.OnItemClicked = OnItemClicked;
	EquippedList.OnItemDoubleClicked = OnItemClicked;

	LockerListContainer = Spawn(class'UIPanel', self);
	LockerListContainer.bAnimateOnInit = false;
	LockerListContainer.InitPanel('rightPanel');
	LockerList = CreateList(LockerListContainer);
	LockerList.OnSelectionChanged = OnSelectionChanged;
	LockerList.OnItemClicked = OnItemClicked;
	LockerList.OnItemDoubleClicked = OnItemClicked;

	PopulateData();
}

simulated static function string GetSlotType(name ItemCat)
{
	local int SlotTypeIndex;

	SlotTypeIndex = default.ItemCatNames.Find(ItemCat);

	return default.m_strItemCatLabels[SlotTypeIndex];
}

simulated function XComGameState_Lucu_Garage_XtopodUnitState GetXtopod()
{
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility FacilityState;

	UnitState = GetUnit();
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	FacilityState = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);

	return class'Lucu_Garage_Utilities'.static.GetXtopodComponent(UnitState, FacilityState);
}

simulated function PopulateData()
{
	CreateSoldierPawn();
	UpdateEquippedList();
	UpdateLockerList();
	ChangeActiveList(EquippedList, true);
}

simulated function ResetAvailableEquipment()
{
	UpdateNavHelp();
	UpdateLockerList();
}

simulated static function CycleToSoldier(StateObjectReference NewRef)
{
	local UIArmory_Lucu_Garage_Loadout LoadoutScreen;
	local UIScreenStack ScreenStack;

	ScreenStack = `SCREENSTACK;
	LoadoutScreen = UIArmory_Lucu_Garage_Loadout(ScreenStack.GetScreen(class'UIArmory_Lucu_Garage_Loadout'));

	if (LoadoutScreen != none)
	{
		LoadoutScreen.ResetAvailableEquipment();
	}
	
	super.CycleToSoldier(NewRef);
}

simulated function LoadSoldierEquipment()
{
	XComUnitPawn(ActorPawn).CreateVisualInventoryAttachments(Movie.Pres.GetUIPawnMgr(), GetUnit(), CheckGameState);	
}

// also gets used by UIWeaponList, and UIArmory_WeaponUpgrade
simulated static function UIList CreateList(UIPanel Container)
{
	local UIBGBox BG;
	local UIList ReturnList;

	BG = Container.Spawn(class'UIBGBox', Container).InitBG('BG');

	ReturnList = Container.Spawn(class'UIList', Container);
	ReturnList.bStickyHighlight = false;
	ReturnList.bAutosizeItems = false;
	ReturnList.bAnimateOnInit = false;
	ReturnList.bSelectFirstAvailable = false;
	ReturnList.ItemPadding = 5;
	ReturnList.InitList('loadoutList');

	// this allows us to send mouse scroll events to the list
	BG.ProcessMouseEvents(ReturnList.OnChildMouseEvent);
	return ReturnList;
}

simulated function UpdateEquippedList()
{
	local int i, numUtilityItems;
	local UIArmory_Lucu_Garage_LoadoutItem Item;
	local array<XComGameState_Item> UtilityItems;
	local XComGameState_Lucu_Garage_XtopodUnitState UpdatedXtopod;

	UpdatedXtopod = GetXtopod();
	EquippedList.ClearItems();

	// Clear out tooltips from removed list items
	Movie.Pres.m_kTooltipMgr.RemoveTooltipsByPartialPath(string(EquippedList.MCPath));

	// Units can only have one item equipped in the slots below
	Item = UIArmory_Lucu_Garage_LoadoutItem(EquippedList.CreateItem(class'UIArmory_Lucu_Garage_LoadoutItem'));
	Item.InitLoadoutItem(GetEquippedItem('lucu_garage_chassis'), 'lucu_garage_chassis', true);

	Item = UIArmory_Lucu_Garage_LoadoutItem(EquippedList.CreateItem(class'UIArmory_Lucu_Garage_LoadoutItem'));
	Item.InitLoadoutItem(GetEquippedItem('lucu_garage_plating'), 'lucu_garage_plating', true);

	// Units can have multiple utility items
	numUtilityItems = UpdatedXtopod.GetNumAllowedUtilityItems();
	UtilityItems = UpdatedXtopod.GetAllItemsInCategory('lucu_garage_utility', CheckGameState);
	
	for (i = 0; i < numUtilityItems; i++)
	{
		Item = UIArmory_Lucu_Garage_LoadoutItem(EquippedList.CreateItem(class'UIArmory_Lucu_Garage_LoadoutItem'));

		if (UtilityItems.Length > i)
		{
			Item.InitLoadoutItem(UtilityItems[i], 'lucu_garage_utility', true);
		}
		else
		{
			Item.InitLoadoutItem(none, 'lucu_garage_utility', true);
		}
	}
}

simulated function UpdateLockerList()
{
	local XComGameState_Item Item;
	local StateObjectReference ItemRef;
	local name SelectedItemCat;
	local array<TUILockerItem> LockerItems;
	local TUILockerItem LockerItem;
	local array<StateObjectReference> Inventory;

	SelectedItemCat = GetSelectedItemCat();

	// set title according to selected slot
	LocTag.StrValue0 = static.GetSlotType(SelectedItemCat);
	MC.FunctionString("setRightPanelTitle", `XEXPAND.ExpandString(m_strLockerTitle));

	GetInventory(Inventory);
	foreach Inventory(ItemRef)
	{
		Item = GetItemFromHistory(ItemRef.ObjectID);
		if (ShowInLockerList(Item, SelectedItemCat))
		{
			LockerItem.Item = Item;
			LockerItem.DisabledReason = GetDisabledReason(Item, SelectedItemCat);
			LockerItem.CanBeEquipped = LockerItem.DisabledReason == ""; // sorting optimization
			LockerItems.AddItem(LockerItem);
		}
	}

	LockerList.ClearItems();

	LockerItems.Sort(SortLockerListByUpgrades);
	LockerItems.Sort(SortLockerListByTier);
	LockerItems.Sort(SortLockerListByEquip);

	foreach LockerItems(LockerItem)
	{
		UIArmory_Lucu_Garage_LoadoutItem(LockerList.CreateItem(class'UIArmory_Lucu_Garage_LoadoutItem')).InitLoadoutItem(LockerItem.Item, SelectedItemCat, false, LockerItem.DisabledReason);
	}
}

function GetInventory(out array<StateObjectReference> Inventory)
{
	Inventory = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(class'UIUtilities_Strategy'.static.GetXComHQ()).Inventory;
}

simulated function bool ShowInLockerList(XComGameState_Item Item, name SelectedItemCat)
{
	local X2ItemTemplate ItemTemplate;

	ItemTemplate = Item.GetMyTemplate();
	
	return MeetsAllStrategyRequirements(ItemTemplate.ArmoryDisplayRequirements) && MeetsDisplayRequirement(ItemTemplate) && ItemTemplate.ItemCat == SelectedItemCat;
}

// overriden in MP specific classes -tsmith
function bool MeetsAllStrategyRequirements(StrategyRequirement Requirement)
{
	return (class'UIUtilities_Strategy'.static.GetXComHQ().MeetsAllStrategyRequirements(Requirement));
}

// overriden in MP specific classes
function bool MeetsDisplayRequirement(X2ItemTemplate ItemTemplate)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	return (!XComHQ.IsTechResearched(ItemTemplate.HideIfResearched));
}

simulated function string GetDisabledReason(XComGameState_Item Item, name SelectedItemCat)
{
	local int EquippedCount;
	local string DisabledReason;
	local XComGameState_Item EquippedItem;
	local X2UtilityItemTemplate_Lucu_Garage ItemTemplate;

	// If this is a utility item, and cannot be equipped, it must be disabled because of the utility item limit restrictions
	if (SelectedItemCat == 'lucu_garage_chassis')
	{
		EquippedItem = GetXtopod().GetItemInCategory('lucu_garage_chassis');
		if (EquippedItem != none && Item.GetMyTemplate().Tier <= EquippedItem.GetMyTemplate().Tier)
			DisabledReason = default.m_strDisabledNotAnUpgrade;
	}
	if (SelectedItemCat == 'lucu_garage_utility' && DisabledReason == "")
	{
		ItemTemplate = X2UtilityItemTemplate_Lucu_Garage(Item.GetMyTemplate());
		EquippedCount = GetXtopod().GetNumItemInInventory(ItemTemplate.DataName);
		
		if (EquippedCount >= ItemTemplate.Limit)
			DisabledReason = m_strDisabledUtilityItemLimit @ string(ItemTemplate.Limit);
	}
	
	return DisabledReason;
}

simulated function int SortLockerListByEquip(TUILockerItem A, TUILockerItem B)
{
	if (A.CanBeEquipped && !B.CanBeEquipped) return 1;
	else if (!A.CanBeEquipped && B.CanBeEquipped) return -1;
	else return 0;
}

simulated function int SortLockerListByTier(TUILockerItem A, TUILockerItem B)
{
	local int TierA, TierB;

	TierA = A.Item.GetMyTemplate().Tier;
	TierB = B.Item.GetMyTemplate().Tier;

	if (TierA > TierB) return 1;
	else if (TierA < TierB) return -1;
	else return 0;
}

simulated function int SortLockerListByUpgrades(TUILockerItem A, TUILockerItem B)
{
	local int UpgradesA, UpgradesB;

	UpgradesA = A.Item.GetMyWeaponUpgradeTemplates().Length;
	UpgradesB = B.Item.GetMyWeaponUpgradeTemplates().Length;

	if (UpgradesA > UpgradesB)
	{
		return 1;
	}
	else if (UpgradesA < UpgradesB)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

simulated function ChangeActiveList(UIList kActiveList, optional bool bSkipAnimation)
{
	ActiveList = kActiveList;
	
	if (kActiveList == EquippedList)
	{
		if(!bSkipAnimation)
			MC.FunctionVoid("closeList");

		// unlock selected item
		UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetSelectedItem()).SetLocked(false);
		// disable list item selection on LockerList, enable it on EquippedList
		LockerListContainer.DisableMouseHit();
		EquippedListContainer.EnableMouseHit();

		Header.PopulateData(GetUnit());
		Navigator.RemoveControl(LockerListContainer);
		Navigator.AddControl(EquippedListContainer);
	}
	else
	{
		if(!bSkipAnimation)
			MC.FunctionVoid("openList");
		
		// lock selected item
		UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetSelectedItem()).SetLocked(true);
		// disable list item selection on LockerList, enable it on EquippedList
		LockerListContainer.EnableMouseHit();
		EquippedListContainer.DisableMouseHit();

		LockerList.SetSelectedIndex(0, true);
		Navigator.RemoveControl(EquippedListContainer);
		Navigator.AddControl(LockerListContainer);
	}
}

simulated function OnSelectionChanged(UIList ContainerList, int ItemIndex)
{
	local StateObjectReference ItemRef;
	local XComGameState_Item Item; 

	ItemRef = UIArmory_Lucu_Garage_LoadoutItem(ContainerList.GetSelectedItem()).ItemRef;
	Item = GetItemFromHistory(ItemRef.ObjectID);

	if(!UIArmory_Lucu_Garage_LoadoutItem(ContainerList.GetItem(ItemIndex)).IsDisabled)
		Header.PopulateData(GetUnit(), Item.GetReference(), UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetSelectedItem()).ItemRef);
}

simulated function OnAccept()
{
	if (ActiveList.SelectedIndex == -1)
		return;

	OnItemClicked(ActiveList, ActiveList.SelectedIndex);
}

simulated function OnItemClicked(UIList ContainerList, int ItemIndex)
{
	local X2ItemTemplate NewUpgradeTemplate;
	local UIArmory_Lucu_Garage_LoadoutItem SelectedItem;
	local XComGameState_Item PrevItem;

	if (ContainerList != ActiveList)
		return;

	if (UIArmory_Lucu_Garage_LoadoutItem(ContainerList.GetItem(ItemIndex)).IsDisabled)
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		return;
	}

	if (ContainerList == EquippedList)
	{
		UpdateLockerList();
		ChangeActiveList(LockerList);
	}
	else
	{
		SelectedItem = UIArmory_Lucu_Garage_LoadoutItem(LockerList.GetSelectedItem());
		if (SelectedItem.ItemCat == 'lucu_garage_chassis')
		{
			NewUpgradeTemplate = UIArmory_Lucu_Garage_LoadoutItem(ContainerList.GetItem(ItemIndex)).ItemTemplate;
			PrevItem = GetXtopod().GetItemInCategory('lucu_garage_chassis');

			if (PrevItem != none)
				ReplaceUpgrade(PrevItem.GetMyTemplate(), NewUpgradeTemplate);
			else
				EquipUpgrade(NewUpgradeTemplate);
		}
		else
		{
			ChangeActiveList(EquippedList);

			if (EquipItem(SelectedItem))
				UpdateData();
		}
	}
}

function EquipUpgrade(X2ItemTemplate UpgradeTemplate)
{
	local XGParamTag        kTag;
	local TDialogueBoxData  kDialogData;
		
	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = UpgradeTemplate.GetItemFriendlyName();
		
	kDialogData.eType = eDialog_Alert;
	kDialogData.strTitle = m_strConfirmDialogTitle;
	kDialogData.strText = `XEXPAND.ExpandString(m_strConfirmDialogDescription); 

	kDialogData.fnCallback = EquipUpgradeCallback;

	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	kDialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

	Movie.Pres.UIRaiseDialog(kDialogData);
}

function ReplaceUpgrade(X2ItemTemplate UpgradeToRemove, X2ItemTemplate UpgradeToInstall)
{
	local XGParamTag        kTag;
	local TDialogueBoxData  kDialogData;

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = UpgradeToRemove.GetItemFriendlyName();
	kTag.StrValue1 = UpgradeToInstall.GetItemFriendlyName();

	kDialogData.eType = eDialog_Alert;
	kDialogData.strTitle = m_strReplaceUpgradeTitle;
	kDialogData.strText = `XEXPAND.ExpandString(m_strReplaceUpgradeText);

	kDialogData.fnCallback = EquipUpgradeCallback;

	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	kDialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

	Movie.Pres.UIRaiseDialog(kDialogData);
}

simulated public function EquipUpgradeCallback(eUIAction eAction)
{
	local StateObjectReference PrevItemRef, NewItemRef;
	local XComGameState_Item PrevItem, NewItem;
	local bool CanEquip, EquipSucceeded;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Item> PrevUtilityItems;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Lucu_Garage_Facility UpdatedFacility;
	local XComGameState_Lucu_Garage_XtopodUnitState UpdatedXtopod;
	local XComGameState UpdatedState;
	
	if (eAction == eUIAction_Accept)
	{
		UpdatedState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Equip Item");
		UpdatedUnit = XComGameState_Unit(UpdatedState.CreateStateObject(class'XComGameState_Unit', GetUnit().ObjectID));
		UpdatedState.AddStateObject(UpdatedUnit);
	
		foreach UpdatedState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
			break;

		if (XComHQ == none)
		{
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
			XComHQ = XComGameState_HeadquartersXCom(UpdatedState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			UpdatedState.AddStateObject(XComHQ);
		}

		UpdatedFacility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
		UpdatedXtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(UpdatedUnit, UpdatedFacility);
	
		PrevUtilityItems = UpdatedXtopod.GetAllItemsInCategory('lucu_garage_utilities');

		NewItemRef = UIArmory_Lucu_Garage_LoadoutItem(LockerList.GetSelectedItem()).ItemRef;
		NewItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(NewItemRef.ObjectID));
		PrevItemRef = UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetSelectedItem()).ItemRef;
		PrevItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(PrevItemRef.ObjectID));

		if (PrevItem != none)
		{
			PrevItem = XComGameState_Item(UpdatedState.CreateStateObject(class'XComGameState_Item', PrevItem.ObjectID));
			UpdatedState.AddStateObject(PrevItem);
		}

		CanEquip = ((PrevItem == none || UpdatedXtopod.RemoveItemFromInventory(PrevItem, UpdatedState)) && UpdatedXtopod.CanAddItemToInventory(NewItem.GetMyTemplate(), GetSelectedItemCat(), UpdatedState));

		if (CanEquip)
		{
			UpdatedFacility.GetItemFromInventory(UpdatedState, NewItemRef, NewItem);
			NewItem = XComGameState_Item(UpdatedState.CreateStateObject(class'XComGameState_Item', NewItem.ObjectID));
			UpdatedState.AddStateObject(NewItem);

			EquipSucceeded = UpdatedXtopod.AddItemToInventory(NewItem, GetSelectedItemCat(), UpdatedState);

			if (!EquipSucceeded)
				UpdatedFacility.PutItemInInventory(UpdatedState, NewItem);
		}

		if (EquipSucceeded)
			`XSTRATEGYSOUNDMGR.PlaySoundEvent("Weapon_Attachement_Upgrade_Select");
		else
			Movie.Pres.PlayUISound(eSUISound_MenuClose);

		UpdatedXtopod.ValidateLoadout(UpdatedState);
		`XCOMGAME.GameRuleset.SubmitGameState(UpdatedState);

		ChangeActiveList(EquippedList);
		
		if (EquipSucceeded)
			UpdateData();
	}
	else
		Movie.Pres.PlayUISound(eSUISound_MenuClose);
}

simulated function UpdateData()
{
	local Rotator CachedSoldierRotation;

	CachedSoldierRotation = ActorPawn.Rotation;

	UpdateLockerList();
	UpdateEquippedList();
	CreateSoldierPawn(CachedSoldierRotation);
	Header.PopulateData(GetUnit());
}

// Override function to RequestPawnByState instead of RequestPawnByID
simulated function RequestPawn(optional Rotator DesiredRotation)
{
	ActorPawn = Movie.Pres.GetUIPawnMgr().RequestPawnByState(self, GetUnit(), GetPlacementActor().Location, DesiredRotation);
	ActorPawn.GotoState('CharacterCustomization');
}

simulated function OnCancel()
{
	local UIArmory_Loadout LoadoutScreen;

	if (ActiveList == EquippedList)
	{
		super.OnCancel(); // Exits screen

		LoadoutScreen = UIArmory_Loadout(Movie.Pres.ScreenStack.GetScreen(class'UIArmory_Loadout'));
		if (LoadoutScreen != none)
			LoadoutScreen.UpdateData();
	}	
	else
	{
		ChangeActiveList(EquippedList);
	}
}

simulated function OnRemoved()
{
	ResetAvailableEquipment();
	super.OnRemoved();
}

simulated function SetUnitReference(StateObjectReference NewUnit)
{
	super.SetUnitReference(NewUnit);
	MC.FunctionVoid("animateIn");
}

//==============================================================================

simulated function bool EquipItem(UIArmory_Lucu_Garage_LoadoutItem Item)
{
	local StateObjectReference PrevItemRef, NewItemRef;
	local XComGameState_Item PrevItem, NewItem;
	local bool CanEquip, EquipSucceeded;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Item> PrevUtilityItems;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Lucu_Garage_Facility UpdatedFacility;
	local XComGameState_Lucu_Garage_XtopodUnitState UpdatedXtopod;
	local XComGameState UpdatedState;

	UpdatedState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Equip Item");
	UpdatedUnit = XComGameState_Unit(UpdatedState.CreateStateObject(class'XComGameState_Unit', GetUnit().ObjectID));
	UpdatedState.AddStateObject(UpdatedUnit);
	
	foreach UpdatedState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		break;

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(UpdatedState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		UpdatedState.AddStateObject(XComHQ);
	}

	UpdatedFacility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	UpdatedXtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(UpdatedUnit, UpdatedFacility);
	
	PrevUtilityItems = UpdatedXtopod.GetAllItemsInCategory('lucu_garage_utilities');

	NewItemRef = Item.ItemRef;
	PrevItemRef = UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetSelectedItem()).ItemRef;
	PrevItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(PrevItemRef.ObjectID));

	if (PrevItem != none)
	{
		PrevItem = XComGameState_Item(UpdatedState.CreateStateObject(class'XComGameState_Item', PrevItem.ObjectID));
		UpdatedState.AddStateObject(PrevItem);
	}

	CanEquip = ((PrevItem == none || UpdatedXtopod.RemoveItemFromInventory(PrevItem, UpdatedState)) && UpdatedXtopod.CanAddItemToInventory(Item.ItemTemplate, GetSelectedItemCat(), UpdatedState));

	if (CanEquip)
	{
		UpdatedFacility.GetItemFromInventory(UpdatedState, NewItemRef, NewItem);
		NewItem = XComGameState_Item(UpdatedState.CreateStateObject(class'XComGameState_Item', NewItem.ObjectID));
		UpdatedState.AddStateObject(NewItem);

		EquipSucceeded = UpdatedXtopod.AddItemToInventory(NewItem, GetSelectedItemCat(), UpdatedState);

		if (EquipSucceeded)
		{
			if (PrevItem != none)
			{
				UpdatedFacility.PutItemInInventory(UpdatedState, PrevItem);
			}
		}
		else
		{
			if (PrevItem != none)
			{
				UpdatedXtopod.AddItemToInventory(PrevItem, GetSelectedItemCat(), UpdatedState);
			}

			UpdatedFacility.PutItemInInventory(UpdatedState, NewItem);
		}
	}

	UpdatedXtopod.ValidateLoadout(UpdatedState);
	`XCOMGAME.GameRuleset.SubmitGameState(UpdatedState);

	return EquipSucceeded;
}

simulated function XComGameState_Item GetEquippedItem(name ItemCat)
{
	return GetXtopod().GetItemInCategory(ItemCat, CheckGameState);
}

simulated function name GetSelectedItemCat()
{
	return UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetSelectedItem()).ItemCat;
}

// Used when selecting utility items directly from Squad Select
simulated function SelectItemSlot(name ItemCat, int ItemIndex)
{
	local int i;
	local UIArmory_Lucu_Garage_LoadoutItem Item;

	for(i = 0; i < EquippedList.ItemCount; ++i)
	{
		Item = UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetItem(i));

		// We treat grenade pocket slot like a utility slot in this case
		if (Item.ItemCat == ItemCat)
		{
			EquippedList.SetSelectedIndex(i + ItemIndex);
			break;
		}
	}
	
	ChangeActiveList(LockerList);
	UpdateLockerList();
}

simulated function SelectWeapon(name ItemCat)
{
	local int i;

	for (i = 0; i < EquippedList.ItemCount; ++i)
	{
		if (UIArmory_Lucu_Garage_LoadoutItem(EquippedList.GetItem(i)).ItemCat == ItemCat)
		{
			EquippedList.SetSelectedIndex(i);
			break;
		}
	}

	ChangeActiveList(LockerList);
	UpdateLockerList();
}

simulated function InitializeTooltipData()
{
	InfoTooltip = Spawn(class'UIArmory_LoadoutItemTooltip', self); 
	InfoTooltip.InitLoadoutItemTooltip('UITooltipInventoryItemInfo');

	InfoTooltip.bUsePartialPath = true;
	InfoTooltip.targetPath = string(MCPath); 
	InfoTooltip.RequestItem = TooltipRequestItemFromPath; 

	InfoTooltip.ID = Movie.Pres.m_kTooltipMgr.AddPreformedTooltip( InfoTooltip );
	InfoTooltip.tDelay = 0; // instant tooltips!
}

simulated function XComGameState_Item TooltipRequestItemFromPath( string currentPath )
{
	local string ItemName, TargetList;
	local array<string> Path;
	local UIArmory_Lucu_Garage_LoadoutItem Item;

	Path = SplitString( currentPath, "." );	

	foreach Path(TargetList)
	{
		//Search the path for the target list matchup
		if (TargetList == string(ActiveList.MCName))
		{
			ItemName = Path[Path.length-1];
			
			// if we've highlighted the DropItemButton, account for it in the path name
			if (ItemName == "bg")
				ItemName = Path[Path.length-3];

			Item = UIArmory_Lucu_Garage_LoadoutItem(ActiveList.GetItemNamed(Name(ItemName)));
			if (Item != none)
				return GetItemFromHistory(Item.ItemRef.ObjectID); 
		}
	}
	
	//Else we never found a target list + item
	`log("Problem in UIArmory_Lucu_Garage_Loadout for the UITooltip_InventoryInfo: couldn't match the active list at position -4 in this path: " $currentPath,,'uixcom');
	return none;
}

function XComGameState_Item GetItemFromHistory(int ObjectID)
{
	return XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ObjectID));
}

function XComGameState_Unit GetUnitFromHistory(int ObjectID)
{
	return XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ObjectID));
}

//==============================================================================

defaultproperties
{
	LibID = "LoadoutScreenMC";
	DisplayTag = "UIBlueprint_Loadout";
	CameraTag = "UIBlueprint_Loadout";
	bAutoSelectFirstNavigable = false;
}