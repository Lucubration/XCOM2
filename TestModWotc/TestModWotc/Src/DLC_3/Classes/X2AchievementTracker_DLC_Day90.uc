//---------------------------------------------------------------------------------------
//  FILE:    X2AchievementTracker_DLC_Day90.uc
//  AUTHOR:  Joe Weinhoffer -- 4/29/2016
//  PURPOSE: Tracks achievements for Shens Last Gift DLC
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AchievementTracker_DLC_Day90 extends Object
	DependsOn(XComGameState_DLC_Day90AchievementData);
 
// Singleton creation / access of XComGameState_DLC_Day90AchievementData.
static function XComGameState_DLC_Day90AchievementData GetAchievementData(XComGameState NewGameState)
{
	local XComGameState_DLC_Day90AchievementData AchievementData;

	AchievementData = XComGameState_DLC_Day90AchievementData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_DLC_Day90AchievementData', true));
	if (AchievementData == none)
	{
		AchievementData = XComGameState_DLC_Day90AchievementData(NewGameState.CreateNewStateObject(class'XComGameState_DLC_Day90AchievementData'));
	}
	else
	{
		AchievementData = XComGameState_DLC_Day90AchievementData(NewGameState.ModifyStateObject(class'XComGameState_DLC_Day90AchievementData', AchievementData.ObjectID));
	}

	return AchievementData;
}

// Catches the beginning of a mission
static function EventListenerReturn OnTacticalBeginPlay(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_DLC_Day90AchievementData AchievementData;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;
	local float fPercentHealth;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// Reset the relevant data from the Achievement Data singleton
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2AchievementTracker_DLC_Day90.OnTacticalBeginPlay");
	AchievementData = GetAchievementData(NewGameState);
	AchievementData.arrSparksHalfHealth.Length = 0;
	AchievementData.arrOverdriveShotsThisTurn.Length = 0;

	// Add all SPARKs with less than half health remaining to the tracking array
	foreach XComHQ.Squad(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
		if (UnitState.GetMyTemplateName() == 'SparkSoldier')
		{
			fPercentHealth = UnitState.GetCurrentStat(eStat_HP) / UnitState.GetMaxStat(eStat_HP);
			if (fPercentHealth < 0.5)
			{
				AchievementData.arrSparksHalfHealth.AddItem(UnitRef);
			}
		}
	}

	`TACTICALRULES.SubmitGameState(NewGameState);
	
	return ELR_NoInterrupt;
}

// Catches the end of a mission
static function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BattleData Battle;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local XComGameState_DLC_Day90AchievementData AchievementData;
	local StateObjectReference UnitRef;
	local int iSparkCount;
	
	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	Battle = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// Make sure the player won
	if (!(Battle.bLocalPlayerWon && !Battle.bMissionAborted))
	{
		return ELR_NoInterrupt;
	}

	// Clear the Lost Towers mission
	if (string(Battle.MapData.ActiveMission.MissionName) == "LastGiftC")
	{
		`log("Shen's Last Gift Achievement Awarded: A Torch Passed");
		`ONLINEEVENTMGR.UnlockAchievement(AT_CompleteLostTowers);
	}

	if (`XENGINE.IsSinglePlayerGame())
	{
		foreach XComHQ.Squad(UnitRef)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (UnitState.GetMyTemplateName() == 'SparkSoldier')
			{
				iSparkCount++;
				if (iSparkCount >= 3)
				{
					`log("Shen's Last Gift Achievement Awarded: Rise of the Robots");
					`ONLINEEVENTMGR.UnlockAchievement(AT_BeatMissionThreeSparks);
					break;
				}
			}
		}

		// Clear the relevant data from the Achievement Data singleton
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2AchievementTracker_DLC_Day90.OnTacticalGameEnd");
		AchievementData = GetAchievementData(NewGameState);

		foreach AchievementData.arrSparksHalfHealth(UnitRef)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (UnitState.IsAlive())
			{
				`log("Shen's Last Gift Achievement Awarded: Running on Fumes");
				`ONLINEEVENTMGR.UnlockAchievement(AT_BeatMissionHalfHealthSpark);
				break;
			}
		}

		AchievementData.arrSparksHalfHealth.Length = 0;
		`TACTICALRULES.SubmitGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}

// This is called at the start of each turn
static function EventListenerReturn OnPlayerTurnBegun(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_DLC_Day90AchievementData AchievementData;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	// We only care about the human player's turn, not the AI's
	if (`TACTICALRULES.GetLocalClientPlayerObjectID() != XComGameState_Player(EventSource).ObjectID)
		return ELR_NoInterrupt;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2AchievementTracker_DLC_Day90.OnTurnBegun");
	AchievementData = GetAchievementData(NewGameState);

	// Reset the Overdrive shots array
	AchievementData.arrOverdriveShotsThisTurn.Length = 0;

	`TACTICALRULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnKillMail(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit SourceUnit, KilledUnit;
	local Name CharacterGroupName;

	if (NewGameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	if (`XENGINE.IsSinglePlayerGame())
	{
		SourceUnit = XComGameState_Unit(EventSource);
		KilledUnit = XComGameState_Unit(EventData);

		if (SourceUnit != none && KilledUnit != none)
		{
			if (SourceUnit.GetMyTemplateName() == 'SparkSoldier' || SourceUnit.GetMyTemplateName() == 'LostTowersSpark')
			{
				CharacterGroupName = KilledUnit.GetMyTemplate().CharacterGroupName;

				if (CharacterGroupName == 'AdventPsiWitch')
				{
					`log("Shen's Last Gift Achievement Awarded: Matter Over Mind");
					`ONLINEEVENTMGR.UnlockAchievement(AT_KillAvatarWithSpark);
				}

				if (KilledUnit.GetMyTemplate().bIsRobotic)
				{
					`log("Shen's Last Gift Achievement Awarded: Axles to Axles, Bolts to Bolts");
					`ONLINEEVENTMGR.UnlockAchievement(AT_KillRobotWithSpark);
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

// This is called when a unit dies
static function EventListenerReturn OnUnitDied(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local Name CharacterGroupName;
	local XComGameStateContext_Ability AbilityContext;
	
	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	if (`XENGINE.IsSinglePlayerGame())
	{
		UnitState = XComGameState_Unit(EventData);

		if (UnitState != none)
		{
			CharacterGroupName = UnitState.GetMyTemplate().CharacterGroupName;

			if (CharacterGroupName == 'FeralMEC')
			{
				if (UnitState.IsUnitApplyingEffectName(class'X2Ability_SparkAbilitySet'.default.SparkSelfDestructEffectName))
				{
					AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
					if (AbilityContext == none || AbilityContext.InputContext.SourceObject.ObjectID != UnitState.ObjectID)
					{
					`log("Shen's Last Gift Achievement Awarded: Make 'Em Go Boom");
					`ONLINEEVENTMGR.UnlockAchievement(AT_KillPrimedDerelictMEC);
				}
			}
		}
	}
	}

	return ELR_NoInterrupt;
}

// This is called when an item is constructed
static function EventListenerReturn OnItemConstructed(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Soldier;
	local bool bSparkFound;
	local int idx;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// Make sure there is a living Spark for the gear to be equipped on
	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		Soldier = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

		if (Soldier != none && Soldier.IsAlive() && Soldier.IsSoldier() && Soldier.GetMyTemplateName() == 'SparkSoldier')
		{
			bSparkFound = true;
			break;
		}
	}

	if (bSparkFound && XComHQ.HasItemByName('SparkRifle_BM_Schematic') && XComHQ.HasItemByName('PoweredSparkArmor_Schematic'))
	{
		`log("Shen's Last Gift Achievement Awarded: Bells and Whistles");
		`ONLINEEVENTMGR.UnlockAchievement(AT_BuyAllSparkGear);
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnResearchCompleted(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_Tech TechState;
	local XComGameState_HeadquartersXCom XComHQ;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	TechState = XComGameState_Tech(EventData); 
	
	if (TechState != none && (TechState.GetMyTemplateName() == 'MechanizedWarfare' || TechState.GetMyTemplateName() == 'BuildSpark'))
	{
		`log("Shen's Last Gift Achievement Awarded: Just Like Dad Used To Make");
		`ONLINEEVENTMGR.UnlockAchievement(AT_BuildSpark);

		// If the player builds a spark when the highest tier of armor and weapons are unlocked
		if (XComHQ.HasItemByName('SparkRifle_BM_Schematic') && XComHQ.HasItemByName('PoweredSparkArmor_Schematic'))
		{
			`log("Shen's Last Gift Achievement Awarded: Bells and Whistles");
			`ONLINEEVENTMGR.UnlockAchievement(AT_BuyAllSparkGear);
		}
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnUnitPromoted(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{	
	local XComGameState_Unit SourceUnit;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}
	
	SourceUnit = XComGameState_Unit(EventData);
	if (SourceUnit != None && SourceUnit.GetSoldierClassTemplateName() == 'Spark')
	{
		if (SourceUnit.GetRank() >= SourceUnit.GetSoldierClassTemplate().GetMaxConfiguredRank())
		{
			`log("Shen's Last Gift Achievement Awarded: Our New Overlords");
			`ONLINEEVENTMGR.UnlockAchievement(AT_PromoteSparkVanguard);
		}
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnOverdriveActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local XComGameState_DLC_Day90AchievementData AchievementData;
	local OverdriveShots UnitOverdriveShots;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	if (`XENGINE.IsSinglePlayerGame())
	{
		UnitState = XComGameState_Unit(EventSource);
		if (UnitState.GetMyTemplateName() == 'SparkSoldier' || UnitState.GetMyTemplateName() == 'LostTowersSpark')
		{
			AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
			if (AbilityContext != none && AbilityContext.IsHitResultHit(AbilityContext.ResultContext.HitResult))
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2AchievementTracker_DLC_Day90.OnOverdriveActivated");
				AchievementData = GetAchievementData(NewGameState);

				// Update the list of units who have used Overdrive this turn
				if (AchievementData.arrOverdriveShotsThisTurn.Find('UnitID', UnitState.ObjectID) == INDEX_NONE)
				{
					UnitOverdriveShots.UnitID = UnitState.ObjectID;
					UnitOverdriveShots.NumShots = 0;
					AchievementData.arrOverdriveShotsThisTurn.AddItem(UnitOverdriveShots);
				}

				`TACTICALRULES.SubmitGameState(NewGameState);
			}
		}
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnStandardShotActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local XComGameState_DLC_Day90AchievementData AchievementData;
	local int iIndex;
	
	if (`XENGINE.IsSinglePlayerGame())
	{
		UnitState = XComGameState_Unit(EventSource);
		if (UnitState.GetMyTemplateName() == 'SparkSoldier' || UnitState.GetMyTemplateName() == 'LostTowersSpark')
		{
			AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
			if (AbilityContext != none && AbilityContext.IsHitResultHit(AbilityContext.ResultContext.HitResult))
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2AchievementTracker_DLC_Day90.OnStandardShotActivated");
				AchievementData = GetAchievementData(NewGameState);

				// Increment the number of shots taken for units who have used Overdrive this turn
				iIndex = AchievementData.arrOverdriveShotsThisTurn.Find('UnitID', UnitState.ObjectID);
				if (iIndex != INDEX_NONE)
				{
					AchievementData.arrOverdriveShotsThisTurn[iIndex].NumShots++;

					// Award the achievement if the Spark has hit 3 shots during Overdrive
					if (AchievementData.arrOverdriveShotsThisTurn[iIndex].NumShots >= 3)
					{
						`log("Shen's Last Gift Achievement Awarded: Always Be Shooting");
						`ONLINEEVENTMGR.UnlockAchievement(AT_HitThreeOverdriveShots);
					}
				}

				`TACTICALRULES.SubmitGameState(NewGameState);
			}
		}
	}

	return ELR_NoInterrupt;
}