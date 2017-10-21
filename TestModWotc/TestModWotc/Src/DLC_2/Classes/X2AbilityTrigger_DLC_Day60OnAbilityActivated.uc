//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityTrigger_DLC_Day60OnAbilityActivated.uc
//  AUTHOR:  Alex Cheng
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2AbilityTrigger_DLC_Day60OnAbilityActivated extends X2AbilityTrigger_OnAbilityActivated
	config(GameCore);

var config array<Name> RulerActionExclusions_XComEffects;
var config array<Name> RulerActionExclusions_AbilityNames;


simulated function bool OnAbilityActivated(XComGameState_Ability EventAbility, XComGameState GameState, XComGameState_Ability TriggerAbility, Name InEventID)
{

	// TODO- update - check new game state to check if the unit that activated the ability has used up an action point.
	 // If so, activate the ruler action ability.
	local GameRulesCache_Unit UnitCache;
	local XComGameState_Unit AlienRulerUnit;
	local XComGameStateHistory History;
	local int i, StartIndex;
	local UnitValue LastChainIndexBTStart;

	History = `XCOMHISTORY;
	if( AbilityCanTriggerAlienRulerAction(EventAbility, GameState, TriggerAbility.OwnerStateObject.ObjectID) )
	{
		StartIndex = History.GetEventChainStartIndex();
		// Check revealed status at the start of the current event chain.
		AlienRulerUnit = XComGameState_Unit(History.GetGameStateForObjectID(TriggerAbility.OwnerStateObject.ObjectID,,StartIndex));
		// Only valid if unit is AI-controlled.  (for debug, with DropUnit commands)
		if( AlienRulerUnit.GetTeam() != eTeam_Alien || AlienRulerUnit.IsUnrevealedAI(StartIndex) )
		{
			return false;
		}
		if( StartIndex != INDEX_NONE )
		{
			// Check the last start index for the current alien ruler game state.
			AlienRulerUnit = XComGameState_Unit(History.GetGameStateForObjectID(TriggerAbility.OwnerStateObject.ObjectID));
			AlienRulerUnit.GetUnitValue('LastChainIndexBTStart', LastChainIndexBTStart);
			if( LastChainIndexBTStart.fValue == StartIndex ) // Fail if we already started a BT from this chain.
				return false;
		}

		if( `TACTICALRULES.GetGameRulesCache_Unit(TriggerAbility.OwnerStateObject, UnitCache) )
		{
			for( i = 0; i < UnitCache.AvailableActions.Length; ++i )
			{
				if( UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == TriggerAbility.ObjectID 
				   && UnitCache.AvailableActions[i].AvailableCode == 'AA_Success' )
				{
					class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], 0, , , , , , , SPT_AfterSequential);
					break;
				}
			}
		}
		return true;
	}
	return false;
}

function bool AbilityCanTriggerAlienRulerAction(XComGameState_Ability EventAbility, XComGameState GameState, int RulerObjID )
{
	local XComGameState_Unit Instigator;
	local XComGameState_BaseObject CurrUnitState, PrevUnitState;
	local XComGameStateHistory History;
	local name ExclusionName;
	local int StartIndex;
	local XComGameStateContext_Ability ActivatedAbilityStateContext;
	local X2GameRulesetVisibilityManager VisibilityMgr;
	local GameRulesCache_VisibilityInfo VisInfo;
	local PathingInputData PathData;
	local TTile MoveTile;
	local bool bPathVisibleToRuler;

	if( (`CHEATMGR != None) && (`CHEATMGR.bAbilitiesDoNotTriggerAlienRulerAction) )
	{
		return false;
	}

	if(GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		// only after the ability chain resolves, never as an interrupt
		return false;
	}

	// Check - XCOM-soldier activated ability
	// Skip if the unit is not an XCom soldier or if he is concealed.
	History = `XCOMHISTORY;
	Instigator = XComGameState_Unit(History.GetGameStateForObjectID(EventAbility.OwnerStateObject.ObjectID));
	if( Instigator == None || Instigator.GetTeam() != eTeam_XCom )
		return false;

	ActivatedAbilityStateContext = XComGameStateContext_Ability(GameState.GetContext());
	if( Instigator.IsConcealed() ) // Check if this ability will break the instigator's concealment.
	{
		if( EventAbility.RetainConcealmentOnActivation(ActivatedAbilityStateContext) )
		{
			return false;
		}
	}

	StartIndex = History.GetEventChainStartIndex();

	if( StartIndex == INDEX_NONE || StartIndex == History.GetCurrentHistoryIndex())
	{
		// Check - was an action point used from this ability?
		History.GetCurrentAndPreviousGameStatesForObjectID(EventAbility.OwnerStateObject.ObjectID, PrevUnitState, CurrUnitState);
	}
	else
	{
		CurrUnitState = Instigator;
		PrevUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EventAbility.OwnerStateObject.ObjectID, , StartIndex-1));
	}
	if( PrevUnitState == None || CurrUnitState == None )
	{
		return false;
	}

	if( XComGameState_Unit(CurrUnitState).ActionPoints.Length >= XComGameState_Unit(PrevUnitState).ActionPoints.Length )
	{
		return false;
	}

	VisibilityMgr = `TACTICALRULES.VisibilityMgr;
	// New for XPack - Do not trigger Ruler actions if the source is not visible to the Ruler.

	// Check LoS on all tiles this unit pathed through via this ability.
	if (ActivatedAbilityStateContext != None && ActivatedAbilityStateContext.InputContext.MovementPaths.Length > 0)
	{
		// First check if the current location is visible.
		VisibilityMgr.GetVisibilityInfo(RulerObjID, EventAbility.OwnerStateObject.ObjectID, VisInfo);
		if (!VisInfo.bVisibleGameplay) // If currently not visible, test all movement tiles if any point was visible.
		{
			// If there was movement involved in this ability, test if at any tile, this unit was visible to the Ruler.
			foreach ActivatedAbilityStateContext.InputContext.MovementPaths(PathData)
			{
				foreach PathData.MovementTiles(MoveTile)
				{
					bPathVisibleToRuler = class'X2TacticalVisibilityHelpers'.static.CanUnitSeeLocation(RulerObjID, MoveTile);
					if (bPathVisibleToRuler)
					{
						break;
					}
				}
				if (bPathVisibleToRuler)
				{
					break;
				}
			}

			// No ruler action if all tiles in the movement path are not visible to the ruler.
			if (!bPathVisibleToRuler)
				return false;
		}
	}
	else if( ActivatedAbilityStateContext != None && ActivatedAbilityStateContext.InputContext.PrimaryTarget.ObjectID != RulerObjID )
	{
		// No movement?  Just check the current unit tile.
		VisibilityMgr.GetVisibilityInfo(RulerObjID, EventAbility.OwnerStateObject.ObjectID, VisInfo);
		if (!VisInfo.bVisibleGameplay)
		{
			return false;
		}
	}


	// Check against effects and abilities excluded from ini file.
	foreach RulerActionExclusions_XComEffects(ExclusionName)
	{
		if( Instigator.IsUnitAffectedByEffectName(ExclusionName) )
		{
			return false;
		}
	}

	foreach RulerActionExclusions_AbilityNames(ExclusionName)
	{
		if( EventAbility.GetMyTemplateName() == ExclusionName )
		{
			return false;
		}
	}

	return true;
}

