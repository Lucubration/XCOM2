/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class LightInjectorComponent extends ActorComponent
	native;

var native private	transient const pointer	SceneInfo;

var() const interp float Brightness <UIMin=0.0 | UIMax=2.0>;

var() const interp color LightColor;

/** Is this light enabled? */
var() const bool bEnabled;

var native const	transient matrix			LightToWorld;

cpptext
{
	virtual void Attach();
	virtual void UpdateTransform();
	virtual void Detach( UBOOL bWillReattach );

	virtual void Serialize(FArchive& Ar);

	virtual void SetParentToWorld(const FMatrix& ParentToWorld);
	virtual FVector GetPosition() {return LightToWorld.GetOrigin();}
}

defaultproperties
{
	Brightness=1.0
	LightColor=(R=255,G=255,B=255)
	bEnabled=TRUE
}