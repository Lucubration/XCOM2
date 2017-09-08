//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultDarkEvents.uc
//  AUTHOR:  Mark Nauta
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultDarkEvents extends X2StrategyElement
	config(GameData);

var config array<int> MinorBreakthroughDoom;
var config array<int> MajorBreakthroughDoom;
var config array<float> MidnightRaidsScalar;
var config array<float> RuralCheckpointsScalar;
var config array<int> NewConstructionReductionDays;
var config array<float> AlienCypherScalar;
var config array<int> ResistanceInformantReductionDays;

var localized string MinorBreakthroughDoomLabel;
var localized string MajorBreakthroughDoomLabel;
var localized string DayLabel;
var localized string DaysLabel;
var localized string WeekLabel;
var localized string WeeksLabel;
var localized string BlockLabel;
var localized string BlocksLabel;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> DarkEvents;

	DarkEvents.AddItem(CreateMinorBreakthroughTemplate());
	DarkEvents.AddItem(CreateMajorBreakthroughTemplate());
	DarkEvents.AddItem(CreateHunterClassTemplate());
	DarkEvents.AddItem(CreateMidnightRaidsTemplate());
	DarkEvents.AddItem(CreateRuralCheckpointsTemplate());
	DarkEvents.AddItem(CreateAlloyPaddingTemplate());
	DarkEvents.AddItem(CreateAlienCypherTemplate());
	DarkEvents.AddItem(CreateResistanceInformantTemplate());
	DarkEvents.AddItem(CreateNewConstructionTemplate());
	DarkEvents.AddItem(CreateInfiltratorTemplate());
	DarkEvents.AddItem(CreateInfiltratorChryssalidTemplate());
	DarkEvents.AddItem(CreateRapidResponseTemplate());
	DarkEvents.AddItem(CreateVigilanceTemplate());
	DarkEvents.AddItem(CreateShowOfForceTemplate());
	DarkEvents.AddItem(CreateViperRoundsTemplate());

	return DarkEvents;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMinorBreakthroughTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_MinorBreakthrough');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Avatar";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 10;
	Template.MaxActivationDays = 15;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 10;
	Template.MinWeight = 1;
	Template.MaxWeight = 10;
	Template.WeightDeltaPerPlay = 0;
	Template.WeightDeltaPerActivate = -2;
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough');
	Template.bNeverShowObjective = true;

	Template.OnActivatedFn = ActivateMinorBreakthrough;
	Template.CanActivateFn = CanActivateMinorBreakthrough;
	Template.CanCompleteFn = CanCompleteMinorBreakthrough;
	Template.GetSummaryFn = GetMinorBreakthroughSummary;
	Template.GetPreMissionTextFn = GetMinorBreakthroughPreMissionText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function bool CanActivateMinorBreakthrough(XComGameState_DarkEvent DarkEventState)
{
	return (!AtFirstMonth() && !AtMaxDoom());
}
//---------------------------------------------------------------------------------------
static function bool CanCompleteMinorBreakthrough(XComGameState_DarkEvent DarkEventState)
{
	return (!AtMaxDoom());
}
//---------------------------------------------------------------------------------------
static function ActivateMinorBreakthrough(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	GetAndAddAlienHQ(NewGameState).AddDoomToRandomFacility(NewGameState, GetMinorBreakthroughDoom(), default.MinorBreakthroughDoomLabel);
}
//---------------------------------------------------------------------------------------
static function string GetMinorBreakthroughSummary(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMinorBreakthroughDoom());
	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------
static function string GetMinorBreakthroughPreMissionText(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMinorBreakthroughDoom());
	return `XEXPAND.ExpandString(strPreMissionText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMajorBreakthroughTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_MajorBreakthrough');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Avatar2";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 28;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 6;
	Template.MinWeight = 1;
	Template.MaxWeight = 6;
	Template.WeightDeltaPerPlay = 0;
	Template.WeightDeltaPerActivate = -2;
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough');
	Template.bNeverShowObjective = true;

	Template.OnActivatedFn = ActivateMajorBreakthrough;
	Template.CanActivateFn = CanActivateMajorBreakthrough;
	Template.CanCompleteFn = CanCompleteMajorBreakthrough;
	Template.GetSummaryFn = GetMajorBreakthroughSummary;
	Template.GetPreMissionTextFn = GetMajorBreakthroughPreMissionText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateMajorBreakthrough(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	GetAndAddAlienHQ(NewGameState).AddDoomToRandomFacility(NewGameState, GetMajorBreakthroughDoom(), default.MajorBreakthroughDoomLabel);
}
//---------------------------------------------------------------------------------------
static function bool CanActivateMajorBreakthrough(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	return (ResistanceHQ.NumMonths >= 2 && !AtMaxDoom());
}
//---------------------------------------------------------------------------------------
static function bool CanCompleteMajorBreakthrough(XComGameState_DarkEvent DarkEventState)
{
	return (!AtMaxDoom());
}
//---------------------------------------------------------------------------------------
static function string GetMajorBreakthroughSummary(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMajorBreakthroughDoom());
	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------
static function string GetMajorBreakthroughPreMissionText(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMajorBreakthroughDoom());
	return `XEXPAND.ExpandString(strPreMissionText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateHunterClassTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_HunterClass');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_UFO";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 14;
	Template.MaxActivationDays = 28;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 10;
	Template.MinWeight = 1;
	Template.MaxWeight = 10;
	Template.WeightDeltaPerPlay = 0;
	Template.WeightDeltaPerActivate = -4;

	Template.OnActivatedFn = ActivateHunterClass;
	Template.CanActivateFn = CanActivateHunterClass;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateHunterClass(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_DarkEvent DarkEventState;
	local XComGameState_UFO NewUFOState;
	local int HoursToIntercept;

	NewUFOState = XComGameState_UFO(NewGameState.CreateNewStateObject(class'XComGameState_UFO'));
	NewUFOState.PostCreateInit(NewGameState, false);
	HoursToIntercept = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours(NewUFOState.InterceptionTime, `STRATEGYRULES.GameTime);

	DarkEventState = XComGameState_DarkEvent(NewGameState.ModifyStateObject(class'XComGameState_DarkEvent', InRef.ObjectID));
	DarkEventState.StartDurationTimer(HoursToIntercept);

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	AlienHQ.ActiveDarkEvents.AddItem(DarkEventState.GetReference());
}

//---------------------------------------------------------------------------------------
static function bool CanActivateHunterClass(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	
	return (!AlienHQ.bHasPlayerBeenIntercepted ? true : (!OnNormalOrEasier() && !AtFirstMonth()));
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMidnightRaidsTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_MidnightRaids');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Crackdown";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 10;
	Template.MaxActivationDays = 21;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateMidnightRaids;
	Template.OnDeactivatedFn = DeactivateMidnightRaids;
	Template.CanActivateFn = CanActivateMidnightRaids;
	Template.GetSummaryFn = GetMidnightRaidsSummary;
	Template.GetPreMissionTextFn = GetMidnightRaidsPreMissionText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateMidnightRaids(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));

	ResistanceHQ.RecruitScalar = GetMidnightRaidsScalar();
}
//---------------------------------------------------------------------------------------
static function DeactivateMidnightRaids(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));

	ResistanceHQ.RecruitScalar = 1.0f;
}
//---------------------------------------------------------------------------------------
static function bool CanActivateMidnightRaids(XComGameState_DarkEvent DarkEventState)
{
	return (!OnNormalOrEasier() || !AtFirstMonth());
}
//---------------------------------------------------------------------------------------
static function string GetMidnightRaidsSummary(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = string(GetPercent(GetMidnightRaidsScalar()));
	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------
static function string GetMidnightRaidsPreMissionText(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = string(GetPercent(GetMidnightRaidsScalar()));
	return `XEXPAND.ExpandString(strPreMissionText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRuralCheckpointsTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_RuralCheckpoints');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_SuppliesSeized";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = true;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = true;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateRuralCheckpoints;
	Template.OnDeactivatedFn = DeactivateRuralCheckpoints;
	Template.GetSummaryFn = GetRuralCheckpointsSummary;
	Template.GetPreMissionTextFn = GetRuralCheckpointsPreMissionText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateRuralCheckpoints(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));

	ResistanceHQ.SupplyDropPercentDecrease = GetRuralCheckpointsScalar();
}
//---------------------------------------------------------------------------------------
static function DeactivateRuralCheckpoints(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersResistance', ResistanceHQ)
	{
		break;
	}

	if(ResistanceHQ == none)
	{
		History = `XCOMHISTORY;
		ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
		ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));
	}

	ResistanceHQ.SupplyDropPercentDecrease = 0.0f;
}
//---------------------------------------------------------------------------------------
static function string GetRuralCheckpointsSummary(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = string(GetPercent(GetRuralCheckpointsScalar()));
	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------
static function string GetRuralCheckpointsPreMissionText(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = string(GetPercent(GetRuralCheckpointsScalar()));
	return `XEXPAND.ExpandString(strPreMissionText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateAlloyPaddingTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_AlloyPadding');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_NewArmor";
	Template.bRepeatable = false;
	Template.bTactical = true;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = 0;
	Template.WeightDeltaPerActivate = -2;

	Template.OnActivatedFn = ActivateTacticalDarkEvent;
	Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateAlienCypherTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_AlienCypher');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Cryptography";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateAlienCypher;
	Template.OnDeactivatedFn = DeactivateAlienCypher;
	Template.GetSummaryFn = GetAlienCypherSummary;
	Template.GetPreMissionTextFn = GetAlienCypherPreMissionText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateAlienCypher(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local StrategyCostScalar IntelScalar;
	local XComGameState_BlackMarket BlackMarketState;

	IntelScalar.ItemTemplateName = 'Intel';
	IntelScalar.Scalar = GetAlienCypherScalar();
	IntelScalar.Difficulty = `STRATEGYDIFFICULTYSETTING; // Set to the current difficulty

	GetAndAddAlienHQ(NewGameState).CostScalars.AddItem(IntelScalar);
	BlackMarketState = GetAndAddBlackMarket(NewGameState);
	BlackMarketState.PriceReductionScalar = (1.0f / IntelScalar.Scalar);
}
//---------------------------------------------------------------------------------------
static function DeactivateAlienCypher(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_BlackMarket BlackMarketState;
	local int idx;

	AlienHQ = GetAndAddAlienHQ(NewGameState);

	for(idx = 0; idx < AlienHQ.CostScalars.Length; idx++)
	{
		if(AlienHQ.CostScalars[idx].ItemTemplateName == 'Intel' && AlienHQ.CostScalars[idx].Scalar == GetAlienCypherScalar())
		{
			AlienHQ.CostScalars.Remove(idx, 1);
			break;
		}
	}

	BlackMarketState = GetAndAddBlackMarket(NewGameState);
	BlackMarketState.PriceReductionScalar = 1.0f;
}
//---------------------------------------------------------------------------------------
static function string GetAlienCypherSummary(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = string(GetPercent(GetAlienCypherScalar()));
	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------
static function string GetAlienCypherPreMissionText(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = string(GetPercent(GetAlienCypherScalar()));
	return `XEXPAND.ExpandString(strPreMissionText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateResistanceInformantTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_ResistanceInformant');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Traitor";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;
	Template.bNeverShowObjective = true;

	Template.OnActivatedFn = ActivateResistanceInformant;
	Template.GetSummaryFn = GetResistanceInformantSummary;
	Template.GetPreMissionTextFn = GetResistanceInformantPreMissionText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateResistanceInformant(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_MissionCalendar CalendarState;
	local float TimeToRemove;
	local TDateTime SpawnDate;
	local int Index;

	History = `XCOMHISTORY;
	CalendarState = XComGameState_MissionCalendar(History.GetSingleGameStateObjectForClass(class'XComGameState_MissionCalendar'));
	CalendarState = XComGameState_MissionCalendar(NewGameState.ModifyStateObject(class'XComGameState_MissionCalendar', CalendarState.ObjectID));
	TimeToRemove = float(GetResistanceInformantReductionDays() * 24 * 60 * 60);

	Index = CalendarState.CurrentMissionMonth.Find('MissionSource', 'MissionSource_Retaliation');

	if(Index != INDEX_NONE)
	{
		SpawnDate = CalendarState.CurrentMissionMonth[Index].SpawnDate;
		class'X2StrategyGameRulesetDataStructures'.static.RemoveTime(SpawnDate, TimeToRemove);
		CalendarState.CurrentMissionMonth[Index].SpawnDate = SpawnDate;
	}
	else
	{
		CalendarState.RetaliationSpawnTimeDecrease = TimeToRemove;
	}
}
//---------------------------------------------------------------------------------------
static function string GetResistanceInformantSummary(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetTimeString(GetResistanceInformantReductionDays());
	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------
static function string GetResistanceInformantPreMissionText(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetTimeString(GetResistanceInformantReductionDays());
	return `XEXPAND.ExpandString(strPreMissionText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateNewConstructionTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_NewConstruction');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_NewConstruction";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;
	Template.bNeverShowObjective = true;

	Template.OnActivatedFn = ActivateNewConstruction;
	Template.CanActivateFn = CanActivateMajorBreakthrough;
	Template.CanCompleteFn = CanActivateNewConstruction;
	Template.GetSummaryFn = GetNewConstructionSummary;
	Template.GetPreMissionTextFn = GetNewConstructionPreMissionText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function bool CanActivateNewConstruction(XComGameState_DarkEvent DarkEventState)
{
	return (HaveSeenFacility() && !AtMaxFacilities());
}
//---------------------------------------------------------------------------------------
static function bool CanCompleteNewConstruction(XComGameState_DarkEvent DarkEventState)
{
	return (!AtMaxFacilities());
}
//---------------------------------------------------------------------------------------
static function ActivateNewConstruction(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local float Reduction;
	
	AlienHQ = GetAndAddAlienHQ(NewGameState);
	Reduction = float(GetNewConstructionReductionDays() * 24 * 3600);
	class'X2StrategyGameRulesetDataStructures'.static.RemoveTime(AlienHQ.FacilityBuildEndTime, Reduction);
}
//---------------------------------------------------------------------------------------
static function string GetNewConstructionSummary(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetTimeString(GetNewConstructionReductionDays());
	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------
static function string GetNewConstructionPreMissionText(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetTimeString(GetNewConstructionReductionDays());
	return `XEXPAND.ExpandString(strPreMissionText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInfiltratorTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Infiltrator');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Faceless";
	Template.bRepeatable = true;
	Template.bTactical = true;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 3;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateTacticalDarkEvent;
	Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;
	Template.CanActivateFn = CanActivateInfiltrator;

	return Template;
}

//---------------------------------------------------------------------------------------
static function bool CanActivateInfiltrator(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	return XComHQ.HasSeenCharacterTemplate(class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('Faceless'));
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInfiltratorChryssalidTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_InfiltratorChryssalid');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Chryssalid";
	Template.bRepeatable = true;
	Template.bTactical = true;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 3;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateTacticalDarkEvent;
	Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;
	Template.CanActivateFn = CanActivateInfestation;

	return Template;
}

//---------------------------------------------------------------------------------------
static function bool CanActivateInfestation(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	return XComHQ.HasSeenCharacterTemplate(class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('Chryssalid'));
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRapidResponseTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_RapidResponse');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse";
	Template.bRepeatable = false;
	Template.bTactical = true;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateTacticalDarkEvent;
	Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateVigilanceTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Vigilance');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance";
	Template.bRepeatable = true;
	Template.bTactical = true;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateTacticalDarkEvent;
	Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateShowOfForceTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_ShowOfForce');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce";
	Template.bRepeatable = true;
	Template.bTactical = true;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateTacticalDarkEvent;
	Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;
	Template.CanActivateFn = CanActivateShowOfForce;

	return Template;
}

//---------------------------------------------------------------------------------------
static function bool CanActivateShowOfForce(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	return (ResistanceHQ.NumMonths >= 3 && `StrategyDifficultySetting >= 3);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateViperRoundsTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_ViperRounds');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ViperRounds";
	Template.bRepeatable = false;
	Template.bTactical = true;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 35;
	Template.MinDurationDays = 28;
	Template.MaxDurationDays = 28;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 5;
	Template.MinWeight = 1;
	Template.MaxWeight = 5;
	Template.WeightDeltaPerPlay = -2;
	Template.WeightDeltaPerActivate = 0;

	Template.OnActivatedFn = ActivateTacticalDarkEvent;
	Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;
	Template.CanActivateFn = CanActivateViperRounds;

	return Template;
}

//---------------------------------------------------------------------------------------
static function bool CanActivateViperRounds(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	return (ResistanceHQ.NumMonths >= 2);
}

// #######################################################################################
// -------------------- HELPERS ----------------------------------------------------------
// #######################################################################################

//---------------------------------------------------------------------------------------
static function ActivateTacticalDarkEvent(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_DarkEvent DarkEventState;
	local Name DarkEventTemplateName;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(InRef.ObjectID));
	DarkEventTemplateName = DarkEventState.GetMyTemplateName();

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if( XComHQ.TacticalGameplayTags.Find(DarkEventTemplateName) == INDEX_NONE )
	{
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

		XComHQ.TacticalGameplayTags.AddItem(DarkEventTemplateName);
	}
}

static function DeactivateTacticalDarkEvent(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_DarkEvent DarkEventState;
	local Name DarkEventTemplateName;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(InRef.ObjectID));
	DarkEventTemplateName = DarkEventState.GetMyTemplateName();

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if( XComHQ.TacticalGameplayTags.Find(DarkEventTemplateName) != INDEX_NONE )
	{
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

		XComHQ.TacticalGameplayTags.RemoveItem(DarkEventTemplateName);
	}
}

//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersAlien GetAndAddAlienHQ(XComGameState NewGameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersAlien', AlienHQ)
	{
		break;
	}

	if (AlienHQ == none)
	{
		AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	}

	return AlienHQ;
}

//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersXCom GetAndAddXComHQ(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	}

	return XComHQ;
}

//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersResistance GetAndAddResHQ(XComGameState NewGameState)
{
	local XComGameState_HeadquartersResistance ResHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersResistance', ResHQ)
	{
		break;
	}

	if (ResHQ == none)
	{
		ResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
		ResHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResHQ.ObjectID));
	}

	return ResHQ;
}

//---------------------------------------------------------------------------------------
static function bool AtFirstMonth()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	return (ResistanceHQ.NumMonths == 0);
}

//---------------------------------------------------------------------------------------
static function bool AtMaxDoom()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	return (AlienHQ.AtMaxDoom());
}

//---------------------------------------------------------------------------------------
static function bool AtMaxFacilities()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_MissionSite> Facilities;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	Facilities = AlienHQ.GetValidFacilityDoomMissions();

	return (Facilities.Length >= AlienHQ.GetMaxFacilities());
}

//---------------------------------------------------------------------------------------
static function bool HaveSeenFacility()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	return (AlienHQ.bHasSeenFacility);
}

//---------------------------------------------------------------------------------------
static function bool OnNormalOrEasier()
{
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings SettingsState;

	History = `XCOMHISTORY;
	SettingsState = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	return (SettingsState.DifficultySetting <= 1);
}

//---------------------------------------------------------------------------------------
static function int GetPercent(float fScalar)
{
	local int PercentToReturn;

	PercentToReturn = Round(fScalar * 100.0f);
	PercentToReturn = Abs(PercentToReturn - 100);

	return PercentToReturn;
}

//---------------------------------------------------------------------------------------
static function string GetTimeString(int NumDays)
{
	local int NumWeeks;

	if(NumDays < 7)
	{
		if(NumDays == 1)
		{
			return string(NumDays) @ default.DayLabel;
		}
		else
		{
			return string(NumDays) @ default.DaysLabel;
		}
	}

	NumWeeks = NumDays / 7;

	if(NumWeeks == 1)
	{
		return string(NumWeeks) @ default.WeekLabel;
	}

	return string(NumWeeks) @ default.WeeksLabel;
}

//---------------------------------------------------------------------------------------
static function string GetBlocksString(int NumBlocks)
{
	if(NumBlocks == 1)
	{
		return string(NumBlocks) @ default.BlockLabel;
	}

	return string(NumBlocks) @ default.BlocksLabel;
}

//---------------------------------------------------------------------------------------
static function XComGameState_BlackMarket GetAndAddBlackMarket(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_BlackMarket BlackMarketState;

	foreach NewGameState.IterateByClassType(class'XComGameState_BlackMarket', BlackMarketState)
	{
		break;
	}

	if(BlackMarketState == none)
	{
		History = `XCOMHISTORY;
		BlackMarketState = XComGameState_BlackMarket(History.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));
		BlackMarketState = XComGameState_BlackMarket(NewGameState.ModifyStateObject(class'XComGameState_BlackMarket', BlackMarketState.ObjectID));
	}

	return BlackMarketState;
}

//#############################################################################################
//----------------   DIFFICULTY HELPERS   -----------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function int GetMinorBreakthroughDoom()
{
	return `ScaleStrategyArrayInt(default.MinorBreakthroughDoom);
}

//---------------------------------------------------------------------------------------
static function int GetMajorBreakthroughDoom()
{
	return `ScaleStrategyArrayInt(default.MajorBreakthroughDoom);
}

//---------------------------------------------------------------------------------------
static function float GetMidnightRaidsScalar()
{
	return `ScaleStrategyArrayFloat(default.MidnightRaidsScalar);
}

//---------------------------------------------------------------------------------------
static function float GetRuralCheckpointsScalar()
{
	return `ScaleStrategyArrayFloat(default.RuralCheckpointsScalar);
}

//---------------------------------------------------------------------------------------
static function int GetNewConstructionReductionDays()
{
	return `ScaleStrategyArrayInt(default.NewConstructionReductionDays);
}

//---------------------------------------------------------------------------------------
static function float GetAlienCypherScalar()
{
	return `ScaleStrategyArrayFloat(default.AlienCypherScalar);
}

//---------------------------------------------------------------------------------------
static function int GetResistanceInformantReductionDays()
{
	return `ScaleStrategyArrayInt(default.ResistanceInformantReductionDays);
}