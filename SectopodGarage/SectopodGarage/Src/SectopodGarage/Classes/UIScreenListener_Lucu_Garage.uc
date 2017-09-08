class UIScreenListener_Lucu_Garage extends UIStrategyScreenListener;

const DefaultSectopodsCount = 6;

var bool CheckedForFacilityCreation;

event OnInit(UIScreen Screen)
{
    if (IsInStrategy())
    {
		// Doing this every time so that reloads don't mess everything up
		CheckForFacilityCreation();

		// Try adding items to HQ (and Facility) storage
		UpdateHQStorage();

		AddDefaultSectopod();
	}
}

static function AddDefaultSectopod()
{
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ;
	local XComGameState_Unit				UnitState;
	local int								idx;
	local int								HasSectopods;
	
	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	
	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
		
		if (UnitState != none && UnitState.GetMyTemplateName() == 'Lucu_Garage_Xtopod')
			HasSectopods++;
	}

	for (idx = HasSectopods; idx < DefaultSectopodsCount; idx++)
		class'Lucu_Garage_Utilities'.static.GiveSecto();
}

static function UpdateHQStorage()
{
	local XComGameStateHistory					History;
	local XComGameState_HeadquartersXCom		XComHQ;
	local XComGameState_Lucu_Garage_Facility	Facility;
	local XComGameState							NewGameState;
	local bool									Updated;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add Sectopod Garage Items");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	Updated = false;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Breacher_Cnv') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Breacher_Las') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Breacher_Mag') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Breacher_Beam') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Shatterer_Cnv') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Shatterer_Las') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Shatterer_Mag') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Shatterer_Beam') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Gun_Cnv') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Gun_Las') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Gun_Mag') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Gun_Beam') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_MiniRocket') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_BlasterCannon') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_PlasmaBeam') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_WrathCannon') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_ShredderCannon') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Mortar') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_Flamethrower') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Lucu_Garage_XtopodChassis') || Updated;

	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	if (Facility != none)
	{
		Facility = XComGameState_Lucu_Garage_Facility(NewGameState.CreateStateObject(Facility.Class, Facility.ObjectID));
		NewGameState.AddStateObject(Facility);

		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_BasicChassisUpgrade') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_AdvancedChassisUpgrade') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_AlloyChassisUpgrade') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_ExperimentalChassisUpgrade') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_BasicPlating') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_RhinoPlating') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_RaptorPlating') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_AutoLoader') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_MunitionsStorage') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_ExtraCapacitors') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_AuxiliaryGenerator') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_TargetingUplink') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_AdaptiveCamo') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_HardenedArmor') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_LaserTargeter') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_AdvancedOptics') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_RedundantSystems') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_SmokescreenItem') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_AbsorptionField') || Updated;
		Updated = UpdateFacilityStorageItem(XComHQ, Facility, NewGameState, 'Lucu_Garage_ShieldGenerator') || Updated;
	}

	if (Updated)
	{
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function bool UpdateHQStorageItem(XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState, name TemplateName)
{
	local X2ItemTemplateManager				ItemTemplateMgr;
	local X2ItemTemplate					ItemTemplate;
	local XComGameState_Item				NewItemState;
	local bool								IsTechResearched, HQHasItem;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateMgr.FindItemTemplate(TemplateName);
	if (ItemTemplate != none)
	{
		IsTechResearched = ItemTemplate.StartingItem || ItemTemplate.CreatorTemplateName == '' || (ItemTemplate.CreatorTemplateName != '' && XComHQ.IsTechResearched(ItemTemplate.CreatorTemplateName));
		HQHasItem = XComHQ.HasItem(ItemTemplate);

		if (IsTechResearched && !HQHasItem)
		{
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);

			`Log("Xtopod Garage: Item " @ TemplateName @ " added to HQ.");

			return true;
		}
		else if (!IsTechResearched && HQHasItem)
		{
			NewItemState = XComHQ.GetItemByName(TemplateName);
			XComHQ.RemoveItemFromInventory(NewGameState, NewItemState.GetReference(), NewItemState.Quantity);

			`Log("Xtopod Garage: Item " @ TemplateName @ " removed from HQ.");

			return true;
		}
	}
}

static function bool UpdateFacilityStorageItem(XComGameState_HeadquartersXCom XComHQ, XComGameState_Lucu_Garage_Facility Facility, XComGameState NewGameState, name TemplateName)
{
	local X2ItemTemplateManager					ItemTemplateMgr;
	local X2ItemTemplate						ItemTemplate;
	local XComGameState_Item					NewItemState;
	local bool									IsTechResearched, FacilityHasItem;

	if (Facility == none)
		return false;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateMgr.FindItemTemplate(TemplateName);
	if (ItemTemplate != none)
	{
		IsTechResearched = ItemTemplate.StartingItem || ItemTemplate.CreatorTemplateName == '' || (ItemTemplate.CreatorTemplateName != '' && XComHQ.IsTechResearched(ItemTemplate.CreatorTemplateName));
		
		FacilityHasItem = Facility.HasItem(ItemTemplate);

		if (IsTechResearched && !FacilityHasItem)
		{
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			Facility.AddItemToInventory(NewItemState);

			`Log("Xtopod Garage: Item " @ TemplateName @ " added to Garage Facility.");

			return true;
		}
		else if (!IsTechResearched && FacilityHasItem)
		{
			NewItemState = Facility.GetItemByName(TemplateName);
			Facility.RemoveItemFromInventory(NewGameState, NewItemState.GetReference(), NewItemState.Quantity);

			`Log("Xtopod Garage: Item " @ TemplateName @ " removed from Garage Facility.");

			return true;
		}
	}
}

static function CheckForFacilityCreation()
{
	local XComGameStateHistory					History;
	local XComGameState_HeadquartersXCom		XComHQ;
	local XComGameState							NewGameState;
	local XComGameState_Lucu_Garage_Facility	FacilityState;
	
	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	
	if (class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ) == none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add Sectopod Garage Items");
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		
		FacilityState = XComGameState_Lucu_Garage_Facility(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_Facility'));
		FacilityState.Initialize();
		XComHQ.AddComponentObject(FacilityState);
		NewGameState.AddStateObject(FacilityState);

		History.AddGameStateToHistory(NewGameState);

		`LOG("Xtopod Garage: Xtopod Facility State initialized.");
	}
}
