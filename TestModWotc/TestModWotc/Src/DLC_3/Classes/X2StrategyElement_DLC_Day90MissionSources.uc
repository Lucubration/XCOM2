//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90MissionSources.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90MissionSources extends X2StrategyElement
	config(GameData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> MissionSources;

	MissionSources.AddItem(CreateMissionSource_LostTowersTemplate());

	return MissionSources;
}

static function X2DataTemplate CreateMissionSource_LostTowersTemplate()
{
	local X2MissionSourceTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MissionSourceTemplate', Template, 'MissionSource_LostTowers');
	Template.bIncreasesForceLevel = false;
	Template.bSkipRewardsRecap = true;
	Template.DifficultyValue = 3;
	Template.OnSuccessFn = LostTowersOnSuccess;
	Template.OnFailureFn = LostTowersOnFailure;
	Template.OverworldMeshPath = "Materials_DLC3.3DUI.ShenLastGift";
	Template.MissionImage = "img:///UILibrary_DLC3Images.Alert_ShensLastGiftPOI";
	Template.ResistanceActivity = 'ResAct_LostTowersInvestigated';
	Template.GetMissionDifficultyFn = GetMissionDifficultyFromTemplate;
	Template.WasMissionSuccessfulFn = OneStrategyObjectiveCompleted;
	Template.MissionPopupFn = OpenLostTowersMissionBlades;
	Template.CustomLoadingMovieName_Intro = "CIN_DLC3_LostTowers_Loading.bk2";
	Template.CustomLoadingMovieName_IntroSound = "DLC3_ElevatorLoadScreen";

	return Template;
}

static function LostTowersOnSuccess(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_SparkManager SparkMgr;
	local XComGameState_BattleData BattleData;
	local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersProjectHealSpark HealProjectState;
	local StaffUnitInfo UnitInfo;

	ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	ResHQ.AttemptSpawnRandomPOI(NewGameState);

	//GiveRewards(NewGameState, MissionState);
	MissionState.RemoveEntity(NewGameState);

	if (MissionState.GetMissionSource().ResistanceActivity != '')
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, MissionState.GetMissionSource().ResistanceActivity);

	`XEVENTMGR.TriggerEvent('LostTowersMissionComplete', , , NewGameState);

	History = `XCOMHISTORY;

	// Add a SPARK soldier for the player if they win the mission
	SparkMgr = XComGameState_SparkManager(History.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager'));
	class'X2Helpers_DLC_Day90'.static.CreateSparkSoldier(NewGameState, SparkMgr.LostTowersSparkReference);
	class'X2Helpers_DLC_Day90'.static.CreateSparkEquipment(NewGameState); // Add the Spark equipment items to the HQ

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	
	FacilityState = XComHQ.GetFacilityByName('Storage');
	if (FacilityState != none && FacilityState.GetNumLockedStaffSlots() > 0)
	{
		// Unlock the Repair SPARK staff slot in Engineering
		FacilityState.UnlockStaffSlot(NewGameState);

		// Check if the new SPARK is wounded, and staff automatically into the repair slot if found
		foreach NewGameState.IterateByClassType(class'XComGameState_StaffSlot', StaffSlotState)
		{
			if (StaffSlotState != none && StaffSlotState.GetMyTemplateName() == 'SparkStaffSlot')
			{
				foreach NewGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
				{
					if (UnitState != none)
					{
						UnitInfo.UnitRef = UnitState.GetReference();
						UnitInfo.bGhostUnit = false;
						UnitInfo.GhostLocation.ObjectID = 0;

						if (StaffSlotState.ValidUnitForSlot(UnitInfo)) // This will check if the unit is a Spark and wounded
						{
							// Add a healing project for the SPARK
							HealProjectState = XComGameState_HeadquartersProjectHealSpark(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectHealSpark'));
							HealProjectState.SetProjectFocus(UnitState.GetReference(), NewGameState);
							XComHQ.Projects.AddItem(HealProjectState.GetReference());
							HealProjectState.bForcePaused = true;

							StaffSlotState.FillSlot(UnitInfo, NewGameState);
							break;
						}
					}
				}
			}
		}
	}

	// Put Lost Towers SPARK as Reward unit so it shows up in VIP Recovered Screen
	foreach NewGameState.IterateByClassType(class'XComGameState_BattleData', BattleData)
	{
		break;
	}

	if(BattleData == none)
	{
		BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	}

	BattleData.RewardUnits.AddItem(SparkMgr.LostTowersSparkReference);
}

static function LostTowersOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	MissionState.RemoveEntity(NewGameState);
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_LostTowersFailed');
	
	`XEVENTMGR.TriggerEvent('LostTowersMissionComplete', , , NewGameState);
}

static function OpenLostTowersMissionBlades(optional XComGameState_MissionSite MissionState)
{
	local XComHQPresentationLayer Pres;
	local UIMission_LostTowers kScreen;

	Pres = `HQPRES;

	// Show the lost towers mission
	if (!Pres.ScreenStack.GetCurrentScreen().IsA('UIMission_LostTowers'))
	{
		kScreen = Pres.Spawn(class'UIMission_LostTowers');
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