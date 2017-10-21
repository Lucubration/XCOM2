//---------------------------------------------------------------------------------------
//  FILE:    X2AchievementTracker_DLC_Day60.uc
//  AUTHOR:  Joe Weinhoffer -- 4/5/2016
//  PURPOSE: Tracks achievements for Alien Hunters DLC
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AchievementTracker_DLC_Day60 extends Object;

// Singleton creation / access of XComGameState_DLC_Day60AchievementData.
static function XComGameState_DLC_Day60AchievementData GetAchievementData(XComGameState NewGameState)
{
	local XComGameState_DLC_Day60AchievementData AchievementData;

	AchievementData = XComGameState_DLC_Day60AchievementData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_DLC_Day60AchievementData', true));
	if (AchievementData == none)
	{
		AchievementData = XComGameState_DLC_Day60AchievementData(NewGameState.CreateNewStateObject(class'XComGameState_DLC_Day60AchievementData'));
	}
	else
	{
		AchievementData = XComGameState_DLC_Day60AchievementData(NewGameState.ModifyStateObject(class'XComGameState_DLC_Day60AchievementData', AchievementData.ObjectID));
	}
	
	return AchievementData;
}

// Catches the end of a mission
static function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BattleData Battle;
	local XComGameState_DLC_Day60AchievementData AchievementData;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	Battle = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	`log("DLC2 OnTacticalGameEnd");

	// Make sure the player won
	if (!(Battle.bLocalPlayerWon && !Battle.bMissionAborted))
	{
		return ELR_NoInterrupt;
	}
	
	// Clear the Alien Nest mission
	if (string(Battle.MapData.ActiveMission.MissionName) == "AlienNest")
	{
		`log("Alien Hunters Achievement Awarded: A Forbidden Experiment");
		`ONLINEEVENTMGR.UnlockAchievement(AT_CompleteAlienNest);
	}
	
	// Clear the relevant data from the Achievement Data singleton
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2AchievementTracker_DLC_Day60.OnTacticalGameEnd");
	AchievementData = GetAchievementData(NewGameState);
	AchievementData.arrActivatedRulerArmorAbilities.Length = 0;
	`TACTICALRULES.SubmitGameState(NewGameState);
	
	return ELR_NoInterrupt;
}

// This is called when a unit dies
static function EventListenerReturn OnUnitDied(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext GameStateContext;
	local XComGameStateContext_Ability AbilityStateContext;
	local XComGameState_Unit UnitState;
	local XComGameState_AlienRulerManager RulerMgr;
	local StateObjectReference RulerRef;
	local Name CharacterName;
	local int EventChainIndex, LastHistoryIndex;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}
	
	if (`XENGINE.IsSinglePlayerGame())
	{
		History = `XCOMHISTORY;
			UnitState = XComGameState_Unit(EventData);
		RulerMgr = XComGameState_AlienRulerManager(History.GetSingleGameStateObjectForClass(class'XComGameState_AlienRulerManager', true));

		if (UnitState != none)
		{
			CharacterName = UnitState.GetMyTemplateName();

			if (CharacterName == 'ViperKing')
			{
				// Achievement: Kill Viper King
				`log("Alien Hunters Achievement Awarded: Viper Vanquisher");
				`ONLINEEVENTMGR.UnlockAchievement(AT_KillViperKing);
			}
			else if (CharacterName == 'BerserkerQueen')
			{
				// Achievement: Kill Berserker Queen
				`log("Alien Hunters Achievement Awarded: Berserker Breaker");
				`ONLINEEVENTMGR.UnlockAchievement(AT_KillBerserkerQueen);
			}
			else if (CharacterName == 'ArchonKing')
			{
				// Achievement: Kill Archon King
				`log("Alien Hunters Achievement Awarded: Archon Annihilator");
				`ONLINEEVENTMGR.UnlockAchievement(AT_KillArchonKing);
			}

			if (IsUnitAlienRuler(UnitState))
			{
				if (class'X2Helpers_DLC_Day60'.static.GetRulerNumAppearances(UnitState) <= 1)
				{
					// Achievement: Kill an Alien Ruler on the first encounter
					`log("Alien Hunters Achievement Awarded: Regicide");
					`ONLINEEVENTMGR.UnlockAchievement(AT_KillRulerFirstEncounter);
				}

				// First check if there is only one ruler left alive
				if (RulerMgr != none && (RulerMgr.DefeatedAlienRulers.Length + 1 == RulerMgr.AllAlienRulers.Length))
				{
					// Then ensure that the active ruler is the unit which was just killed
					RulerRef = RulerMgr.GetAlienRulerReference(UnitState.GetMyTemplateName());
					if (RulerRef.ObjectID != 0 && RulerMgr.ActiveAlienRulers.Length == 1 && RulerMgr.ActiveAlienRulers[0].ObjectID == RulerRef.ObjectID)
					{
						// Achievement: Kill all of the Alien Rulers
						`log("Alien Hunters Achievement Awarded: Kingslayer");
						`ONLINEEVENTMGR.UnlockAchievement(AT_KillAllRulers);
					}
				}

				// Check if the ruler was killed while attempting to escape
				if (UnitState.AffectedByEffectNames.Find(class'X2Ability_DLC_Day60AlienRulers'.default.CallForEscapeEffectName) != INDEX_NONE)
				{
					GameStateContext = GameState.GetContext().GetFirstStateInEventChain().GetContext();
					LastHistoryIndex = History.GetCurrentHistoryIndex();
					for (EventChainIndex = GameStateContext.EventChainStartIndex; !GameStateContext.bLastEventInChain && EventChainIndex <= LastHistoryIndex; ++EventChainIndex)
					{
						GameStateContext = History.GetGameStateFromHistory(EventChainIndex).GetContext();
						AbilityStateContext = XComGameStateContext_Ability(GameStateContext);
						if (AbilityStateContext != None)
						{
							// Ensure that the ruler was moving towards the portal
							if (AbilityStateContext.InputContext.AbilityTemplateName == 'StandardMove' &&
								AbilityStateContext.InputContext.SourceObject.ObjectID == UnitState.ObjectID)
							{
								`log("Alien Hunters Achievement Awarded: Not Throwing Away My Shot");
								`ONLINEEVENTMGR.UnlockAchievement(AT_KillRulerDuringEscape);
								break;
							}
						}
					}
				}
			}
		}
	}
	
	return ELR_NoInterrupt;
}

static function bool IsUnitAlienRuler(XComGameState_Unit Unit)
{
	local Name CharacterName;

	CharacterName = Unit.GetMyTemplateName();

	return (CharacterName == 'ViperKing' || CharacterName == 'BerserkerQueen' || CharacterName == 'ArchonKing');
}

// This is called when a unit dies
static function EventListenerReturn OnItemConstructed(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	
	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	
	if (XComHQ.HasItemByName('HunterRifle_BM_Schematic') && XComHQ.HasItemByName('HunterPistol_BM_Schematic') && XComHQ.HasItemByName('HunterAxe_BM_Schematic'))
	{
		`log("Alien Hunters Achievement Awarded: Deadly Arsenal");
		`ONLINEEVENTMGR.UnlockAchievement(AT_BuyAllHunterWeapons);
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnRulerArmorAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit TargetState;
	local XComGameState_DLC_Day60AchievementData AchievementData;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	if (`XENGINE.IsSinglePlayerGame())
	{
		AbilityState = XComGameState_Ability(EventData);
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityState != none && AbilityContext != none)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2AchievementTracker_DLC_Day60.OnRulerArmorAbilityActivated");
			AchievementData = GetAchievementData(NewGameState);

			if (AbilityContext.IsHitResultHit(AbilityContext.ResultContext.HitResult))
			{
				if (AbilityContext.InputContext.PrimaryTarget.ObjectID != 0)
				{
					TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
					if (IsUnitAlienRuler(TargetState))
					{
						`log("Alien Hunters Achievement Awarded: Enemy Adopted");
						`ONLINEEVENTMGR.UnlockAchievement(AT_UseRulerArmorAbilityOnRuler);
					}
				}

				// Update the list of ruler armor abilities which have been used on this mission
				if (AchievementData.arrActivatedRulerArmorAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
				{
					AchievementData.arrActivatedRulerArmorAbilities.AddItem(AbilityState.GetMyTemplateName());
				}
			}

			`TACTICALRULES.SubmitGameState(NewGameState);

			if (AchievementData.arrActivatedRulerArmorAbilities.Length >= 3)
			{
				`log("Alien Hunters Achievement Awarded: Now I Am The Master");
				`ONLINEEVENTMGR.UnlockAchievement(AT_UseAllRulerArmorAbilities);
			}
		}
	}

	return ELR_NoInterrupt;
}