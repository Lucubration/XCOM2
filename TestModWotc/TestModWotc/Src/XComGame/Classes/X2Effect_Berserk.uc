//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Effect_Berserk.uc    
//  AUTHOR:  David Burchanowski  --  10/3/2016
//  PURPOSE: Panic Effects - Remove control from player and run Panic behavior tree.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_Berserk extends X2Effect_Panicked
	config(GameCore);
defaultproperties
{
	EffectName="Berserk"
}