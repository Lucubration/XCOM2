//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day60MissionSources.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day60MissionSources extends X2StrategyElement
	config(GameData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> MissionSources;

	MissionSources.AddItem(CreateMissionSource_AlienNestTemplate());

	return MissionSources;
}

static function X2DataTemplate CreateMissionSource_AlienNestTemplate()
{
	local X2MissionSourceTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MissionSourceTemplate', Template, 'MissionSource_AlienNest');
	Template.bIncreasesForceLevel = false;
	Template.bSkipRewardsRecap = true;
	Template.DifficultyValue = 3;
	Template.OnSuccessFn = AlienNestOnSuccess;
	Template.OnFailureFn = AlienNestOnFailure;
	Template.OverworldMeshPath = "Materials_DLC2.3DUI.ViperKingDen";
	Template.MissionImage = "img:///UILibrary_DLC2Images.Alert_Alien_NestPOI";
	Template.CustomMusicSet = 'DerelictFacility';
	Template.ResistanceActivity = 'ResAct_AlienNestInvestigated';
	Template.GetMissionDifficultyFn = GetMissionDifficultyFromTemplate;
	Template.WasMissionSuccessfulFn = OneStrategyObjectiveCompleted;
	Template.MissionPopupFn = OpenAlienNestMissionBlades;

	return Template;
}

static function AlienNestOnSuccess(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	ResHQ.AttemptSpawnRandomPOI(NewGameState);

	//GiveRewards(NewGameState, MissionState);
	MissionState.RemoveEntity(NewGameState);

	if (MissionState.GetMissionSource().ResistanceActivity != '')
		class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, MissionState.GetMissionSource().ResistanceActivity);

	`XEVENTMGR.TriggerEvent('AlienNestMissionComplete', , , NewGameState);
	UpdateViperKingInfo(NewGameState);
}

static function AlienNestOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	MissionState.RemoveEntity(NewGameState);
	`XEVENTMGR.TriggerEvent('AlienNestMissionComplete', , , NewGameState);
	UpdateViperKingInfo(NewGameState);
}

static function UpdateViperKingInfo(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_AlienRulerManager RulerMgr;
	local StateObjectReference ViperKingRef;

	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_AlienRulerManager', RulerMgr)
	{
		break;
	}

	if(RulerMgr == none)
	{
		RulerMgr = XComGameState_AlienRulerManager(History.GetSingleGameStateObjectForClass(class'XComGAmeState_AlienRulerManager'));
		RulerMgr = XComGAmeState_AlienRulerManager(NewGameState.ModifyStateObject(class'XComGameState_AlienRulerManager', RulerMgr.ObjectID));
	}

	ViperKingRef = RulerMgr.GetAlienRulerReference('ViperKing');

	if(ViperKingRef.ObjectID != 0)
	{
		UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ViperKingRef.ObjectID));

		if(UnitState == none)
		{
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ViperKingRef.ObjectID));
		}

		// Trigger an event to complete Viper King dead or alive objectives, which in turn will trigger appropriate ambient VO
		if (UnitState.IsDead())
			`XEVENTMGR.TriggerEvent('NestCompleteViperKingDead', , , NewGameState);
		else
			`XEVENTMGR.TriggerEvent('NestCompleteViperKingAlive', , , NewGameState);
	}
}

static function OpenAlienNestMissionBlades(optional XComGameState_MissionSite MissionState)
{
	local XComHQPresentationLayer Pres;
	local UIMission_AlienNest kScreen;

	Pres = `HQPRES;

	// Show the alien nest mission
	if (!Pres.ScreenStack.GetCurrentScreen().IsA('UIMission_AlienNest'))
	{
		kScreen = Pres.Spawn(class'UIMission_AlienNest');
		Pres.ScreenStack.Push(kScreen);
	}
}

// #######################################################################################
// -------------------- GENERIC FUNCTIONS ------------------------------------------------
// #######################################################################################

static function int GetMissionDifficultyFromTemplate(XComGameState_MissionSite MissionState)
{
	local int Difficulty;

	Difficulty = MissionState.GetMissionSource().DifficultyValue;

	Difficulty = Clamp(Difficulty, class'X2StrategyGameRulesetDataStructures'.default.MinMissionDifficulty,
	class'X2StrategyGameRulesetDataStructures'.default.MaxMissionDifficulty);

	return Difficulty;
}

//---------------------------------------------------------------------------------------
static function bool OneStrategyObjectiveCompleted(XComGameState_BattleData BattleDataState)
{
	return (BattleDataState.OneStrategyObjectiveCompleted());
}