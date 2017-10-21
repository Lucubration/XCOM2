/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class DrawLightCapsuleComponent extends DrawCapsuleComponent
	native(Light)
	noexport
	hidecategories(Physics,Collision,PrimitiveComponent,Rendering);

defaultproperties
{
	CapsuleColor=(R=173,G=239,B=231,A=255)
	CapsuleRadius=0.0
	CapsuleHeight=0.0

	AlwaysLoadOnClient=False
	AlwaysLoadOnServer=False

	AbsoluteScale=TRUE
}
