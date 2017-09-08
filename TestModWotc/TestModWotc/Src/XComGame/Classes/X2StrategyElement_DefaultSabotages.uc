//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultSabotages.uc
//  AUTHOR:  Mark Nauta  --  11/22/2016
//  PURPOSE: Create templates for Chosen Sabotages
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultSabotages extends X2StrategyElement config(GameData);

var config array<float>		CargoHoldPercentDecrease;
var config array<int>		CargoHoldMin;
var config array<float>		ServerArrayPercentDecrease;
var config array<int>		ServerArrayMinimum;
var config array<int>		LongRangeCommsHours;
var config array<int>		ScannerArrayDays;
var config array<int>		ResearchLabsDays;
var config array<int>		LabStorageMinDatapads;
var config array<int>		LabStorageMaxDatapads;
var config array<int>		InfirmaryDays;
var config array<int>		SoldierCommsNumSoldiers;
var config array<int>		WoundStaffMinDays;
var config array<int>		WoundStaffMaxDays;
var config array<int>		MinSecureStorageCores;
var config array<int>		MaxSecureStorageCores;
var config array<int>		MinWeaponLockersMods;
var config array<int>		MaxWeaponLockersMods;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Sabotages;

	Sabotages.AddItem(CreateScannerArrayTemplate());
	Sabotages.AddItem(CreateResearchLabsTemplate());
	Sabotages.AddItem(CreateCrewQuartersTemplate());
	Sabotages.AddItem(CreateSecureStorageTemplate());
	Sabotages.AddItem(CreateCargoHoldTemplate());
	Sabotages.AddItem(CreateServerArrayTemplate());
	Sabotages.AddItem(CreateLongRangeCommsTemplate());
	Sabotages.AddItem(CreateSoldierCommsTemplate());
	Sabotages.AddItem(CreateWeaponLockersTemplate());
	Sabotages.AddItem(CreateLabStorageTemplate());
	Sabotages.AddItem(CreateEncryptionServerTemplate());
	Sabotages.AddItem(CreateInfirmaryTemplate());

	return Sabotages;
}

//#############################################################################################
//----------------   SABOTAGES  ---------------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateScannerArrayTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_ScannerArray');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateScannerArray;
	Template.CanActivateFn = CanActivateScannerArray;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateScannerArray(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ScanningSite ScanSiteState;
	local XComGameState_ChosenAction ActionState;
	local int ScanDays;

	ScanDays = `ScaleStrategyArrayInt(default.ScannerArrayDays);
	XComHQ = GetAndAddXComHQ(NewGameState);
	ScanSiteState = XComHQ.GetCurrentScanningSite();

	if(ScanSiteState != none)
	{
		ScanSiteState = XComGameState_ScanningSite(NewGameState.ModifyStateObject(class'XComGameState_ScanningSite', ScanSiteState.ObjectID));
		ScanSiteState.AddScanDays(ScanDays);
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_ScannerArray'), string(ScanDays));
}
//---------------------------------------------------------------------------------------
static function bool CanActivateScannerArray()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ScanningSite ScanSiteState;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	ScanSiteState = XComHQ.GetCurrentScanningSite();
	return (ScanSiteState != none && !ScanSiteState.IsScanRepeatable());
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateResearchLabsTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_ResearchLabs');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateResearchLabs;
	Template.CanActivateFn = CanActivateResearchLabs;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateResearchLabs(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectResearch ResearchProject;
	local int ResearchDays;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	ResearchProject = XComHQ.GetCurrentResearchProject();

	ResearchDays = `ScaleStrategyArrayInt(default.ResearchLabsDays);
	ResearchProject = XComGameState_HeadquartersProjectResearch(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersProjectResearch', ResearchProject.ObjectID));
	ResearchProject.AddResearchDays(ResearchDays);

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_ResearchLabs'), string(ResearchDays));
}
//---------------------------------------------------------------------------------------
static function bool CanActivateResearchLabs()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectResearch ResearchProject;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	ResearchProject = XComHQ.GetCurrentResearchProject();

	return (ResearchProject != none);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateCrewQuartersTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_CrewQuarters');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateCrewQuarters;
	Template.CanActivateFn = ExistsValidStaffForWounding;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateCrewQuarters(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameState_Unit UnitState;
	local string PersonnelString;
	local int ProjectDays;

	UnitState = WoundRandomScientistOrEngineer(NewGameState, ProjectDays);
	PersonnelString = "";

	if(UnitState != none)
	{
		PersonnelString = "\n\n";

		if(UnitState.IsEngineer())
		{
			PersonnelString $= class'XGLocalizedData'.default.StaffTypeNames[eStaff_Engineer];
		}
		else
		{
			PersonnelString $= class'XGLocalizedData'.default.StaffTypeNames[eStaff_Scientist];
		}

		PersonnelString @= UnitState.GetName(eNameType_Full) $ ":" @ 
			class'X2StrategyGameRulesetDataStructures'.default.WoundStatusStrings[1] @ ProjectDays @ class'UIUtilities_Text'.static.GetDaysString(ProjectDays);
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_CrewQuarters'), , , PersonnelString);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateSecureStorageTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_SecureStorage');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateSecureStorage;
	Template.CanActivateFn = CanActivateSecureStorage;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateSecureStorage(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ChosenAction ActionState;
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;
	local string PersonnelString;
	local int ProjectDays, MinCores, MaxCores, NumCores, idx, NumRemoved;

	History = `XCOMHISTORY;
	XComHQ = GetAndAddXComHQ(NewGameState);
	NumCores = class'UIUtilities_Strategy'.static.GetResource('EleriumCore');
	MinCores = `ScaleStrategyArrayInt(default.MinSecureStorageCores);
	MinCores = min(MinCores, NumCores);
	MaxCores = `ScaleStrategyArrayInt(default.MaxSecureStorageCores);
	MaxCores = min(MaxCores, NumCores);
	NumRemoved = `SYNC_RAND_STATIC(MaxCores - MinCores + 1) + 1;

	for(idx = 0; idx < XComHQ.Inventory.Length; idx++)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(XComHQ.Inventory[idx].ObjectID));

		if(ItemState != none)
		{
			if(ItemState.GetMyTemplateName() == 'EleriumCore')
			{
				XComHQ.RemoveItemFromInventory(NewGameState, ItemState.GetReference(), NumRemoved);
				break;
			}
		}
	}

	UnitState = WoundRandomScientistOrEngineer(NewGameState, ProjectDays);
	PersonnelString = "";

	if(UnitState != none)
	{
		PersonnelString = "\n\n";

		if(UnitState.IsEngineer())
		{
			PersonnelString $= class'XGLocalizedData'.default.StaffTypeNames[eStaff_Engineer];
		}
		else
		{
			PersonnelString $= class'XGLocalizedData'.default.StaffTypeNames[eStaff_Scientist];
		}

		PersonnelString @= UnitState.GetName(eNameType_Full) $ ":" @
			class'X2StrategyGameRulesetDataStructures'.default.WoundStatusStrings[1] @ ProjectDays @ class'UIUtilities_Text'.static.GetDaysString(ProjectDays);
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_SecureStorage'), string(NumRemoved), , PersonnelString);
}
//---------------------------------------------------------------------------------------
static function bool CanActivateSecureStorage()
{
	return (class'UIUtilities_Strategy'.static.GetResource('EleriumCore') > 0 && ExistsValidStaffForWounding());
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateCargoHoldTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_CargoHold');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateCargoHold;
	Template.CanActivateFn = CanActivateCargoHold;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateCargoHold(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ChosenAction ActionState;
	local float PercentDecrease;
	local int SupplyMin, SuppliesToRemove, TotalSupplies;

	XComHQ = GetAndAddXComHQ(NewGameState);
	PercentDecrease = `ScaleStrategyArrayFloat(default.CargoHoldPercentDecrease);
	SupplyMin = `ScaleStrategyArrayInt(default.CargoHoldMin);
	TotalSupplies = XComHQ.GetResourceAmount('Supplies');
	SuppliesToRemove = Round(float(TotalSupplies) * PercentDecrease);
	
	if(SupplyMin > TotalSupplies)
	{
		SupplyMin = TotalSupplies;
	}

	if(SuppliesToRemove < SupplyMin)
	{
		SuppliesToRemove = SupplyMin;
	}

	XComHQ.AddResource(NewGameState, 'Supplies', -SuppliesToRemove);

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_CargoHold'), string(SuppliesToRemove));
}
//---------------------------------------------------------------------------------------
static function bool CanActivateCargoHold()
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	return (`ScaleStrategyArrayInt(default.CargoHoldMin) >= XComHQ.GetResourceAmount('Supplies'));
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateServerArrayTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_ServerArray');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateServerArray;
	Template.CanActivateFn = CanActivateServerArray;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateServerArray(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ChosenAction ActionState;
	local float PercentDecrease;
	local int IntelMin, IntelToRemove, TotalIntel;

	XComHQ = GetAndAddXComHQ(NewGameState);
	PercentDecrease = `ScaleStrategyArrayFloat(default.ServerArrayPercentDecrease);
	IntelMin = `ScaleStrategyArrayInt(default.ServerArrayMinimum);
	TotalIntel = XComHQ.GetResourceAmount('Intel');
	IntelToRemove = Round(float(TotalIntel) * PercentDecrease);

	if(IntelMin > TotalIntel)
	{
		IntelMin = TotalIntel;
	}

	if(IntelToRemove < IntelMin)
	{
		IntelToRemove = IntelMin;
	}

	XComHQ.AddResource(NewGameState, 'Intel', -IntelToRemove);

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_ServerArray'), string(IntelToRemove));
}
//---------------------------------------------------------------------------------------
static function bool CanActivateServerArray()
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	return (`ScaleStrategyArrayInt(default.ServerArrayMinimum) >= XComHQ.GetResourceAmount('Intel'));
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateLongRangeCommsTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_LongRangeComms');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateLongRangeComms;
	Template.CanActivateFn = CanActivateLongRangeComms;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateLongRangeComms(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_ChosenAction ActionState;
	local XComGameState_CovertAction CovertAction, NewCovertAction;
	
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_CovertAction', CovertAction)
	{
		if (CovertAction.bStarted)
		{
			NewCovertAction = XComGameState_CovertAction(NewGameState.ModifyStateObject(class'XComGameState_CovertAction', CovertAction.ObjectID));
			NewCovertAction.AddHoursToComplete(`ScaleStrategyArrayInt(default.LongRangeCommsHours));
		}
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_LongRangeComms'));
}
//---------------------------------------------------------------------------------------
static function bool CanActivateLongRangeComms()
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	return (ResHQ.IsCovertActionInProgress());
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateSoldierCommsTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_SoldierComms');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateSoldierComms;
	Template.CanActivateFn = CanActivateSoldierComms;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateSoldierComms(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;
	local int Count, RequiredCount, RandIndex;
	local array<XComGameState_Unit> ValidUnits;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	RequiredCount = `ScaleStrategyArrayInt(default.SoldierCommsNumSoldiers);
	Count = 0;

	foreach XComHQ.Crew(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

		if(UnitValidForSoldierComms(UnitState))
		{
			ValidUnits.AddItem(UnitState);
		}
	}

	while(Count < RequiredCount && ValidUnits.Length > 0)
	{
		RandIndex = `SYNC_RAND_STATIC(ValidUnits.Length);
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ValidUnits[RandIndex].ObjectID));
		UnitState.AcquireTrait(NewGameState, 'FearOfChosen', true);
		ValidUnits.Remove(RandIndex, 1);
		Count++;
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_SoldierComms'));
}
//---------------------------------------------------------------------------------------
static function bool CanActivateSoldierComms()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;
	local int Count, RequiredCount;
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	RequiredCount = `ScaleStrategyArrayInt(default.SoldierCommsNumSoldiers);
	Count = 0;

	foreach XComHQ.Crew(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

		if(UnitValidForSoldierComms(UnitState))
		{
			Count++;

			if(Count >= RequiredCount)
			{
				return true;
			}
		}
	}

	return false;
}
//---------------------------------------------------------------------------------------
private static function bool UnitValidForSoldierComms(XComGameState_Unit UnitState)
{
	return (UnitState != none && UnitState.IsSoldier() && UnitState.GetStatus() == eStatus_Active && UnitState.CanAcquireTrait() &&
			UnitState.AcquiredTraits.Find('FearOfChosen') == INDEX_NONE);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateWeaponLockersTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_WeaponLockers');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateWeaponLockers;
	Template.CanActivateFn = CanActivateWeaponLockers;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateWeaponLockers(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState;
	local StateObjectReference ItemRef;
	local X2WeaponUpgradeTemplate UpgradeTemplate;
	local array<StateObjectReference> InventoryItems;
	local array<XComGameState_Item> AllWeaponMods;
	local int TotalMods, MinMods, MaxMods, ModsToRemove, idx, RandIndex;

	History = `XCOMHISTORY;
	XComHQ = GetAndAddXComHQ(NewGameState);
	InventoryItems = XComHQ.Inventory;
	TotalMods = 0;

	foreach InventoryItems(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));

		if(ItemState != none)
		{
			UpgradeTemplate = X2WeaponUpgradeTemplate(ItemState.GetMyTemplate());

			if(UpgradeTemplate != none)
			{
				TotalMods += ItemState.Quantity;
				AllWeaponMods.AddItem(ItemState);
			}
		}
	}

	MinMods = `ScaleStrategyArrayInt(default.MinWeaponLockersMods);
	MaxMods = `ScaleStrategyArrayInt(default.MaxWeaponLockersMods);
	ModsToRemove = MinMods + `SYNC_RAND_STATIC(MaxMods - MinMods + 1);
	ModsToRemove = Clamp(ModsToRemove, 0, TotalMods);

	for(idx = 0; idx < ModsToRemove; idx++)
	{
		RandIndex = `SYNC_RAND_STATIC(AllWeaponMods.Length);
		ItemState = AllWeaponMods[RandIndex];

		if(ItemState.Quantity == 1)
		{
			AllWeaponMods.Remove(RandIndex, 1);
		}

		XComHQ.RemoveItemFromInventory(NewGameState, ItemState.GetReference(), 1);
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_WeaponLockers'), string(ModsToRemove));
}
//---------------------------------------------------------------------------------------
function bool CanActivateWeaponLockers()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState;
	local StateObjectReference ItemRef;
	local X2WeaponUpgradeTemplate UpgradeTemplate;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	foreach XComHQ.Inventory(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));

		if(ItemState != none)
		{
			UpgradeTemplate = X2WeaponUpgradeTemplate(ItemState.GetMyTemplate());

			if(UpgradeTemplate != none)
			{
				return true;
			}
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateLabStorageTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_LabStorage');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateLabStorage;
	Template.CanActivateFn = CanActivateLabStorage;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateLabStorage(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState, DataPadState, DataCacheState;
	local StateObjectReference ItemRef;
	local int NumToRemove, DataPadQuantity, DataPadToRemove, DataCacheQuantity, DataCacheToRemove;
	local bool bDataPad;

	History = `XCOMHISTORY;
	XComHQ = GetAndAddXComHQ(NewGameState);
	DataPadQuantity = 0;
	DataPadToRemove = 0;
	DataCacheQuantity = 0;
	DataCacheToRemove = 0;

	foreach XComHQ.Inventory(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));

		if(ItemState != none)
		{
			if(ItemState.GetMyTemplateName() == 'AdventDatapad')
			{
				DataPadState = ItemState;
				DataPadQuantity = DataPadState.Quantity;
			}
			else if(ItemState.GetMyTemplateName() == 'AlienDatapad')
			{
				DataCacheState = ItemState;
				DataCacheQuantity = DataCacheState.Quantity;
			}
		}

		if(DatapadState != none && DataCacheState != none)
		{
			break;
		}
	}

	NumToRemove = `ScaleStrategyArrayInt(default.LabStorageMinDatapads) + 
				  `SYNC_RAND_STATIC(`ScaleStrategyArrayInt(default.LabStorageMaxDatapads) - `ScaleStrategyArrayInt(default.LabStorageMinDatapads) + 1);
	bDataPad = class'X2StrategyGameRulesetDataStructures'.static.Roll(50);

	while(NumToRemove > 0 && (DataPadQuantity > 0 || DataCacheQuantity > 0))
	{
		if((bDataPad && DataPadQuantity == 0) || (!bDataPad && DataCacheQuantity == 0))
		{
			bDataPad = !bDataPad;
		}

		if(bDataPad)
		{
			DataPadToRemove++;
			DataPadQuantity--;
		}
		else
		{
			DataCacheToRemove++;
			DataCacheQuantity--;
		}

		bDataPad = !bDataPad;
		NumToRemove--;
	}

	if(DataPadToRemove > 0)
	{
		XComHQ.RemoveItemFromInventory(NewGameState, DataPadState.GetReference(), DataPadToRemove);
	}

	if(DataCacheToRemove > 0)
	{
		XComHQ.RemoveItemFromInventory(NewGameState, DataCacheState.GetReference(), DataCacheToRemove);
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_LabStorage'), string(DataPadToRemove + DataCacheToRemove));
}
//---------------------------------------------------------------------------------------
function bool CanActivateLabStorage()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState;
	local StateObjectReference ItemRef;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	foreach XComHQ.Inventory(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));

		if(ItemState != none && (ItemState.GetMyTemplateName() == 'AdventDatapad' || ItemState.GetMyTemplateName() == 'AlienDatapad'))
		{
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateEncryptionServerTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_EncryptionServer');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateEncryptionServer;
	Template.CanActivateFn = CanActivateEncryptionServer;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateEncryptionServer(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameStateHistory History;
	local XComGameState_BlackMarket MarketState;

	History = `XCOMHISTORY;
	MarketState = XComGameState_BlackMarket(History.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));
	MarketState = XComGameState_BlackMarket(NewGameState.ModifyStateObject(class'XComGameState_BlackMarket', MarketState.ObjectID));
	MarketState.CleanUpForSaleItems(NewGameState);

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_EncryptionServer'));
}
//---------------------------------------------------------------------------------------
function bool CanActivateEncryptionServer()
{
	local XComGameStateHistory History;
	local XComGameState_BlackMarket MarketState;

	History = `XCOMHISTORY;
	MarketState = XComGameState_BlackMarket(History.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));

	return (MarketState.bIsOpen && MarketState.ForSaleItems.Length > 0);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInfirmaryTemplate()
{
	local X2SabotageTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SabotageTemplate', Template, 'Sabotage_Infirmary');
	Template.Category = "Sabotage";
	Template.OnActivatedFn = ActivateInfirmary;
	Template.CanActivateFn = CanActivateInfirmary;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateInfirmary(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectHealSoldier HealProject;
	local StateObjectReference ProjectRef;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	foreach XComHQ.Projects(ProjectRef)
	{
		HealProject = XComGameState_HeadquartersProjectHealSoldier(History.GetGameStateForObjectID(ProjectRef.ObjectID));

		if(HealProject != none)
		{
			HealProject = XComGameState_HeadquartersProjectHealSoldier(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersProjectHealSoldier', HealProject.ObjectID));
			HealProject.AddRecoveryDays(`ScaleStrategyArrayInt(default.InfirmaryDays));
		}
	}

	ActionState = XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectID));
	StoreSabotageString(ActionState, GetSabotageTemplate('Sabotage_Infirmary'));
}
//---------------------------------------------------------------------------------------
function bool CanActivateInfirmary()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectHealSoldier HealProject;
	local StateObjectReference ProjectRef;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(!XComHQ.HasFacilityByName('AdvancedWarfareCenter'))
	{
		return false;
	}

	foreach XComHQ.Projects(ProjectRef)
	{
		HealProject = XComGameState_HeadquartersProjectHealSoldier(History.GetGameStateForObjectID(ProjectRef.ObjectID));

		if(HealProject != none)
		{
			return true;
		}
	}

	return false;
}

//#############################################################################################
//----------------   HELPERS  -----------------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersXCom GetAndAddXComHQ(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	return XComHQ;
}

//---------------------------------------------------------------------------------------
static function X2SabotageTemplate GetSabotageTemplate(name TemplateName)
{
	local X2StrategyElementTemplateManager StratMgr;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	return X2SabotageTemplate(StratMgr.FindStrategyElementTemplate(TemplateName));
}

//---------------------------------------------------------------------------------------
static function StoreSabotageString(XComGameState_ChosenAction ActionState, X2SabotageTemplate SabotageTemplate, optional string strFirstValue = "", optional string strSecondValue = "", 
									optional string strAppend)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = strFirstValue;
	ParamTag.StrValue1 = strSecondValue;
	ActionState.StoredDescription = `XEXPAND.ExpandString(SabotageTemplate.SummaryText) $ strAppend;
	ActionState.StoredShortDescription = `XEXPAND.ExpandString(SabotageTemplate.ShortSummaryText) $ strAppend;
}

//---------------------------------------------------------------------------------------
static function bool ExistsValidStaffForWounding()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	foreach XComHQ.Crew(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

		if(IsStaffValidForWounding(UnitState))
		{
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function XComGameState_Unit WoundRandomScientistOrEngineer(XComGameState NewGameState, out int ProjectDays)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectHealSoldier ProjectState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local array<XComGameState_Unit> UnstaffedSci, UnstaffedEng, StaffedSci, StaffedEng;
	local StateObjectReference UnitRef;
	local bool bCanWoundEng, bCanWoundSci, bWoundEng;
	local int MinDaysToAdd, MaxDaysToAdd, ProjectHours;

	History = `XCOMHISTORY;
	XComHQ = GetAndAddXComHQ(NewGameState);
	UnstaffedSci.Length = 0;
	UnstaffedEng.Length = 0;
	StaffedSci.Length = 0;
	StaffedEng.Length = 0;

	foreach XComHQ.Crew(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

		if(IsStaffValidForWounding(UnitState))
		{
			if(UnitState.IsEngineer())
			{
				if(UnitState.StaffingSlot.ObjectID == 0)
				{
					UnstaffedEng.AddItem(UnitState);
				}
				else
				{
					StaffedEng.AddItem(UnitState);
				}
			}
			else
			{
				if(UnitState.StaffingSlot.ObjectID == 0)
				{
					UnstaffedSci.AddItem(UnitState);
				}
				else
				{
					StaffedSci.AddItem(UnitState);
				}
			}
		}
	}

	bCanWoundSci = (UnstaffedSci.Length > 0 || StaffedSci.Length > 0);
	bCanWoundEng = (UnstaffedEng.Length > 0 || StaffedEng.Length > 0);

	if(!bCanWoundSci && !bCanWoundEng)
	{
		return none;
	}
	else if(bCanWoundSci && !bCanWoundEng)
	{
		bWoundEng = false;
	}
	else if(!bCanWoundSci && bCanWoundEng)
	{
		bWoundEng = true;
	}
	else
	{
		bWoundEng = class'X2StrategyGameRulesetDataStructures'.static.Roll(50);
	}

	if(bWoundEng)
	{
		if(UnstaffedEng.Length > 0)
		{
			UnitState = UnstaffedEng[`SYNC_RAND_STATIC(UnstaffedEng.Length)];
		}
		else
		{
			UnitState = StaffedEng[`SYNC_RAND_STATIC(StaffedEng.Length)];
		}
	}
	else
	{
		if(UnstaffedSci.Length > 0)
		{
			UnitState = UnstaffedSci[`SYNC_RAND_STATIC(UnstaffedSci.Length)];
		}
		else
		{
			UnitState = StaffedSci[`SYNC_RAND_STATIC(StaffedSci.Length)];
		}
	}

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
	SlotState = UnitState.GetStaffSlot();

	if(SlotState != none)
	{
		SlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', SlotState.ObjectID));
		SlotState.EmptySlot(NewGameState);
	}

	UnitState.SetCurrentStat(eStat_HP, (UnitState.GetCurrentStat(eStat_HP) - 1.0f));
	ProjectState = XComGameState_HeadquartersProjectHealSoldier(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectHealSoldier'));
	ProjectState.SetProjectFocus(UnitState.GetReference(), NewGameState);
	ProjectDays = ProjectState.GetProjectNumDaysRemaining();
	MinDaysToAdd = `ScaleStrategyArrayInt(default.WoundStaffMinDays);
	MinDaysToAdd = Clamp((MinDaysToAdd - ProjectDays), 0, MinDaysToAdd);
	MaxDaysToAdd = `ScaleStrategyArrayInt(default.WoundStaffMaxDays);
	MaxDaysToAdd = Clamp((MaxDaysToAdd - ProjectDays), 0, MaxDaysToAdd);
	ProjectState.AddRecoveryDays(`SYNC_RAND_STATIC(MaxDaysToAdd - MinDaysToAdd + 1));
	ProjectDays = ProjectState.GetProjectNumDaysRemaining();
	ProjectHours = ProjectState.GetProjectedNumHoursRemaining();

	if(ProjectHours > (ProjectDays * 24))
	{
		ProjectDays++;
	}

	XComHQ.Projects.AddItem(ProjectState.GetReference());

	return UnitState;
}

//---------------------------------------------------------------------------------------
private static function bool IsStaffValidForWounding(XComGameState_Unit UnitState)
{
	return (UnitState != none && !UnitState.IsInjured() && !UnitState.IsUnitCritical() &&
			((UnitState.IsEngineer() && UnitState.GetMyTemplateName() != 'HeadEngineer') ||
			(UnitState.IsScientist() && UnitState.GetMyTemplateName() != 'HeadScientist')));
}