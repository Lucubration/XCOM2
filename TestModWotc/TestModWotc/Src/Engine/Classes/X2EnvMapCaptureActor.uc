/**
 * SceneCaptureCubeMapActor
 *
 * Place this actor in the level iot capture it to a cube map render target texture.
 * Uses a Cube map scene capture component
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class X2EnvMapCaptureActor extends SceneCaptureActor
	native
	hidecategories(SceneCapture)
	dependson(X2SceneCaptureEnvMapComponent)
	placeable;

/** for visualizing the cube capture */
var const StaticMeshComponent StaticMesh;

/** material instance used to apply the target texture to the static mesh */
var transient MaterialInstanceConstant CubeMaterialInst;

/** Is this actor allowed to capture. Used to prevent capturing during building cutdown. */
var transient bool bAllowedToCapture;

var() editinline X2SceneCaptureEnvMapComponent EnvMapSceneCapture;

var editconst const DrawLightRadiusComponent EnvOuterRadiusComponent;
var editconst const DrawLightRadiusComponent EnvInnerRadiusComponent;

cpptext
{
	// SceneCaptureActor interface

	/** 
	* Update any components used by this actor
	*/
	virtual void SyncComponents();

	// AActor interface

	virtual void Spawned();

	// UObject interface

	virtual void FinishDestroy();
	virtual void PostLoad();

	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	virtual UBOOL PlayerControlled() {return GIsEditor && !GIsGame;}

	static void ResetAllCaptures();
	void ResetCapture();

private:

	/**
	* Init the helper components 
	*/
	virtual void Init();	
}

//Returns whether a successful registration happened
simulated native function bool RetryRegisterWithManager();

simulated event PreBeginPlay()
{
	TimerRetryRegistration();
}

function TimerRetryRegistration()
{
	if(!RetryRegisterWithManager())
	{
		SetTimer(0.1f, false, nameof(TimerRetryRegistration));
	}
}

defaultproperties
{
	Components.Remove(Sprite)

	Begin Object Class=DrawLightRadiusComponent Name=EnvMapRadius_Outer
		SphereRadius=256
	End Object
	Components.Add(EnvMapRadius_Outer)
	EnvOuterRadiusComponent=EnvMapRadius_Outer

	Begin Object Class=DrawLightRadiusComponent Name=EnvMapRadius_Inner
		SphereRadius=128
	End Object
	Components.Add(EnvMapRadius_Inner)
	EnvInnerRadiusComponent=EnvMapRadius_Inner

	// sphere for better viz
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0		
		HiddenGame=true
		CastShadow=false
		bAcceptsLights=false
		CollideActors=false
		Scale3D=(X=0.6,Y=0.6,Z=0.6)
		StaticMesh=StaticMesh'EditorMeshes.TexPropSphere'
	End Object
	StaticMesh=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	DrawScale=0.25

	bStatic=false
	bTickIsDisabled=true
	bAllowedToCapture=true
}
