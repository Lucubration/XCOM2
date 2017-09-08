//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffect_ModifyHackDefenses.uc
//  AUTHOR:  Russell Aasland  --  2/23/2017
//  PURPOSE: Modify the hack defense of hackable interactive actors
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2SitRepEffect_ModifyHackDefenses extends X2SitRepEffectTemplate;

var Delegate<GetValueDelegate> DefenseDeltaFn;
var int DefenseMin;
var int DefenseMax;

delegate GetValueDelegate( out int Value );

defaultproperties
{
	DefenseMin=0
	DefenseMax=10000
}