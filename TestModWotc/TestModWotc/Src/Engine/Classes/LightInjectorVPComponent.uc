/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class LightInjectorVPComponent extends ActorComponent
	native;

var native private transient const pointer	SceneInfo;

struct native LIVPData
{
	var vector Position;
	var vector Color;
};

var array<LIVPData> InjectorData;

var float BrightnessScale;

var bool bEnabled;

cpptext
{
	virtual void Attach();
	virtual void Detach( UBOOL bWillReattach );

	virtual void Serialize(FArchive& Ar);
}

native function AddInjector(vector InColor, vector InPosition);
native function ClearInjectors();

native function SetEnabled(bool bInEnabled);

defaultproperties
{
	BrightnessScale=1.0
	bEnabled=TRUE
}