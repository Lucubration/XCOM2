//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateContext_AbilityPointEvent.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComGameStateContext_AbilityPointEvent extends XComGameStateContext
	config(GameCore);

var name AbilityPointTemplateName;
var StateObjectReference AssociatedUnitRef;
var int TriggerHistoryIndex;

var localized string GainedAbilityPointFlyoverSingular;
var localized string GainedAbilityPointFlyoverPlural;
var localized string GainedAbilityPointWorldMessageSingular;
var localized string GainedAbilityPointWorldMessagePlural;

event string SummaryString()
{
	return "Ability Point Event: "$AbilityPointTemplateName;
}

//XComGameStateContext interface
//***************************************************
/// <summary>
/// Should return true if ContextBuildGameState can return a game state, false if not. Used internally and externally to determine whether a given context is
/// valid or not.
/// </summary>
function bool Validate(optional EInterruptionStatus InInterruptionStatus)
{
	return true;
}

/// <summary>
/// Override in concrete classes to convert the InputContext into an XComGameState ( or XComGameStates). The method is responsible
/// for adding these game states to the history
/// </summary>
/// <param name="Depth">ContextBuildGameState can be called recursively ( for interrupts ). Depth is used to track the recursion depth</param>
function XComGameState ContextBuildGameState()
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_BattleData BattleData;
	local int NumPointsToAward, MaxPointsAllowed;
	local X2AbilityPointTemplate APTemplate;

	APTemplate = class'X2EventListener_AbilityPoints'.static.GetAbilityPointTemplate( AbilityPointTemplateName );
	`assert( APTemplate != none );

	XComHQ = XComGameState_HeadquartersXCom( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_HeadquartersXCom' ) );
	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData' ) );

	// cap the ability points (if necessary)
	NumPointsToAward = APTemplate.NumPointsAwarded * XComHQ.BonusAbilityPointScalar;
	if (APTemplate.TacticalEvent)
	{
		MaxPointsAllowed = class'X2EventListener_AbilityPoints'.default.MaxTacticalEventAbilityPointsPerBattle * XComHQ.BonusAbilityPointScalar;
		if (BattleData.TacticalEventAbilityPointsGained + NumPointsToAward > MaxPointsAllowed)
		{
			NumPointsToAward = MaxPointsAllowed - BattleData.TacticalEventAbilityPointsGained;
		}
	}

	`assert( NumPointsToAward > 0 ); // this should have been filtered out before getting here

	NewGameState = `XCOMHISTORY.CreateNewGameState( true, self ) ;

	XComHQ = XComGameState_HeadquartersXCom( NewGameState.ModifyStateObject( class'XComGameState_HeadquartersXCom', XComHQ.ObjectID ) );

	// add the resource
	XComHQ.AddResource( NewGameState, 'AbilityPoint', NumPointsToAward );

	// add a copy of the source unit for the visualization for now.
	NewGameState.ModifyStateObject( class'XComGameState_Unit', AssociatedUnitRef.ObjectID );

	// track tactical event points gained in this battle (to enfore a cap per battle)
	if (APTemplate.TacticalEvent)
	{
		BattleData = XComGameState_BattleData( NewGameState.ModifyStateObject( class'XComGameState_BattleData', BattleData.ObjectID ) );

		BattleData.TacticalEventAbilityPointsGained += NumPointsToAward;
		BattleData.TacticalEventGameStates.AddItem( TriggerHistoryIndex );
	}

	NewGameState.GetContext().SetAssociatedPlayTiming( SPT_AfterSequential );

	return NewGameState;
}

/// <summary>
/// Override in concrete classes to properly handle interruptions. The method should instantiate a new 'interrupted' context and return a game state that reflects 
/// being interrupted. 'Self' for this method is the context that is getting interrupted. 
///
/// Example:
/// A move action game state would set the location of the moving unit to be the interruption tile location.
///
/// NOTE: when the interruption completes, the system will try to resume the interrupted context. Building interruption game states should ensure that the
///       interruption state will not block / prevent resuming (ie. abilities should not apply their cost in an interrupted game state)
/// </summary>
function XComGameState ContextBuildInterruptedGameState(int InterruptStep, EInterruptionStatus InInterruptionStatus)
{
	return none;
}

/// <summary>
/// Override in concrete classes to convert the ResultContext and AssociatedState into a set of visualization tracks
/// </summary>
protected function ContextBuildVisualization()
{
	local XComGameState_Unit SourceUnit;
	local VisualizationActionMetadata BuildTrack;
	local X2AbilityPointTemplate APTemplate;
	local X2Action_PlaySoundAndFlyover FlyoverAction;
	local X2Action_PlayMessageBanner WorldMessageAction;
	local XGParamTag Tag;
	local XComGameState_HeadquartersXCom XComHQ;

	APTemplate = class'X2EventListener_AbilityPoints'.static.GetAbilityPointTemplate( AbilityPointTemplateName );

	XComHQ = XComGameState_HeadquartersXCom( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_HeadquartersXCom' ) );

	// add a flyover track for every unit in the game state. This timing of this is too early to look good
	// but since Ryan is tearing it all out there is no reason to augment the visualization system to allow
	// it to look pretty
	foreach AssociatedState.IterateByClassType( class'XComGameState_Unit', SourceUnit )
	{
		BuildTrack.StateObject_OldState = SourceUnit.GetPreviousVersion();
		BuildTrack.StateObject_NewState = SourceUnit;

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, self);

		Tag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		Tag.StrValue0 = APTemplate.ActionFriendlyName;
		Tag.IntValue0 = APTemplate.NumPointsAwarded * XComHQ.BonusAbilityPointScalar;
		FlyoverAction = X2Action_PlaySoundAndFlyover(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildTrack, self));
		FlyoverAction.SetSoundAndFlyOverParameters(none, `XEXPAND.ExpandString(Tag.IntValue0 == 1 ? default.GainedAbilityPointFlyoverSingular : default.GainedAbilityPointFlyoverPlural), '', eColor_Good);

		WorldMessageAction = X2Action_PlayMessageBanner(class'X2Action_PlayMessageBanner'.static.AddToVisualizationTree(BuildTrack, self));
		WorldMessageAction.AddMessageBanner(class'UIEventNoticesTactical'.default.AbilityPointGainedTitle,
									   ,
									   SourceUnit.GetName(eNameType_RankFull),
										`XEXPAND.ExpandString(Tag.IntValue0 == 1 ? default.GainedAbilityPointWorldMessageSingular : default.GainedAbilityPointWorldMessagePlural),
									   eUIState_Good);
	}
}