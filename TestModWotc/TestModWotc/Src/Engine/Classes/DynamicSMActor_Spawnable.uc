/** 
 * Concrete version of DynamicSMActor for spawning mid-game. 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class DynamicSMActor_Spawnable extends DynamicSMActor;

// FIRAXIS BEGIN - MHU - Debugging only
//event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
//{
//	super.Touch(Other, OtherComp, HitLocation, HitNormal);
//	`log(Self@"was touched by"@Other);
//}
//event UnTouch( Actor Other )
//{
//	super.UnTouch(Other);
//	`log(self@"was untouched by"@Other);
//}
// FIRAXIS END

defaultproperties
{
	bCollideActors=TRUE
	bBlockActors=TRUE
}
