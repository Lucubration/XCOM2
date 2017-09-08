//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XComXenoformPreviewVolume.uc
//  AUTHOR:  Ken Derda -- 11/02/16
//  PURPOSE: This volume is for previewing Xenoform grass in the editor.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class XComXenoformPreviewVolume extends Volume
	hidecategories(Advanced, Attachment, Collision, Volume)
	native
	placeable;
	
DefaultProperties
{
	Begin Object Name=BrushComponent0
		CollideActors=false
		bAcceptsLights=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CanBlockCamera=false
		bDisableAllRigidBody=true
	End Object

	bCollideActors=false
	bBlockActors=false
}
