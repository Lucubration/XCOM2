/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class DecalActorMovable extends DecalActorBase
	native(Decal)
	placeable;

defaultproperties
{
	Begin Object Name=NewDecalComponent
		bMovableDecal=TRUE
		DetailMode=DM_High
	End Object	

	bStatic=FALSE
	bNoDelete=TRUE
	bMovable=TRUE
	bHardAttach=TRUE
}
