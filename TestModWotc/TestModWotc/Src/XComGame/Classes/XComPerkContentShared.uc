//---------------------------------------------------------------------------------------
//  FILE:    XComPerkContentShared.uc
//  AUTHOR:  Russell Aasland  --  8/15/2016
//  PURPOSE: Common base for runtime perk effects data
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComPerkContentShared extends Actor
	native(Unit)
	dependson(XComPerkContent)
	notplaceable;

var privatewrite XComPerkContent m_PerkData;
var private name m_AssociatedAbility;			// for the case of reassociated multiplayer override versions

var protected XComUnitPawnNativeBase m_kPawn;
var protected XComUnitPawnNativeBase m_kCasterPawn;

var private AnimNotify_MITV m_CasterDamageMITV;
var private init array<ParticleSystemComponent> m_CasterOnDamageParticles; // active particle systems matching CasterOnDamageFX

simulated native function Init( XComPerkContent PerkData, XComUnitPawnNativeBase CasterPawn, optional XComUnitPawnNativeBase OverrideSourcePawn );

simulated function OnDamage( XComUnitPawnNativeBase Pawn )
{
	if (Pawn == m_kPawn)
	{
		StartCasterParticleFX( m_PerkData.CasterOnDamageFX, m_CasterOnDamageParticles );
		PlaySoundCue( Pawn, m_PerkData.CasterOnDamageSound );

		if (m_CasterDamageMITV != none)
		{
			m_CasterDamageMITV.ApplyMITV( m_kPawn );
		}
	}
}

simulated function OnMetaDamage( XComUnitPawnNativeBase Pawn );
simulated function OnPawnDeath();
simulated function RemovePerkTarget(XGUnit kUnit);

simulated protected native final function PlaySoundCue( Actor kPawn, SoundCue Sound );
simulated protected native final function StopSoundCue( Actor kPawn, SoundCue Sound );

simulated final function name GetAbilityName( )
{
	return m_AssociatedAbility;
}

simulated final function ReassociateToAbility( name AbilityName )
{
	m_AssociatedAbility = AbilityName;
}

protected static function EmitterInstanceParameterSet GetEmitterInstanceParametersForParticleContent(const out TParticleContent Content, XComUnitPawnNativeBase kPawn)
{
	local XComGameState_Unit UnitState;
	local XGUnit Unit;
	local EmitterInstanceParameterSet DefaultParameters;
	local int i;

	//  Try to find the character template that matches the pawn
	//  If instance parameters are defined with no associated character type, that is the default to fall back to
	if (Content.CharacterParameters.Length > 0)
	{
		Unit = XGUnit(kPawn.GetGameUnit());
		if (Unit != none)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Unit.ObjectID));
			if (UnitState != none)
			{
				for (i = 0; i < Content.CharacterParameters.Length; ++i)
				{
					if (Content.CharacterParameters[i].AssociatedCharacters.Length == 0)
					{
						DefaultParameters = Content.CharacterParameters[i].EmitterInstanceParameters;
						continue;
					}
					if (Content.CharacterParameters[i].AssociatedCharacters.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
					{
						return Content.CharacterParameters[i].EmitterInstanceParameters;
					}
				}
			}
		}
	}

	return DefaultParameters;
}

protected final function StartParticleSystem(XComUnitPawnNativeBase kPawn, TParticleContent Content, out ParticleSystemComponent kComponent, bool sync = false)
{
	local EmitterInstanceParameterSet ParameterSet;

	if (Content.FXTemplate != none)
	{
		if (kComponent != none)
		{
			if (kComponent.bIsActive)
			{
				kComponent.DeactivateSystem();
			}
		}
		else
		{
			kComponent = new(self) class'ParticleSystemComponent';
		}

		kComponent.SetTickGroup( TG_EffectsUpdateWork );

		ParameterSet = GetEmitterInstanceParametersForParticleContent(Content, kPawn);
		if (ParameterSet != none)
		{
			kComponent.InstanceParameters = ParameterSet.InstanceParameters;
		}		
		kComponent.SetTemplate(Content.FXTemplate);

		if (kPawn != none)
		{
			if (Content.SetActorParameter)
			{
				kComponent.SetActorParameter( Content.SetActorName, kPawn );
			}

			if ((Content.FXTemplateSocket != '') && (kPawn.Mesh.GetSocketByName( Content.FXTemplateSocket ) != none))
			{
				kPawn.Mesh.AttachComponentToSocket( kComponent, Content.FXTemplateSocket );
			}
			else if ((Content.FXTemplateBone != '') && (kPawn.Mesh.MatchRefBone( Content.FXTemplateBone ) != INDEX_None))
			{
				kPawn.Mesh.AttachComponent( kComponent, Content.FXTemplateBone );
			}
			else
			{
				if ((Content.FXTemplateSocket != '') || (Content.FXTemplateBone != ''))
				{
					`log("WARNING: could not find socket '" $ Content.FXTemplateSocket $ "' or bone '" $ Content.FXTemplateBone $ "' to attach particle component on" @ kPawn);
				}

				kPawn.AttachComponent( kComponent );
			}
		}
		else
		{
			self.AttachComponent( kComponent );
		}

		kComponent.OnSystemFinished = PerkFinished;
		kComponent.SetActive(true);

		if (sync)
		{
			kComponent.JumpForward( 5.0f );
		}
	}
}

simulated protected final function StartCasterParticleFX( const array<TParticleContent> FX, out array<ParticleSystemComponent> Particles, bool sync = false )
{
	local int i;
	local ParticleSystemComponent TempParticles;

	if (m_kPawn != none)
	{
		Particles.Length = FX.Length;
		for (i = 0; i < FX.Length; ++i)
		{
			if (FX[ i ].FXTemplate != none)
			{
				TempParticles = Particles[ i ];
				StartParticleSystem( m_kPawn, FX[ i ], TempParticles, sync );
				Particles[ i ] = TempParticles;
			}
		}
	}
}

simulated protected final function EndCasterParticleFX( const array<TParticleContent> FX, out array<ParticleSystemComponent> Particles )
{
	local int i;
	local XComGameState_Unit VisualizedUnit;
	local bool bVisualizedUnitIsDead;

	if (m_kPawn != none)
	{
		`assert(FX.Length == Particles.Length);
		VisualizedUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(m_kPawn.ObjectID));
		bVisualizedUnitIsDead = VisualizedUnit.IsDead();

		for (i = 0; i < Particles.Length; ++i)
		{
			if (Particles[ i ] != none && Particles[ i ].bIsActive)
			{
				Particles[ i ].DeactivateSystem(FX[i].ForceRemoveOnDeath && bVisualizedUnitIsDead);
			}
		}
	}
}

simulated function PerkFinished(ParticleSystemComponent PSystem)
{
	//`log("****" @ GetFuncName() @ "****" @ self @ PSystem);
	PSystem.DeactivateSystem();
}