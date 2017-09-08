//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyEffectDuration.uc
//  AUTHOR:  Russell Aasland  --  2/28/2017
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyEffectDuration extends X2SitRepEffectTemplate;

var array<name> EffectNames;

var int DurationDelta;
var int DurationMin;
var int DurationMax;
var eTeam TeamFilter;

function int MaybeModifyDuration(X2Effect_Persistent NewEffect, XComGameState_Unit Target, int CurrentDuration )
{
	if (EffectNames.Find( NewEffect.EffectName ) == INDEX_NONE)
		return CurrentDuration;

	if (TeamFilter != eTeam_All)
	{
		if (Target == none)
			return CurrentDuration;

		if (Target.GetTeam() != TeamFilter)
			return CurrentDuration;
	}

	CurrentDuration += DurationDelta;
	CurrentDuration = Clamp( DurationDelta, DurationMin, DurationMax );

	return CurrentDuration;
}

defaultproperties
{
	DurationDelta=0
	DurationMin=0
	DurationMax=100000
	TeamFilter=eTeam_All;
}