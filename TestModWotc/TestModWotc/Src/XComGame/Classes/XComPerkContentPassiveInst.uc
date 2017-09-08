//---------------------------------------------------------------------------------------
//  FILE:    XComPerkContentPassiveInst.uc
//  AUTHOR:  Russell Aasland  --  8/8/2016
//  PURPOSE: Specialized instance of runtime data for perk content passive FX's
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComPerkContentPassiveInst extends XComPerkContentShared
	notplaceable;

var private init array<ParticleSystemComponent> m_PersistentParticles; // active particle systems matching PersistentCasterFX
var private init array<ParticleSystemComponent> m_PersistentEndParticles; // active particle systems matching EndPersistentCasterFX

static function bool PerkRequiresPassive( XComPerkContent Perk )
{
	local X2AbilityTemplate Ability;

	if (Perk.PersistentCasterFX.Length > 0)
		return true;

	if (Perk.CasterPersistentSound != none)
		return true;

	Ability = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(Perk.AssociatedAbility);
	if (Ability.bIsPassive && (Perk.CasterOnDamageFX.Length > 0))
		return true;

	return false;
}

simulated function StartPersistentFX( )
{
	local X2AbilityTemplate Ability;

	StartCasterParticleFX( m_PerkData.PersistentCasterFX, m_PersistentParticles );
	PlaySoundCue( m_kPawn, m_PerkData.CasterPersistentSound );

	Ability = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(m_PerkData.AssociatedAbility);
	if (Ability.bIsPassive && (m_PerkData.CasterOnDamageFX.Length > 0))
	{
		m_kPawn.arrTargetingPerkContent.AddItem( self );
	}
}

simulated function StopPersistentFX( )
{
	local X2AbilityTemplate Ability;

	EndCasterParticleFX( m_PerkData.PersistentCasterFX, m_PersistentParticles );
	StopSoundCue( m_kPawn, m_PerkData.CasterPersistentSound );

	Ability = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager( ).FindAbilityTemplate( m_PerkData.AssociatedAbility );
	if (Ability.bIsPassive && (m_PerkData.CasterOnDamageFX.Length > 0))
	{
		m_kPawn.arrTargetingPerkContent.RemoveItem( self );
	}
}

simulated function OnPawnDeath()
{
	if (m_PerkData.EndPersistentFXOnDeath)
	{
		StopPersistentFX();
		StartCasterParticleFX( m_PerkData.EndPersistentCasterFX, m_PersistentEndParticles );
		PlaySoundCue( m_kPawn, m_PerkData.CasterPersistentEndSound );
	}
}