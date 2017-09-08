//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_BondmateBleedout extends X2Effect_Persistent
	config(GameCore);

var protected const config int BleedoutDurationAdjustment;

function AdjustEffectDuration(const out EffectAppliedData ApplyEffectParameters, out int Duration)
{
	if(ApplyEffectParameters.EffectRef.LookupType == TELT_BleedOutEffect)
	{
		Duration += BleedoutDurationAdjustment;
	}
}

defaultproperties
{
	EffectName="BondmateBleedout"
	bEffectForcesBleedout=true
}