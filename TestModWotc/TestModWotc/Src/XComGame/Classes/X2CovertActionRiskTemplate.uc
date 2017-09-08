//---------------------------------------------------------------------------------------
//  FILE:    X2CovertActionRiskTemplate.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2CovertActionRiskTemplate extends X2StrategyElementTemplate
	config(GameBoard);

var bool						bBlockOtherRisks; // If this risk occurs, all other risks will be disabled

// Config Data
var config int					MinChanceToOccur;
var config int					MaxChanceToOccur;

// Text
var localized String			RiskName;

// Functions
var Delegate<IsRiskAvailableDelegate> IsRiskAvailableFn;
var Delegate<FindTargetDelegate> FindTargetFn;
var Delegate<ApplyRiskDelegate> ApplyRiskFn;
var Delegate<RiskPopupDelegate> RiskPopupFn;

delegate bool IsRiskAvailableDelegate(XComGameState_ResistanceFaction FactionState, optional XComGameState NewGameState); // Used to determine if this Risk is available
delegate StateObjectReference FindTargetDelegate(XComGameState_CovertAction ActionState, out array<StateObjectReference> ExclusionList);
delegate ApplyRiskDelegate(XComGameState NewGameState, XComGameState_CovertAction ActionState, optional StateObjectReference TargetRef);
delegate RiskPopupDelegate(XComGameState_CovertAction ActionState, StateObjectReference TargetRef);