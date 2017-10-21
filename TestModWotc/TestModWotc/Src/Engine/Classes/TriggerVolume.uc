/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class TriggerVolume extends Volume
	native
	placeable;

//  FIRAXIS BEGIN
var() const bool bWaterVolume<ToolTip="Units inside the volume will be in water.">;
var() const float fWaterZ;
var() const array<ParticleSystem> InWaterParticles;
//  FIRAXIS END

cpptext
{
#if WITH_EDITOR
	virtual void CheckForErrors();
#endif
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// match bProjTarget to weapons (zero extent) collision setting
	if (BrushComponent != None)
	{
		bProjTarget = BrushComponent.BlockZeroExtent;
	}
}

simulated function bool StopsProjectile(Projectile P)
{
	return false;
}

// FIRAXIS addition
simulated function LogDebugInfo()
{
 local Actor Touch;

 super.LogDebugInfo();

 foreach Touching(Touch)
 {
  `log( "Touching:"@Touch );
 }
}

defaultproperties
{
	bColored=true
	BrushColor=(R=100,G=255,B=100,A=255)

	bCollideActors=true
	bProjTarget=true
	SupportedEvents.Empty
	SupportedEvents(0)=class'SeqEvent_Touch'
	bTickIsDisabled=true
}
