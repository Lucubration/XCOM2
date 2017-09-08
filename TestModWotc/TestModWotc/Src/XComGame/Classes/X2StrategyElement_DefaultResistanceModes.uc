//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultResistanceModes.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultResistanceModes extends X2StrategyElement
	config(GameData);

var config array<float>					MedicalModeHealRateScalar;
var config array<float>					BuildModeConstructionRateScalar;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Modes;

	Modes.AddItem(CreateIntelModeTemplate());
	Modes.AddItem(CreateMedicalModeTemplate());
	Modes.AddItem(CreateBuildModeTemplate());

	return Modes;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateIntelModeTemplate()
{
	local X2ResistanceModeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ResistanceModeTemplate', Template, 'ResistanceMode_Intel');
	Template.Category = "ResistanceMode";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.ResHQ_Intel";
	Template.OnActivatedFn = ActivateIntelMode;
	Template.OnDeactivatedFn = DeactivateIntelMode;
	Template.OnXCOMArrivesFn = OnXCOMArrivesIntelMode;
	Template.OnXCOMLeavesFn = OnXCOMLeavesIntelMode;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateIntelMode(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	OnXCOMArrivesIntelMode(NewGameState, InRef);
}
//---------------------------------------------------------------------------------------
static function DeactivateIntelMode(XComGameState NewGameState, StateObjectReference InRef)
{
	OnXCOMLeavesIntelMode(NewGameState, InRef);
}
//---------------------------------------------------------------------------------------
static function OnXCOMArrivesIntelMode(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;

	ResistanceHQ = GetNewResHQState(NewGameState);
	ResistanceHQ.bIntelMode = true;
}
//---------------------------------------------------------------------------------------
static function OnXCOMLeavesIntelMode(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;

	ResistanceHQ = GetNewResHQState(NewGameState);
	ResistanceHQ.bIntelMode = false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMedicalModeTemplate()
{
	local X2ResistanceModeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ResistanceModeTemplate', Template, 'ResistanceMode_Medical');
	Template.Category = "ResistanceMode";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.ResHQ_Medical";
	Template.OnActivatedFn = ActivateMedicalMode;
	Template.OnDeactivatedFn = DeactivateMedicalMode;
	Template.OnXCOMArrivesFn = OnXCOMArrivesMedicalMode;
	Template.OnXCOMLeavesFn = OnXCOMLeavesMedicalMode;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateMedicalMode(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	// The Avenger is already at ResHQ, so activate it immediately
	OnXCOMArrivesMedicalMode(NewGameState, InRef);
}
//---------------------------------------------------------------------------------------
static function DeactivateMedicalMode(XComGameState NewGameState, StateObjectReference InRef)
{
	// The Avenger is already at ResHQ, so deactivate it immediately
	OnXCOMLeavesMedicalMode(NewGameState, InRef);
}
//---------------------------------------------------------------------------------------
static function OnXCOMArrivesMedicalMode(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;
	
	XComHQ = GetNewXComHQState(NewGameState);
	if (XComHQ.HealingRate < `ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates)) // safety check: ensure healing rate is never below default
	{
		XComHQ.HealingRate = `ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates);
	}
	XComHQ.HealingRate += `ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates) * `ScaleStrategyArrayFloat(default.MedicalModeHealRateScalar);
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function OnXCOMLeavesMedicalMode(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.HealingRate -= `ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates) * `ScaleStrategyArrayFloat(default.MedicalModeHealRateScalar);
	if (XComHQ.HealingRate < `ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates)) // safety check: ensure healing rate is never below default
	{
		XComHQ.HealingRate = `ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates);
	}
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateBuildModeTemplate()
{
	local X2ResistanceModeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ResistanceModeTemplate', Template, 'ResistanceMode_Build');
	Template.Category = "ResistanceMode";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.ResHQ_Construction";
	Template.OnActivatedFn = ActivateBuildMode;
	Template.OnDeactivatedFn = DeactivateBuildMode;
	Template.OnXCOMArrivesFn = OnXCOMArrivesBuildMode;
	Template.OnXCOMLeavesFn = OnXCOMLeavesBuildMode;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateBuildMode(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	// The Avenger is already at ResHQ, so activate it immediately
	OnXCOMArrivesBuildMode(NewGameState, InRef);
}
//---------------------------------------------------------------------------------------
static function DeactivateBuildMode(XComGameState NewGameState, StateObjectReference InRef)
{
	// The Avenger is already at ResHQ, so deactivate it immediately
	OnXCOMLeavesBuildMode(NewGameState, InRef);
}
//---------------------------------------------------------------------------------------
static function OnXCOMArrivesBuildMode(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	if (XComHQ.ConstructionRate < XComHQ.XComHeadquarters_DefaultConstructionWorkPerHour) // safety check: ensure construction rate is never below default
	{
		XComHQ.ConstructionRate = XComHQ.XComHeadquarters_DefaultConstructionWorkPerHour;
	}
	XComHQ.ConstructionRate += XComHQ.XComHeadquarters_DefaultConstructionWorkPerHour * `ScaleStrategyArrayFloat(default.BuildModeConstructionRateScalar);
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function OnXCOMLeavesBuildMode(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ConstructionRate -= XComHQ.XComHeadquarters_DefaultConstructionWorkPerHour * `ScaleStrategyArrayFloat(default.BuildModeConstructionRateScalar);
	if (XComHQ.ConstructionRate < XComHQ.XComHeadquarters_DefaultConstructionWorkPerHour) // safety check: ensure construction rate is never below default
	{
		XComHQ.ConstructionRate = XComHQ.XComHeadquarters_DefaultConstructionWorkPerHour;
	}
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}

//#############################################################################################
//----------------   HELPER FUNCTIONS  --------------------------------------------------------
//#############################################################################################

//static function UpdateScanLabel(XComGameState NewGameState)
//{
//	local XComGameState_HeadquartersResistance ResistanceHQ;
//	local XComGameState_HeadquartersXCom XComHQ;
//	local XComGameState_Haven HavenState;
//	local X2ResistanceModeTemplate ResistanceModeTemplate;
//
//	ResistanceHQ = GetNewResHQState(NewGameState);
//	XComHQ = GetNewXComHQState(NewGameState);
//	ResistanceModeTemplate = ResistanceHQ.GetResistanceMode();
//
//	// Update the Res HQ Haven to give the correct scanning label
//	HavenState = XComGameState_Haven(XComHQ.GetCurrentScanningSite());
//	HavenState = XComGameState_Haven(NewGameState.ModifyStateObject(class'XComGameState_Haven', HavenState.ObjectID));
//	HavenState.m_strScanButtonLabel = ResistanceModeTemplate.ScanLabel;
//}

static function XComGameState_HeadquartersResistance GetNewResHQState(XComGameState NewGameState)
{
	local XComGameState_HeadquartersResistance NewResHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersResistance', NewResHQ)
	{
		break;
	}

	if (NewResHQ == none)
	{
		NewResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
		NewResHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', NewResHQ.ObjectID));
	}

	return NewResHQ;
}

static function XComGameState_HeadquartersXCom GetNewXComHQState(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom NewXComHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', NewXComHQ)
	{
		break;
	}

	if (NewXComHQ == none)
	{
		NewXComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		NewXComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', NewXComHQ.ObjectID));
	}

	return NewXComHQ;
}