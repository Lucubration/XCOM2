//---------------------------------------------------------------------------------------
//  FILE:    XComPerkContent.uc
//  AUTHOR:  Russell Aasland  --  1/21/2015
//  PURPOSE: Ability related VFX & SFX data to play as part of visualization
//				Editor-side data configured by Content Creators to be used by the
//				XComPerkContentInst classes at runtime as abilities are used by
//				the player.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComPerkContent extends Object
	native(Unit)
	notplaceable;

struct PerkActivationData
{
	var int GameStateHistoryIndex;
	var array<XGUnit> TargetUnits;
	var array<StateObjectReference> TargetEffects;
	var array<vector> TargetLocations;
	var StateObjectReference ShooterEffect;
};

struct native TParticleContentParameters
{
	var() array<name> AssociatedCharacters<DynamicList = "AssociatedCharacterList">;
	var() EmitterInstanceParameterSet EmitterInstanceParameters;
};

struct native TParticleContent
{
	var() ParticleSystem FXTemplate;
	var() name FXTemplateSocket;
	var() name FXTemplateBone;
	var() float Delay;
	var() bool SetActorParameter;
	var() name SetActorName<EditCondition=SetActorParameter>;
	var() bool ForceRemoveOnDeath;
	var(InstanceParameters) array<TParticleContentParameters> CharacterParameters;
};

struct native TAnimContent
{
	var() bool PlayAnimation;
	var() name NoCoverAnim<EditCondition=PlayAnimation>;
	var() name HighCoverAnim<EditCondition=PlayAnimation>;
	var() name LowCoverAnim<EditCondition=PlayAnimation>;
	var() bool AdditiveAnim<EditCondition=PlayAnimation>;
};

var(General) privatewrite name AssociatedAbility<DynamicList = "AssociatedAbilityList">;
var(General) privatewrite name AssociatedEffect<DynamicList="AssociatedEffectList">;
var(General) privatewrite name AssociatedPassive<DynamicList="AssociatedPassiveList">;
var(General) privatewrite bool ExclusivePerk <ToolTip="Prevent other perks associated with this ability from triggering if this one triggers.">;
var(General) const array<AnimSet> AnimSetsToAlwaysApply<ToolTip="AnimSets that will always be applied to the owner of this perk.">;
var(General) const array<Object> AdditionalResources<ToolTip="Additional resources that need to be loaded for this perk.">;
var(General) privatewrite bool ActivatesWithAnimNotify<ToolTip="Activation for this perk should wait on an AnimNotify_PerkStart being hit.">;
var(General) privatewrite bool TargetEffectsOnProjectileImpact<ToolTip="Wait to trigger TargetActivation and TargetDuration effects until a projectile impact occurs.">;
var(General) privatewrite bool UseTargetPerkScale<ToolTip="Scale all target effects by the PerkScale factor of the target's pawn PerkScale member.">;
var(General) privatewrite bool IgnoreCasterAsTarget<ToolTip="If the caster is in the target list, do not give it the target FX.">;
var(General) privatewrite bool TargetDurationFXOnly<ToolTip="If true, this perk has duration FX but only for the Targets, not the Caster.">;
var(General) privatewrite bool CasterDurationFXOnly<ToolTip="If true, this perk has duration FX but only for the Caster, not the Targets.">;

var(CasterPersistent) array<TParticleContent> PersistentCasterFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(CasterPersistent) array<TParticleContent> EndPersistentCasterFX<EditCondition=EndPersistentFXOnDeath|ToolTip="Delay data is unused. End FX's will always start immediately.">;
var(CasterPersistent) bool EndPersistentFXOnDeath;
var(CasterPersistent) bool DisablePersistentFXDuringActivation;
var(CasterPersistent) SoundCue CasterPersistentSound;
var(CasterPersistent) SoundCue CasterPersistentEndSound<EditCondition=EndPersistentFXOnDeath>;

var(CasterActivation) array<TParticleContent> CasterActivationFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(CasterActivation) TAnimContent CasterActivationAnim;
var(CasterActivation) XComWeapon PerkSpecificWeapon;
var(CasterActivation) name WeaponTargetBone;
var(CasterActivation) name WeaponTargetSocket;
var(CasterActivation) editinline AnimNotify_MITV CasterActivationMITV;
var(CasterActivation) SoundCue CasterActivationSound;
var(CasterActivation) X2UnifiedProjectile CasterProjectile;

var(CasterDuration) array<TParticleContent> CasterDurationFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(CasterDuration) array<TParticleContent> CasterDurationEndedFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(CasterDuration) TAnimContent CasterDurationEndedAnim;
var(CasterDuration) editinline AnimNotify_MITV CasterDurationMITV;
var(CasterDuration) editinline AnimNotify_MITV CasterDurationEndMITV;
var(CasterDuration) SoundCue CasterDurationSound;
var(CasterDuration) SoundCue CasterDurationEndSound;
var(CasterDuration) bool ManualFireNotify;
var(CasterDuration) float FireVolleyDelay <EditCondition=ManualFireNotify>;
var(CasterDuration) editinline AnimNotify_FireWeaponVolley FireWeaponNotify <EditCondition=ManualFireNotify>;

var(CasterDeactivation) array<TParticleContent> CasterDeactivationFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(CasterDeactivation) SoundCue CasterDeactivationSound;
var(CasterDeactivation) bool ResetCasterActivationMTIVOnDeactivate;

var(CasterDamage) array<TParticleContent> CasterOnDamageFX<ToolTip="Delay data is unused. Damage FX's will always start immediately.">;
var(CasterDamage) bool OnCasterDeathPlayDamageFX;
var(CasterDamage) SoundCue CasterOnDamageSound;
var(CasterDamage) editinline AnimNotify_MITV CasterDamageMITV;
var(CasterDamage) array<TParticleContent> CasterOnMetaDamageFX<ToolTip="This damage FX plays once per volley, rather than with every projectile.">;

var(TargetActivation) array<TParticleContent> TargetActivationFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(TargetActivation) TAnimContent TargetActivationAnim;
var(TargetActivation) editinline AnimNotify_MITV TargetActivationMITV;
var(TargetActivation) SoundCue TargetActivationSound;
var(TargetActivation) SoundCue TargetLocationsActivationSound;

var(TargetDuration) array<TParticleContent> TargetDurationFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(TargetDuration) array<TParticleContent> TargetDurationEndedFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(TargetDuration) TAnimContent TargetDurationEndedAnim;
var(TargetDuration) editinline AnimNotify_MITV TargetDurationMITV;
var(TargetDuration) editinline AnimNotify_MITV TargetDurationEndMITV;
var(TargetDuration) SoundCue TargetDurationSound;
var(TargetDuration) SoundCue TargetDurationEndSound;
var(TargetDuration) SoundCue TargetLocationsDurationSound;
var(TargetDuration) SoundCue TargetLocationsDurationEndSound;

var(TargetDeactivation) array<TParticleContent> TargetDeactivationFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(TargetDeactivation) SoundCue TargetDeactivationSound;
var(TargetDeactivation) SoundCue TargetLocationsDeactivationSound;

var(TargetDamage) array<TParticleContent> TargetOnDamageFX<ToolTip="Delay data is unused. Damage FX's will always start immediately.">;
var(TargetDamage) bool OnTargetDeathPlayDamageFX;
var(TargetDamage) SoundCue TargetOnDamageSound;
var(TargetDamage) editinline AnimNotify_MITV TargetDamageMITV;

var(Tethers) array<TParticleContent> TetherStartupFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(Tethers) array<TParticleContent> TetherToTargetFX<ToolTip="Only the delay value for element 0 is used.  All effects will start at the same time as element 0.">;
var(Tethers) array<TParticleContent> TetherShutdownFX<ToolTip="Delay data is unused. Shutdown FX's will always start immediately">;
var(Tethers) name TargetAttachmentSocket;
var(Tethers) name TargetAttachmentBone;

cpptext
{
public:
	virtual void GetDynamicListValues(const FString& ListName, TArray<FString>& Values);
}

static function GetAssociatedPerkInstances( out array<XComPerkContentInst> ValidPerks, XComUnitPawnNativeBase Caster, const name ActivatingAbilityName, optional int HistoryIndex = -1 )
{
	local XComPerkContentInst PerkInst;
	local XComPerkContent Perk;

	foreach Caster.arrPawnPerkContent( PerkInst )
	{
		Perk = PerkInst.m_PerkData;

		// does the perk match the ability
		if (Perk.AssociatedAbility != ActivatingAbilityName)
		{
			continue;
		}

		// was the perk started by the specified history index?
		if ((HistoryIndex >= 0) && (PerkInst.m_GameStateHistoryIndex != HistoryIndex))
		{
			continue;
		}

		ValidPerks.AddItem( PerkInst );
	}
}

static function XComPerkContentInst GetAssociatedDurationPerkInstance( XComUnitPawnNativeBase Caster, XComGameState_Effect EffectState )
{
	local XComPerkContentInst PerkInst;
	local StateObjectReference TargetEffect;

	`assert( EffectState != none );

	foreach Caster.arrPawnPerkContent( PerkInst )
	{
		// is it the shooter effect?
		if ((PerkInst.m_ShooterEffect.ObjectID == EffectState.ObjectID) && !PerkInst.m_PerkData.TargetDurationFXOnly)
			return PerkInst;

		if (!PerkInst.m_PerkData.CasterDurationFXOnly)
		{
			// is it one of the target effects?
			foreach PerkInst.m_arrTargetEffects( TargetEffect )
			{
				if (TargetEffect.ObjectID == EffectState.ObjectID)
					return PerkInst;
			}
		}
	}

	return none;
}

static function GetAssociatedPerkDefinitions( out array<XComPerkContent> ValidPerks, XComUnitPawnNativeBase Caster, const name ActivatingAbilityName )
{
	local XComPerkContent Perk;

	foreach Caster.arrPawnPerkDefinitions( Perk )
	{
		// does the perk match the ability
		if (Perk.AssociatedAbility != ActivatingAbilityName)
		{
			continue;
		}

		ValidPerks.AddItem( Perk );
	}
}

static function XComPerkContent GetPerkDefinition( const name PerkName )
{
	local XComContentManager Content;
	local XComPerkContent PerkDef;
	
	Content = `CONTENT;

	foreach Content.PerkContent( PerkDef )
	{
		if (PerkDef.Name == PerkName)
			return PerkDef;
	}
}

static function XComPerkContentInst GetMatchingInstanceForPerk( XComUnitPawnNativeBase Caster, XComPerkContent PerkDef, optional int HistoryIndex = -1 )
{
	local XComPerkContentInst PerkInst;

	foreach Caster.arrPawnPerkContent( PerkInst )
	{
		// was the perk started by the specified history index?
		if ((HistoryIndex >= 0) && (PerkInst.m_GameStateHistoryIndex != HistoryIndex))
		{
			continue;
		}

		if (PerkInst.m_PerkData == PerkDef)
			return PerkInst;
	}

	return none;
}

static function name ChooseAnimationForCover(XGUnit kUnit, TAnimContent AnimContent)
{
	return class'XComIdleAnimationStateMachine'.static.ChooseAnimationForCover( kUnit, AnimContent.NoCoverAnim, AnimContent.LowCoverAnim, AnimContent.HighCoverAnim );
}

static function ResetActivationData( out PerkActivationData Data )
{
	Data.ShooterEffect.ObjectID = 0;
	Data.TargetUnits.Length = 0;
	Data.TargetEffects.Length = 0;
	Data.TargetLocations.Length = 0;
}

simulated function AddAnimSetsToPawn(XComUnitPawnNativeBase kPawn)
{
	local AnimSet kAnimSet;

	if (kPawn != none && kPawn.Mesh != none)
	{
		foreach AnimSetsToAlwaysApply(kAnimSet)
		{
			if (kPawn.Mesh.AnimSets.Find(kAnimSet) == -1)
			{
				kPawn.Mesh.AnimSets.AddItem(kAnimSet);
			}
		}
	}
}