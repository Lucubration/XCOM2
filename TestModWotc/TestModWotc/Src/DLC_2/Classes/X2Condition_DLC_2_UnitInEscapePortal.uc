//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2Condition_DLC_2_UnitInEscapePortal extends X2Condition
	config(GameCore);

var config float ALIEN_RULER_ESCAPE_RADIUS_TILES_SQ;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit RulerUnit;
	local XComGameState_Effect CallForEscapeEffect;
	local TTile EscapeTile;
	local XComWorldData World;
	local vector EscapeLocation;

	RulerUnit = XComGameState_Unit(kTarget);
	if( RulerUnit == none )
	{
		return 'AA_NotAUnit';
	}

	CallForEscapeEffect = RulerUnit.GetUnitAffectedByEffectState('CallForEscapeEffect');

	if( (CallForEscapeEffect != none) && (CallForEscapeEffect.ApplyEffectParameters.AbilityInputContext.TargetLocations.Length == 1) )
	{
		World = `XWORLD;

		EscapeLocation = CallForEscapeEffect.ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
		EscapeTile = World.GetTileCoordinatesFromPosition(EscapeLocation);
		if( class'Helpers'.static.IsTileInRange(RulerUnit.TileLocation, EscapeTile, default.ALIEN_RULER_ESCAPE_RADIUS_TILES_SQ) )
		{
			// The Ruler is within the escape radius
			return 'AA_Success';
		}
	}

	return 'AA_NotInsideEvacZone';
}