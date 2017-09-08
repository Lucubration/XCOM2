//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrativeConditionTemplate.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2DynamicNarrativeConditionTemplate extends X2DynamicNarrativeTemplate
	native(core);

var array<name> ConditionNames;
var array<string> ConditionStrings;
var int ConditionValue;

var Delegate<IsMetDelegate> IsConditionMetFn;

delegate bool IsMetDelegate(X2DynamicNarrativeConditionTemplate Template, Object EventData, Object EventSource, XComGameState GameState);

//---------------------------------------------------------------------------------------
function bool IsConditionMet(Object EventData, Object EventSource, XComGameState GameState)
{	
	if (IsConditionMetFn == none)
	{
		`assert(false); // Bad condition name or no IsConditionMet function
	}

	return IsConditionMetFn(self, EventData, EventSource, GameState);
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}