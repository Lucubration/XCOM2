/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AnimNotify_PlayParticleEffect extends AnimNotify_WithPlayLimits
	native(Anim);

/** The Particle system to play **/
var(ParticleSystems) ParticleSystem PSTemplate;

/** If this effect should be considered extreme content **/
var() bool bIsExtremeContent;

/** If this is extreme content(bIsExtremeContent == TRUE), play this instead **/
var() ParticleSystem PSNonExtremeContentTemplate;

/** If this particle system should be attached to the location.**/
var() bool bAttach;

/** The socketname in which to play the particle effect.  Looks for a socket name first then bone name **/
var() name SocketName;

/** The bone name in which to play the particle effect. Looks for a socket name first then bone name **/
var() name BoneName;

/** If TRUE, the particle system will play in the viewer as well as in game */
var() editoronly bool bPreview;

/** If Owner is hidden, skip particle effect */
var() bool bSkipIfOwnerIsHidden;

/** Parameter name for the bone socket actor - SkelMeshActorParamName in the LocationBoneSocketModule.
  *  (Default value in module is 'BoneSocketActor')
  */
var() name BoneSocketModuleActorName;

/** FIRAXIS CHANGE: if TRUE, this particle system will not play if an 
 *  instance of it is already playing on the specified socket/bone **/
var() bool bOneInstanceOnly;
var() bool bRemoveOnPawnDeath;      //  remember the particle effect that was created and deactivate it if the owning XComUnitPawn dies

var() bool bIsWeaponEffect<ToolTip="For effects on weapons, a faster code path is taken if this is TRUE (checked in editor)">;

cpptext
{
	// AnimNotify interface.
	virtual void PostLoad();
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment();
	virtual FColor GetEditorColor() { return FColor(255,0,0); }
}

// Firaxis addition - script accessible method to trigger the notify
native function TriggerNotify(SkeletalMeshComponent SkelComponent);

defaultproperties
{
	bSkipIfOwnerIsHidden=TRUE
	BoneSocketModuleActorName="BoneSocketActor"
	bPreview = true
	bOneInstanceOnly = false
	bRemoveOnPawnDeath = false
}

