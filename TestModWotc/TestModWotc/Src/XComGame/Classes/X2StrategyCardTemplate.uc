//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyCardTemplate.uc
//  AUTHOR:  Mark Nauta - 10/4/2016
//  PURPOSE: Define Resistance Faction action cards for strategy gameplay
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyCardTemplate extends X2GameplayMutatorTemplate config(GameData);

var localized string					QuoteText; // Quote for UI card
var localized string					QuoteTextAuthor; // Quote author field for UI card

var config int							Strength; // How strong is this card (metric for when card should become available)
var config string						ImagePath; // Image for UI card
var config name							AssociatedEntity; // Name of Faction Template (can be empty if generic card)
var config bool							bContinentBonus; // Can this card be a possible continent bonus

var Delegate<GetDisplayNameDelegate> GetDisplayNameFn;
var Delegate<GetSummaryTextDelegate> GetSummaryTextFn;
var Delegate<CanBePlayedDelegate> CanBePlayedFn;
var Delegate<CanBeRemovedDelegate> CanBeRemovedFn;
var Delegate<ModifyTacticalStartStateDelegate> ModifyTacticalStartStateFn;
var Delegate<GetAbilitiesToGrantDelegate> GetAbilitiesToGrantFn;

delegate string GetDisplayNameDelegate(StateObjectReference InRef);
delegate string GetSummaryTextDelegate(StateObjectReference InRef);
delegate bool CanBePlayedDelegate(StateObjectReference InRef, optional XComGameState NewGameState = none);
delegate bool CanBeRemovedDelegate(StateObjectReference InRef, optional StateObjectReference ReplacementRef);
delegate ModifyTacticalStartStateDelegate(XComGameState StartState);
delegate GetAbilitiesToGrantDelegate(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant);

//---------------------------------------------------------------------------------------
function XComGameState_StrategyCard CreateInstanceFromTemplate(XComGameState NewGameState)
{
	local XComGameState_StrategyCard CardState;

	CardState = XComGameState_StrategyCard(NewGameState.CreateNewStateObject(class'XComGameState_StrategyCard', self));

	return CardState;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}