//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyTurretCount.uc
//  AUTHOR:  Russell Aasland  --  1/20/2017
//  PURPOSE: Allows sitreps to modify pod spawn sizes
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyTurretCount extends X2SitRepEffectTemplate
	native(Core);

var int MinCount;
var int MaxCount;
var int CountDelta; // adds this number to the overall force level before clamping to the min and max

var float ZoneWidthMin;
var float ZoneWidthMax;
var float ZoneWidthDelta;

var float ZoneOffsetMin;
var float ZoneOffsetMax;
var float ZoneOffsetDelta;

defaultproperties
{
	MinCount=0
	MaxCount=10000
	CountDelta=0

	ZoneWidthMin=0
	ZoneWidthMax=1000000
	ZoneWidthDelta=0

	ZoneOffsetMin=0
	ZoneOffsetMax=1000000
	ZoneOffsetDelta=0
}