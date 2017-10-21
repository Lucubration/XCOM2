/**
 * this volume only blocks the path builder - it has no gameplay collision
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class PathBlockingVolume extends Volume
	native
	placeable;

var() bool bBlocksVisibility; //Firaxis - permits path blocking volumes to avoid blocking visibility

cpptext
{
#if WITH_EDITOR
	virtual void SetCollisionForPathBuilding(UBOOL bNowPathBuilding);
#endif
}

defaultproperties
{
	Begin Object Name=BrushComponent0
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockRigidBody=true
		AlwaysLoadOnClient=false
		AlwaysLoadOnServer=false
	End Object

	bWorldGeometry=true
	bCollideActors=false
	bBlockActors=true
	bBlocksVisibility=false; //Firaxis - permits path blocking volumes to avoid blocking visibility
}
