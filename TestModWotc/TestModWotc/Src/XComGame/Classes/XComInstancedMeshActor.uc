//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XComInstancedMeshActor.uc
//  AUTHOR:  Marc Giordano  --  03/24/2010
//  PURPOSE: Represents a static mesh that can be instanced multiple times. All instances
//           will be rendered in a single draw call.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class XComInstancedMeshActor extends XComLevelActor
		native(Level)
		hidecategories(StaticMeshActor);

cpptext
{
	virtual void PostLoad();

	/**
	* Sets InstanceStartCullDistance and InstanceEndCullDistance.
	*/
	virtual void SetInstanceCullDistances();
};

var() const editconst InstancedStaticMeshComponent InstancedMeshComponent;

native function UpdateMeshInstances();

native simulated function SetDitherEnable(bool bEnableDither);

native simulated function SetPrimitiveHidden(bool bInHidden);
native simulated function SetPrimitiveCutdownFlagImm(bool bShouldCutdown);
native simulated function SetPrimitiveCutoutFlagImm(bool bShouldCutout);
native simulated function SetVisFadeFlag(bool bVisFade, optional bool bForceReattach = false);

native simulated function GetPrimitiveVisHeight(out float fCutdownHeight, out float fCutoutHeight,
	out float fOpacityMaskHeight, out float fPreviousOpacityMaskHeight);

native simulated function SetPrimitiveVisHeight(float fCutdownHeight, float fCutoutHeight,
	float fOpacityMaskHeight, float fPreviousOpacityMaskHeight);

native simulated function GetPrimitiveVisFadeValues(out float CutoutFade, out float TargetCutoutFade);
native simulated function SetPrimitiveVisFadeValues(float CutoutFade, float TargetCutoutFade);

native simulated function float GetCutdownOffset();
native simulated function bool CanUseCutout();

native simulated function SetHideableFlag(bool bShouldHide);
native simulated function ChangeVisibilityAndHide(bool bShow, float fCutdownHeight, float fCutoutHeight);

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=TRUE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		Translation=(X=0,Y=0,Z=64)
	End Object
	Components.Add(Sprite)

	Begin Object Class=InstancedStaticMeshComponent Name=InstancedMeshComponent0
		CastShadow=false
		BlockNonZeroExtent=false
		BlockZeroExtent=false
		BlockActors=false
		CollideActors=true
	End object
	InstancedMeshComponent=InstancedMeshComponent0
	CollisionComponent=InstancedMeshComponent0
	Components.Add(InstancedMeshComponent0)
}

