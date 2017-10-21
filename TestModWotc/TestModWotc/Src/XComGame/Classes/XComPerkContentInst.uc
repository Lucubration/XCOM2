//---------------------------------------------------------------------------------------
//  FILE:    XComPerkContentInst.uc
//  AUTHOR:  Russell Aasland  --  8/8/2016
//  PURPOSE: Runtime implementation of asset instance management of VFX & SFX played
//				during ability activation based on data from XComPerkContent
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComPerkContentInst extends XComPerkContentShared
	dependson(XGUnitNativeBase)
	native(Unit)
	notplaceable;

// just need a 2D Array and unreal script won't do that directly
struct native TTargetParticles
{
	var init array< ParticleSystemComponent > Particles;
};

var private init array<ParticleSystemComponent> m_CasterActivationParticles; // active particle systems matching CasterActivationFX
var private init array<ParticleSystemComponent> m_CasterDurationParticles; // active particle systems matching CasterDurationFX
var private init array<ParticleSystemComponent> m_CasterDurationEndedParticles; // active particle systems matching CasterDurationEndedFX
var private init array<ParticleSystemComponent> m_CasterDeactivationParticles; // active particle systems matching CasterDeactivationFX
var private init array<ParticleSystemComponent> m_CasterOnMetaDamageParticles; // active particle systems matching CasterOnMetaDamageFX

var private init array< TTargetParticles > m_TargetActivationParticles; // active particle systems matching TargetActivationFX
var private init array< TTargetParticles > m_TargetDurationParticles; // active particle systems matching TargetDurationFX
var private init array< TTargetParticles > m_TargetDurationEndedParticles; // active particle systems matching TargetDurationEndedFX
var private init array< TTargetParticles > m_TargetDeactivationParticles; // active particle systems matching TargetDeactivationFX
var private init array< TTargetParticles > m_TargetOnDamageParticles; // active particle systems matching TargetOnDamageFX

	// instanced MITVs because Unreal timers suck a bit
var private init array< AnimNotify_MITV > m_TargetActivationMITVs;
var private init array< AnimNotify_MITV > m_TargetDurationMITVs;
var private init array< AnimNotify_MITV > m_TargetDurationEndMITVs;
var private init array< AnimNotify_MITV > m_TargetDamagedMITVs;

var private init array< TTargetParticles > m_TetherParticles; // active particle systems matching TetherToTargetFX
var private init array< DynamicPointInSpace > m_TetherAttachmentActors;

var private init array< DynamicPointInSpace > m_LocationActivationSounds;
var private init array< DynamicPointInSpace > m_LocationDeactivationSounds;
var private init array< DynamicPointInSpace > m_LocationDurationSounds;
var private init array< DynamicPointInSpace > m_LocationDurationEndSounds;

var privatewrite init array<XGUnit> m_arrTargets;
var privatewrite init array<XComUnitPawnNativeBase> m_arrTargetPawns;
var privatewrite init array<StateObjectReference> m_arrTargetEffects;
var privatewrite init array<vector> m_arrTargetLocations;

var privatewrite int m_ActiveTargetCount;
var privatewrite int m_ActiveLocationCount;
var privatewrite StateObjectReference m_ShooterEffect;
var privatewrite int m_GameStateHistoryIndex;

var private XComWeapon m_kWeapon;
var private bool m_RecievedImpactEvent;

var AnimNotify_FireWeaponVolley m_FireWeaponNotify;
var AnimNotify_MITV m_CasterActivationMITV;
var AnimNotify_MITV m_CasterDurationMITV;
var AnimNotify_MITV m_CasterDurationEndMITV;

var bool bPauseTethers;
var bool bDeactivationIdleNotDestroy;
var bool bPersistOnCasterDeath;

simulated native function Init( XComPerkContent PerkData, XComUnitPawnNativeBase Pawn, optional XComUnitPawnNativeBase OverrideSourcePawn );

simulated protected native function PrepTargetMITVs( out array< AnimNotify_MITV >  TargetMITVs, AnimNotify_MITV SourceMITV );
simulated protected native function AddTargetMITV( out array< AnimNotify_MITV > TargetMITVs, AnimNotify_MITV SourceMITV );
simulated protected native function bool PrepTargetDamagedMITV( int TargetIndex );

simulated protected function StopPersistentFX( ) // find any passives for the same perk and stop them
{
	local XComPerkContentPassiveInst PerkPassive;

	foreach m_kPawn.arrPawnPerkPassives( PerkPassive )
	{
		if (PerkPassive.m_PerkData == m_PerkData)
			PerkPassive.StopPersistentFX( );
	}
}

simulated protected function StartPersistentFX( ) // find any passives for the same perk and start them
{
	local XComPerkContentPassiveInst PerkPassive;

	foreach m_kPawn.arrPawnPerkPassives( PerkPassive )
	{
		if (PerkPassive.m_PerkData == m_PerkData)
			PerkPassive.StartPersistentFX( );
	}
}

simulated protected function array< ParticleSystemComponent > AppendArray( array< ParticleSystemComponent > DestParticles, array< ParticleSystemComponent > SrcParticles  )
{
	local ParticleSystemComponent System;

	foreach SrcParticles( System )
	{
		DestParticles.AddItem( System );
	}

	return DestParticles;
}

simulated protected function PlayTargetsSoundCues( SoundCue Sound, array<XComUnitPawnNativeBase> Pawns )
{
	local XComUnitPawnNativeBase Target;

	foreach Pawns( Target )
	{
		PlaySoundCue( Target, Sound );
	}
}

simulated protected function StopTargetsSoundCues( SoundCue Sound, array<XComUnitPawnNativeBase> Pawns )
{
	local XComUnitPawnNativeBase Target;

	foreach Pawns( Target )
	{
		StopSoundCue( Target, Sound );
	}
}

simulated protected function PlayTargetLocationSoundCue( SoundCue Sound, array<vector> Locations, out array< DynamicPointInSpace > LocationActors )
{
	local vector Loc;
	local DynamicPointInSpace DummyActor;

	if (Sound == none)
	{
		return;
	}

	foreach Locations(Loc)
	{
		DummyActor = Spawn( class'DynamicPointInSpace', self );
		DummyActor.SetLocation( Loc );
		PlaySoundCue( DummyActor, Sound );

		LocationActors.AddItem( DummyActor );
	}
}

simulated protected function StopTargetLocationSoundCue( out array< DynamicPointInSpace > LocationActors )
{
	local DynamicPointInSpace Dummy;

	foreach LocationActors( Dummy )
	{
		Dummy.Destroy();
	}
	LocationActors.Length = 0;
}

simulated function StartTargetParticleSystem(XComUnitPawnNativeBase kPawn, TParticleContent Content, out ParticleSystemComponent kComponent, bool sync = false)
{
	StartParticleSystem(kPawn, Content, kComponent, sync);

	if (m_PerkData.UseTargetPerkScale && XComUnitPawn(kPawn).PerkEffectScale != 1.0)
	{
		kComponent.SetScale( XComUnitPawn(kPawn).PerkEffectScale );
	}
}

simulated function OnPawnDeath()
{
	if (!bPersistOnCasterDeath)
		GotoState( 'PendingDestroy' );
}

simulated function XComWeapon GetPerkWeapon()
{
	if (m_kWeapon == none && m_PerkData.PerkSpecificWeapon != none)
	{
		m_kWeapon = Spawn(class'XComWeapon',m_kPawn,,,,m_PerkData.PerkSpecificWeapon);
		m_kWeapon.m_kPawn = m_kPawn;
		m_kPawn.Mesh.AttachComponentToSocket( m_kWeapon.Mesh, m_kWeapon.DefaultSocket );
	}

	return m_kWeapon;
}

simulated function AddPerkTarget(XGUnit kUnit, XComGameState_Effect PersistentEffect, bool sync = false)
{
	local int i, x;
	local bool bFound;
	local ParticleSystemComponent TempParticles;
	local array<ParticleSystemComponent> NewParticles;
	local TParticleContent Content;

	if (m_PerkData.IgnoreCasterAsTarget && (kUnit == m_kCasterPawn.m_kGameUnit))
		return;

	if (m_arrTargets.Find(kUnit) == -1)
	{
		//  look for an empty space to replace if possible
		for (i = 0; i < m_arrTargets.Length; ++i)
		{
			if (m_arrTargets[i] == none)
			{
				bFound = true;
				break;
			}
		}
		//  add to the end if no empty space was found
		if (!bFound)
		{
			m_TargetActivationParticles.Add(1);
			m_TargetDeactivationParticles.Add(1);
			m_TargetDurationParticles.Add(1);
			m_arrTargets.Add(1);
			m_arrTargetPawns.Add(1);
			m_arrTargetEffects.Add(1);
			m_TetherAttachmentActors.Add(1);
			m_TetherParticles.Add(1);
			AddTargetMITV( m_TargetDurationMITVs, m_PerkData.TargetDurationMITV );
			AddTargetMITV( m_TargetDurationEndMITVs, m_PerkData.TargetDurationEndMITV );
		}

		m_arrTargets[i] = kUnit;
		m_arrTargetPawns[i] = kUnit.GetPawn();
		m_arrTargetEffects[i].ObjectID = PersistentEffect != none ? PersistentEffect.ObjectID : 0;
		++m_ActiveTargetCount;

		if (IsInState( 'DurationActive' ))
		{
			if (sync == false)
			{
				m_TargetActivationParticles[i].Particles.Length = m_PerkData.TargetActivationFX.Length;
				for (x = 0; x < m_PerkData.TargetActivationFX.Length; ++x)
				{
					Content = m_PerkData.TargetActivationFX[ x ];

					if ((Content.FXTemplate != none) && (Content.FXTemplateBone != '' || Content.FXTemplateSocket != ''))
					{
						TempParticles = m_TargetActivationParticles[ i ].Particles[ x ];
						StartTargetParticleSystem( m_arrTargetPawns[ i ], Content, TempParticles );
						m_TargetActivationParticles[ i ].Particles[ x ] = TempParticles;
					}
				}
				PlaySoundCue( m_arrTargetPawns[ i ], m_PerkData.TargetActivationSound );
			}

			m_TargetDurationParticles[i].Particles.Length = m_PerkData.TargetDurationFX.Length;
			for (x = 0; x < m_PerkData.TargetDurationFX.Length; ++x)
			{
				Content = m_PerkData.TargetDurationFX[ x ];

				if ((Content.FXTemplate != none) && (Content.FXTemplateBone != '' || Content.FXTemplateSocket != ''))
				{
					TempParticles = m_TargetDurationParticles[ i ].Particles[ x ];
					StartTargetParticleSystem( m_arrTargetPawns[ i ], Content, TempParticles, sync );
					m_TargetDurationParticles[ i ].Particles[ x ] = TempParticles;
				}
			}
			PlaySoundCue( m_arrTargetPawns[ i ], m_PerkData.TargetDurationSound );

			if (m_PerkData.TetherToTargetFX.Length != 0)
			{
				m_TetherAttachmentActors[i] = Spawn( class'DynamicPointInSpace', self );
				UpdateAttachmentLocations( );

				StartCasterParticleFX( m_PerkData.TetherToTargetFX, NewParticles );

				m_TetherParticles[ i ].Particles = AppendArray( m_TetherParticles[ i ].Particles, NewParticles );

				UpdateTetherParticleParams( );
			}

			if (m_PerkData.TargetDurationMITV != none)
			{
				m_TargetDurationMITVs[ i ].ApplyMITV( m_arrTargetPawns[ i ] );
			}

			m_arrTargetPawns[ i ].arrTargetingPerkContent.AddItem( self );
		}
	}
}

simulated function RemovePerkTarget(XGUnit kUnit)
{
	local int i, x;
	local ParticleSystemComponent TempParticles;
	local ParticleSystemComponent ParticleSystem;
	local TParticleContent Content;
	local array<ParticleSystemComponent> NewShutdownParticles;
	local XComGameState_Unit VisualizedUnit;
	local bool bVisualizedUnitIsDead;

	// not sure how this can happen
	//	crash from v 299394 using volt
	//	crashing is PlaySoundCue...
	if (kUnit == None)
		return;

	i = m_arrTargets.Find(kUnit);
	if (i != -1)
	{

		// double safety for above check in here
		//	nullptr is clearly being passed to the PlaySoundCue as a target...
		if (m_arrTargets[i] == None || m_arrTargetPawns[i] == None)
		{
			m_arrTargets[i] = None;
			m_arrTargetPawns[i] = None;
			m_arrTargetEffects[i].ObjectID = 0;
			return;
		}

		VisualizedUnit = kUnit.GetVisualizedGameState();
		bVisualizedUnitIsDead = VisualizedUnit.IsDead();
		if (IsInState( 'DurationActive' ))
		{
			if ( i >= m_TargetDurationEndedParticles.Length )
				m_TargetDurationEndedParticles.Length = i + 1;

			m_TargetDurationEndedParticles[ i ].Particles.Length = m_PerkData.TargetDurationEndedFX.Length;
			for (x = 0; x < m_PerkData.TargetDurationEndedFX.Length; ++x)
			{
				Content = m_PerkData.TargetDurationEndedFX[ x ];

				if ((Content.FXTemplate != none) && (Content.FXTemplateBone != '' || Content.FXTemplateSocket != ''))
				{
					TempParticles = m_TargetDurationEndedParticles[ i ].Particles[ x ];
					StartParticleSystem( m_arrTargetPawns[ i ], Content, TempParticles );
					m_TargetDurationEndedParticles[ i ].Particles[ x ] = TempParticles;
				}
			}
			PlaySoundCue( m_arrTargetPawns[ i ], m_PerkData.TargetDurationEndSound );

			`assert(m_PerkData.TargetDurationFX.Length == m_TargetDurationParticles[i].Particles.Length);
			for (x = 0; x < m_TargetDurationParticles[i].Particles.Length; ++x)
			{
				if (m_TargetDurationParticles[i].Particles[x] != none && m_TargetDurationParticles[i].Particles[x].bIsActive)
					m_TargetDurationParticles[i].Particles[x].DeactivateSystem(m_PerkData.TargetDurationFX[x].ForceRemoveOnDeath && bVisualizedUnitIsDead);
			}

			m_arrTargetPawns[ i ].arrTargetingPerkContent.RemoveItem( self );
			StopSoundCue( m_arrTargetPawns[ i ], m_PerkData.TargetDurationSound );

			if (m_TargetDurationMITVs[i] != none)
			{
				if (m_TargetDurationMITVs[i].bApplyFullUnitMaterial)
				{
					m_arrTargetPawns[ i ].CleanUpMITV( );
				}
				else
				{
					m_TargetDurationMITVs[i].ResetPawnName = m_arrTargetPawns[ i ].Name;
					m_TargetDurationMITVs[i].ResetMaterial( );
				}
				m_TargetDurationMITVs[i] = none;
			}

			if (m_TargetDurationEndMITVs[i] != none)
			{
				m_TargetDurationEndMITVs[i].ApplyMITV( m_arrTargetPawns[ i ] );
			}

			if (m_PerkData.TetherToTargetFX.Length != 0)
			{
				foreach m_TetherParticles[i].Particles( ParticleSystem )
				{
					if (ParticleSystem != none)
					{
						ParticleSystem.DeactivateSystem( );
					}
				}

				StartCasterParticleFX( m_PerkData.TetherShutdownFX, NewShutdownParticles );
				m_TetherParticles[i].Particles = AppendArray( m_TetherParticles[i].Particles, NewShutdownParticles );

				UpdateTetherParticleParams( );

				m_TetherAttachmentActors[i].Destroy( );
			}
			else if (IsInState( 'ActionActive' ))
			{
				m_TargetDeactivationParticles[ i ].Particles.Length = m_PerkData.TargetDeactivationFX.Length;
				for (x = 0; x < m_PerkData.TargetDeactivationFX.Length; ++x)
				{
					Content = m_PerkData.TargetDeactivationFX[ x ];

					if ((Content.FXTemplate != none) && (Content.FXTemplateBone != '' || Content.FXTemplateSocket != ''))
					{
						TempParticles = m_TargetDeactivationParticles[ i ].Particles[ x ];
						StartParticleSystem( m_arrTargetPawns[ i ], Content, TempParticles );
						m_TargetDeactivationParticles[ i ].Particles[ x ] = TempParticles;
					}
				}
				PlaySoundCue( m_arrTargetPawns[ i ], m_PerkData.TargetDeactivationSound );
			}
		}

		//  Do NOT remove from the array to keep the particle array in sync with the other targets
		m_arrTargets[i] = none;
		m_arrTargetPawns[i] = none;
		m_arrTargetEffects[i].ObjectID = 0;
		--m_ActiveTargetCount;

		if (IsInState( 'DurationActive' ) && (m_ActiveTargetCount == 0) && (m_ActiveLocationCount == 0))
		{
			OnPerkDurationEnd( );
		}
	}
}

simulated function ReplacePerkTarget( XGUnit oldUnitTarget, XGUnit newUnitTarget, XComGameState_Effect PersistentEffect )
{
	local int i, x;
	local TParticleContent Content;
	local ParticleSystemComponent TempParticles;

	i = m_arrTargets.Find( oldUnitTarget );
	if (i != -1)
	{
		m_arrTargetPawns[ i ].arrTargetingPerkContent.RemoveItem( self );
		StopSoundCue( m_arrTargetPawns[ i ], m_PerkData.TargetDurationSound );

		m_arrTargets[ i ] = newUnitTarget;
		m_arrTargetEffects[ i ].ObjectID = PersistentEffect != none ? PersistentEffect.ObjectID : 0;
		m_arrTargetPawns[ i ] = newUnitTarget.GetPawn();
		m_arrTargetPawns[ i ].arrTargetingPerkContent.AddItem( self );

		//We may not have gotten a chance to start the particles "normally". Make sure there's room in the array.
		//(Otherwise, UnrealScript will happily plow through the None access, losing the reference to the particles.)
		if (i >= m_TargetDurationParticles.Length)
			m_TargetDurationParticles.Length = i + 1;

		m_TargetDurationParticles[ i ].Particles.Length = m_PerkData.TargetDurationFX.Length;
		for (x = 0; x < m_PerkData.TargetDurationFX.Length; ++x)
		{
			Content = m_PerkData.TargetDurationFX[ x ];

			if ((Content.FXTemplate != none) && (Content.FXTemplateBone != '' || Content.FXTemplateSocket != ''))
			{
				TempParticles = m_TargetDurationParticles[ i ].Particles[ x ];
				StartTargetParticleSystem( m_arrTargetPawns[ i ], Content, TempParticles );
				m_TargetDurationParticles[ i ].Particles[ x ] = TempParticles;
			}
		}
		PlaySoundCue( m_arrTargetPawns[ i ], m_PerkData.TargetDurationSound );

		if (m_PerkData.TetherToTargetFX.Length != 0)
		{
			UpdateAttachmentLocations( );
			UpdateTetherParticleParams( );
		}
	}
	else
	{
		AddPerkTarget( newUnitTarget, PersistentEffect );
	}
}

simulated function OnPerkLoad( PerkActivationData ActivationData )
{
	`assert( false ); //Definitely shouldn't make it here!
}

simulated function OnPerkActivation( PerkActivationData ActivationData )
{
	`assert( false ); // Shouldn't make it here!
}

simulated function OnPerkDeactivation( )
{
	`assert( false ); // Shouldn't make it here!
}

simulated function OnPerkDurationEnd()
{
	`assert( false ); // Shouldn't make it here!
}

simulated protected function OnTargetDamaged(XComUnitPawnNativeBase Pawn)
{
	local int i, x;
	local ParticleSystemComponent TempParticles;

	i = m_arrTargetPawns.Find( Pawn );
	if (i != -1)
	{
		if (m_PerkData.TargetOnDamageFX.Length > 0)
		{
			// make sure that the targets array has that index available
			if (i >= m_TargetOnDamageParticles.Length)
			{
				m_TargetOnDamageParticles.Length = i + 1;
			}

			// play all the appropriate effects on that particular target
			m_TargetOnDamageParticles[ i ].Particles.Length = m_PerkData.TargetOnDamageFX.Length;
			for (x = 0; x < m_PerkData.TargetOnDamageFX.Length; ++x)
			{
				if (m_PerkData.TargetOnDamageFX[ x ].FXTemplate != none)
				{
					TempParticles = m_TargetOnDamageParticles[ i ].Particles[ x ];
					StartParticleSystem( Pawn, m_PerkData.TargetOnDamageFX[ x ], TempParticles );
					m_TargetOnDamageParticles[ i ].Particles[ x ] = TempParticles;
				}
			}

			PlaySoundCue( Pawn, m_PerkData.TargetOnDamageSound );
		}

		if (m_PerkData.TargetDamageMITV != none)
		{
			if (PrepTargetDamagedMITV(i))
			{
				m_TargetDamagedMITVs[i].ApplyMITV( Pawn );
			}
		}
	}
}

simulated function OnDamage( XComUnitPawnNativeBase Pawn )
{
	Super.OnDamage( Pawn );

	if (Pawn != m_kPawn)
	{
		OnTargetDamaged( Pawn );
	}
}

simulated function OnMetaDamage( XComUnitPawnNativeBase Pawn )
{
	if (Pawn == m_kPawn)
	{
		DoCasterParticleFXOnMetaDamage();
	}
}

simulated protected function StartTargetsParticleFX( const array<TParticleContent> FX, out array< TTargetParticles > Particles, bool sync = false )
{
	local int t, i, x;
	local ParticleSystemComponent TempParticles;
	local TParticleContent Content;

	Particles.Length = m_arrTargetPawns.Length + m_arrTargetLocations.Length;
	for (t = 0; t < Particles.Length; ++t)
	{
		Particles[ t ].Particles.Length = FX.Length;
	}

	for (i = 0; i < FX.Length; ++i)
	{
		Content = FX[ i ];
		if (Content.FXTemplate != none)
		{
			if ((Content.FXTemplateBone != '') || (Content.FXTemplateSocket != ''))
			{
				for (t = 0; t < m_arrTargetPawns.Length; ++t)
				{
					if (m_arrTargetPawns[ t ] != none)
					{
						TempParticles = Particles[ t ].Particles[ i ];
						StartTargetParticleSystem( m_arrTargetPawns[ t ], Content, TempParticles, sync );
						Particles[ t ].Particles[ i ] = TempParticles;
					}
				}
			}
			else
			{
				for (t = 0; t < m_arrTargetLocations.Length; ++t)
				{
					x = m_arrTargetPawns.Length + t;

					TempParticles = Particles[ x ].Particles[ i ];

					StartParticleSystem( none, Content, TempParticles, sync );
					TempParticles.SetAbsolute( true, true, true );
					TempParticles.SetTranslation( m_arrTargetLocations[ t ] );

					Particles[ x ].Particles[ i ] = TempParticles;
				}
				m_ActiveLocationCount = m_arrTargetLocations.Length;
			}
		}
	}
}

simulated protected function EndTargetsParticleFX( out array< TTargetParticles > TargetParticles )
{
	local int t, i;

	for (t = 0; t < TargetParticles.Length; ++t)
	{
		for (i = 0; i < TargetParticles[t].Particles.Length; ++i)
		{
			if (TargetParticles[t].Particles[i] != none && TargetParticles[t].Particles[i].bIsActive)
			{
				TargetParticles[t].Particles[i].DeactivateSystem( );
			}
		}
	}
}

simulated protected function DoCasterActivationParticleFX()
{
	StartCasterParticleFX( m_PerkData.CasterActivationFX, m_CasterActivationParticles );
}

simulated protected function StopCasterActivationParticleFX()
{
	EndCasterParticleFX( m_PerkData.CasterActivationFX, m_CasterActivationParticles );
}

simulated protected function DoCasterParticleFXForDuration()
{
	StartCasterParticleFX( m_PerkData.CasterDurationFX, m_CasterDurationParticles );
}

simulated protected function DoTargetActivationParticleFX( )
{
	StartTargetsParticleFX( m_PerkData.TargetActivationFX, m_TargetActivationParticles );
}

simulated protected function StopTargetActivationParticleFX( )
{
	EndTargetsParticleFX( m_TargetActivationParticles );
}

simulated protected function DoCasterParticleFXOnMetaDamage()
{
	StartCasterParticleFX( m_PerkData.CasterOnMetaDamageFX, m_CasterOnMetaDamageParticles );
}

simulated protected function DoTargetParticleFXForDuration()
{
	StartTargetsParticleFX( m_PerkData.TargetDurationFX, m_TargetDurationParticles );
}

simulated protected function DoCasterDurationParticleFX( )
{
	StartCasterParticleFX( m_PerkData.CasterDurationFX, m_CasterDurationParticles );
}

simulated protected function DoTargetDurationParticleFX( )
{
	StartTargetsParticleFX( m_PerkData.TargetDurationFX, m_TargetDurationParticles );
}

simulated protected function DoCasterDurationEndedParticleFX()
{
	StartCasterParticleFX( m_PerkData.CasterDurationEndedFX, m_CasterDurationEndedParticles );
}

simulated protected function DoTargetDurationEndedParticleFX()
{
	StartTargetsParticleFX( m_PerkData.TargetDurationEndedFX, m_TargetDurationEndedParticles );
}

simulated protected function DoCasterDeactivationParticleFX( )
{
	StartCasterParticleFX( m_PerkData.CasterDeactivationFX, m_CasterDeactivationParticles );
}

simulated protected function DoTargetDeactivationParticleFX( )
{
	StartTargetsParticleFX( m_PerkData.TargetDeactivationFX, m_TargetDeactivationParticles );
}

simulated protected function DoTetherStartupParticleFX( )
{
	local array<ParticleSystemComponent> NewParticles;
	local int x;

	for (x = 0; x < m_arrTargetPawns.Length; ++x)
	{
		StartCasterParticleFX( m_PerkData.TetherStartupFX, NewParticles );

		m_TetherParticles[ x ].Particles = AppendArray( m_TetherParticles[ x ].Particles, NewParticles );
		NewParticles.Length = 0;
	}
}

simulated protected function DoTetherParticleFX( bool sync = false )
{
	local array<ParticleSystemComponent> NewParticles;
	local int x, y;

	for (x = 0; x < m_arrTargetPawns.Length; ++x)
	{
		StartCasterParticleFX( m_PerkData.TetherToTargetFX, NewParticles, sync );

		for (y = 0; y < NewParticles.Length; ++y)
		{
			NewParticles[ y ].SetIgnoreOwnerHidden( true ); // we still want to see the tether even if the source goes into the fog and becomes hidden.
			m_TetherParticles[ x ].Particles.AddItem( NewParticles[ y ] );

		}

		NewParticles.Length = 0;
	}
}

simulated protected function DoTetherParticleFXWrapper( )
{
	DoTetherParticleFX( );
}

simulated protected function DoTetherShutdownParticleFX( )
{
	local array<ParticleSystemComponent> NewParticles;
	local int x;

	for (x = 0; x < m_arrTargetPawns.Length; ++x)
	{
		StartCasterParticleFX( m_PerkData.TetherShutdownFX, NewParticles );

		m_TetherParticles[ x ].Particles = AppendArray( m_TetherParticles[ x ].Particles, NewParticles );
		NewParticles.Length = 0;
	}
}

simulated protected function DoManualFireVolley( )
{
	m_FireWeaponNotify.bPerkVolley = true;
	m_FireWeaponNotify.PerkAbilityName = string(m_PerkData.AssociatedAbility);

	m_FireWeaponNotify.NotifyUnit( m_kPawn );
}

simulated protected function UpdateAttachmentLocations( )
{
	local int x;
	local XComUnitPawnNativeBase TargetPawn;
	local DynamicPointInSpace TetherAttachment;
	local Vector AttachLocation;

	if (bPauseTethers)
	{
		return;
	}

	for (x = 0; x < m_arrTargetPawns.Length; ++x)
	{
		TargetPawn = m_arrTargetPawns[x];
		TetherAttachment = m_TetherAttachmentActors[x];

		if ((TargetPawn == none) || (TetherAttachment == none))
		{
			continue;
		}

		if (m_PerkData.TargetAttachmentSocket != '')
		{
			TargetPawn.Mesh.GetSocketWorldLocationAndRotation( m_PerkData.TargetAttachmentSocket, AttachLocation );
		}
		else if (m_PerkData.TargetAttachmentBone != '')
		{
			AttachLocation = TargetPawn.Mesh.GetBoneLocation( m_PerkData.TargetAttachmentBone );
		}
		else
		{
			AttachLocation = TargetPawn.Location;
		}

		TetherAttachment.SetLocation( AttachLocation );
	}
}

simulated protected function StopExistingTetherFX( )
{
	local TTargetParticles TargetParticles;
	local ParticleSystemComponent ParticleSystem;

	foreach m_TetherParticles( TargetParticles )
	{
		foreach TargetParticles.Particles( ParticleSystem )
		{
			if (ParticleSystem != none)
			{
				ParticleSystem.DeactivateSystem( );
			}
		}
	}
}

simulated protected function UpdateTetherParticleParams( )
{
	local int x, y;
	local XComUnitPawnNativeBase TargetPawn;
	local DynamicPointInSpace TetherAttachment;
	local ParticleSystemComponent ParticleSystem;
	local TTargetParticles TargetParticles;

	local Vector ParticleSystemLocation;
	local Vector ParticleParameterDistance;
	local float Distance;

	for (x = 0; x < m_arrTargetPawns.Length; ++x)
	{
		TargetPawn = m_arrTargetPawns[ x ];
		TetherAttachment = m_TetherAttachmentActors[ x ];

		if ((TargetPawn == none) || (TetherAttachment == none))
		{
			continue;
		}

		TargetParticles = m_TetherParticles[ x ];

		for (y = 0; y < TargetParticles.Particles.Length; ++y)
		{
			ParticleSystem = TargetParticles.Particles[ y ];
			if (ParticleSystem == none)
			{
				continue;
			}

			ParticleSystemLocation = ParticleSystem.GetPosition( );
			ParticleParameterDistance = TetherAttachment.Location - ParticleSystemLocation;
			Distance = VSize( ParticleParameterDistance );

			ParticleSystem.SetAbsolute( false, true, false );
			ParticleSystem.SetRotation( rotator( Normal( ParticleParameterDistance ) ) );

			ParticleParameterDistance.X = Distance;
			ParticleParameterDistance.Y = Distance;
			ParticleParameterDistance.Z = Distance;

			ParticleSystem.SetVectorParameter( 'Distance', ParticleParameterDistance );
			ParticleSystem.SetFloatParameter( 'Distance', Distance );
		}
	}
}

simulated event Tick( float fDeltaT )
{
	if (((m_PerkData.TetherToTargetFX.Length != 0) ||
		 (m_PerkData.TetherStartupFX.Length != 0)) && !IsInState('Idle'))
	{
		UpdateAttachmentLocations( );

		UpdateTetherParticleParams( );
	}
}

simulated function TriggerImpact( )
{
}

delegate DoEffectDelegate( );
simulated protected native function SetDelegateTimer( float delay, delegate<DoEffectDelegate> EffectFunction );

simulated protected function TimerDoEffects( const array<TParticleContent> FX, delegate<DoEffectDelegate> EffectFunction )
{
	if (FX.Length > 0)
	{
		if (FX[0].Delay > 0)
		{
			SetDelegateTimer( FX[0].Delay, EffectFunction );
		}
		else
		{
			EffectFunction( );
		}
	}
}

auto simulated state Idle
{
	simulated function PerkStart( PerkActivationData ActivationData )
	{
		local XGUnit TargetUnit;
		local XComGameState_Effect EffectState;
		local X2Effect_Persistent EffectTemplate;

		`assert( (ActivationData.TargetUnits.Length == ActivationData.TargetEffects.Length) || (ActivationData.TargetEffects.Length == 0));

		m_kCasterPawn.arrPawnPerkContent.AddItem( self );

		m_arrTargets = ActivationData.TargetUnits;
		m_arrTargetLocations = ActivationData.TargetLocations;
		m_GameStateHistoryIndex = ActivationData.GameStateHistoryIndex;

		m_arrTargetEffects = ActivationData.TargetEffects;
		m_ShooterEffect = ActivationData.ShooterEffect;

		m_arrTargetEffects.Length = m_arrTargets.Length;

		m_arrTargetPawns.Length = 0;
		foreach m_arrTargets( TargetUnit )
		{
			if (TargetUnit != none)
			{
				m_arrTargetPawns.AddItem( TargetUnit.GetPawn( ) );
			}
		}
		m_ActiveTargetCount = m_arrTargets.Length;
		m_ActiveLocationCount = 0;

		if (m_arrTargetEffects.Length > 0)
		{
			EffectState = XComGameState_Effect( `XCOMHISTORY.GetGameStateForObjectID( m_arrTargetEffects[0].ObjectID ) );
			if (EffectState != none)
			{
				EffectTemplate = EffectState.GetX2Effect( );
				bPersistOnCasterDeath = !EffectTemplate.bRemoveWhenSourceDies;
			}
		}
	}

	simulated function OnPerkActivation( PerkActivationData ActivationData )
	{
		PerkStart( ActivationData );

		GotoState( 'ActionActive' );
	}

	simulated function OnPerkLoad( PerkActivationData ActivationData )
	{
		local int CasterIndex;

		`assert(m_PerkData.AssociatedEffect != '');

		// on load we need to clean the activation data up
		CasterIndex = ActivationData.TargetUnits.Find( m_kCasterPawn.m_kGameUnit );
		if (CasterIndex != INDEX_NONE && m_PerkData.IgnoreCasterAsTarget)
		{
			ActivationData.TargetUnits.Remove( CasterIndex, 1 );
			ActivationData.TargetEffects.Remove( CasterIndex, 1 );
		}
		`assert( ActivationData.TargetUnits.Length > 0 );

		PerkStart( ActivationData );

		GotoState( 'DurationActive' );
	}

Begin:
}

simulated state ActionActive
{
	simulated function StartTargetIndependentEffects( )
	{
		m_RecievedImpactEvent = false;

		// clean up these arrays from the previous activation
		StopTargetLocationSoundCue( m_LocationDurationEndSounds );
		StopTargetLocationSoundCue( m_LocationDeactivationSounds );

		if (m_PerkData.DisablePersistentFXDuringActivation)
		{
			StopPersistentFX( );
		}

		if (m_PerkData.ManualFireNotify)
		{
			if (m_PerkData.FireVolleyDelay > 0)
			{
				SetTimer( m_PerkData.FireVolleyDelay, false, nameof( DoManualFireVolley ) );
			}
			else
			{
				DoManualFireVolley( );
			}
		}

		TimerDoEffects( m_PerkData.CasterActivationFX, DoCasterActivationParticleFX );
		PlaySoundCue( m_kPawn, m_PerkData.CasterActivationSound );

		if (m_CasterActivationMITV != none)
		{
			m_CasterActivationMITV.ApplyMITV( m_kPawn );
		}

		if (m_PerkData.AssociatedEffect != '')
		{
			TimerDoEffects( m_PerkData.CasterDurationFX, DoCasterDurationParticleFX );
			PlaySoundCue( m_kPawn, m_PerkData.CasterDurationSound );
		}

		PrepTargetMITVs( m_TargetActivationMITVs, m_PerkData.TargetActivationMITV );
	}

	simulated function StartTargetImpactEffects( )
	{
		local XComUnitPawnNativeBase TargetPawn;
		local int x;

		TimerDoEffects( m_PerkData.TargetActivationFX, DoTargetActivationParticleFX );
		PlayTargetsSoundCues( m_PerkData.TargetActivationSound, m_arrTargetPawns );
		PlayTargetLocationSoundCue( m_PerkData.TargetLocationsActivationSound, m_arrTargetLocations, m_LocationActivationSounds );

		if (m_PerkData.TargetActivationMITV != none)
		{
			for (x = 0; x < m_arrTargetPawns.Length; ++x)
			{
				TargetPawn = m_arrTargetPawns[ x ];
				m_TargetActivationMITVs[ x ].ApplyMITV( TargetPawn );
			}
		}

		if (m_PerkData.AssociatedEffect != '')
		{
			TimerDoEffects( m_PerkData.TargetDurationFX, DoTargetDurationParticleFX );
			PlayTargetsSoundCues( m_PerkData.TargetDurationSound, m_arrTargetPawns );
			PlayTargetLocationSoundCue( m_PerkData.TargetLocationsDurationSound, m_arrTargetLocations, m_LocationDurationSounds );
		}

		TimerDoEffects( m_PerkData.TetherToTargetFX, DoTetherParticleFXWrapper );
	}

	simulated function StartTethers( )
	{
		local int x;

		m_TetherParticles.Length = m_arrTargetPawns.Length;
		m_TetherAttachmentActors.Length = m_arrTargetPawns.Length;

		for (x = 0; x < m_arrTargetPawns.Length; ++x)
		{
			m_TetherAttachmentActors[ x ] = Spawn( class'DynamicPointInSpace', self );
			m_TetherParticles[ x ].Particles.Length = 0;
		}
		UpdateAttachmentLocations( );

		TimerDoEffects( m_PerkData.TetherStartupFX, DoTetherStartupParticleFX );
	}

	simulated function EndTargetIndepentEffects( )
	{
		local XComGameState_Unit VisualizedUnit;

		if (m_PerkData.DisablePersistentFXDuringActivation)
		{
			StartPersistentFX( );
		}

		if (m_CasterActivationMITV != none && m_PerkData.ResetCasterActivationMTIVOnDeactivate)
		{
			if (m_CasterActivationMITV.bApplyFullUnitMaterial)
			{
				m_kPawn.CleanUpMITV( );
			}
			else
			{
				m_CasterActivationMITV.ResetPawnName = m_kPawn.Name;
				m_CasterActivationMITV.ResetMaterial( );
			}
		}

		StopCasterActivationParticleFX( );
		StopSoundCue( m_kPawn, m_PerkData.CasterActivationSound );
		TimerDoEffects( m_PerkData.CasterDeactivationFX, DoCasterDeactivationParticleFX );
		PlaySoundCue( m_kPawn, m_PerkData.CasterDeactivationSound );


		VisualizedUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID( m_kPawn.ObjectID ));

		if (m_PerkData.TargetEffectsOnProjectileImpact && !m_RecievedImpactEvent && VisualizedUnit.IsAlive())
		{
			`redscreen( "Perk Content for "@m_PerkData.AssociatedAbility@"."@m_PerkData.AssociatedEffect@" did not receive expected projectile impact. Tell StephenJameson" );
		}
	}

	simulated event BeginState( Name PreviousStateName )
	{
		StartTargetIndependentEffects( );

		if ((m_PerkData.TetherToTargetFX.Length != 0) ||
			(m_PerkData.TetherStartupFX.Length != 0))
		{
			StartTethers( );
		}

		if (!m_PerkData.TargetEffectsOnProjectileImpact)
		{
			StartTargetImpactEffects( );
		}
	}

	simulated event EndState( name nmNext )
	{
		local int x;

		EndTargetIndepentEffects( );

		if (((m_PerkData.TetherToTargetFX.Length != 0) ||
			 (m_PerkData.TetherStartupFX.Length != 0)) && m_PerkData.AssociatedEffect == '') // Disable any tethers with no associated effects.
		{
			// Fixes Hunter Tracking Shot tether that otherwise never gets cleared.
			StopExistingTetherFX();

			for (x = 0; x < m_arrTargetPawns.Length; ++x)
			{
				if (m_TetherAttachmentActors[x] != none)
					m_TetherAttachmentActors[x].Destroy();
			}
		}

		StopTargetActivationParticleFX( );
		StopTargetsSoundCues( m_PerkData.TargetActivationSound, m_arrTargetPawns );
		StopTargetLocationSoundCue( m_LocationActivationSounds );

		TimerDoEffects( m_PerkData.TargetDeactivationFX, DoTargetDeactivationParticleFX );
		PlayTargetsSoundCues( m_PerkData.TargetDeactivationSound, m_arrTargetPawns );
		PlayTargetLocationSoundCue( m_PerkData.TargetLocationsDeactivationSound, m_arrTargetLocations, m_LocationDeactivationSounds );
	}

	simulated function TriggerImpact( )
	{
		if (m_PerkData.TargetEffectsOnProjectileImpact && !m_RecievedImpactEvent)
		{
			StartTargetImpactEffects( );
		}
		m_RecievedImpactEvent = true;
	}

	simulated function OnPerkDeactivation( )
	{
		if (m_PerkData.TargetEffectsOnProjectileImpact && !m_RecievedImpactEvent)
		{
			StartTargetImpactEffects( ); // Make sure we play the effects anyway and that the location count get set appropriately.
		}

		// if there's no effect or no targets
		if ((m_PerkData.AssociatedEffect == '') || ((m_arrTargetPawns.Length == 0) && (m_ActiveLocationCount == 0) && (m_PerkData.TetherToTargetFX.Length == 0) && (m_ShooterEffect.ObjectID <= 0)))
		{
			if (bDeactivationIdleNotDestroy)
			{
				GotoState( 'Idle' );
			}
			else
			{
				GotoState( 'PendingDestroy' );
			}
		}
		else
		{
			GotoState( 'DurationActive' );
		}
	}

Begin:
}

simulated state DurationActive
{
	simulated event BeginState( Name PreviousStateName )
	{
		local XComUnitPawnNativeBase TargetPawn;
		local int x;

		if (PreviousStateName == 'Idle') // coming from save/load process
		{
			// initially size the target arrays.  we don't use them, but by the time we're active these should be the
			// same size regardless of how the perk started up (from activation or load).
			m_TargetActivationParticles.Length = m_arrTargetPawns.Length + m_arrTargetLocations.Length;
			m_TargetDeactivationParticles.Length = m_arrTargetPawns.Length + m_arrTargetLocations.Length;

			StartCasterParticleFX( m_PerkData.CasterDurationFX, m_CasterDurationParticles, true );
			PlaySoundCue( m_kPawn, m_PerkData.CasterDurationSound );

			StartTargetsParticleFX( m_PerkData.TargetDurationFX, m_TargetDurationParticles, true );
			PlayTargetsSoundCues( m_PerkData.TargetDurationSound, m_arrTargetPawns );
			PlayTargetLocationSoundCue( m_PerkData.TargetLocationsDurationSound, m_arrTargetLocations, m_LocationDurationSounds );

			m_TetherParticles.Length = m_arrTargetPawns.Length;
			m_TetherAttachmentActors.Length = m_arrTargetPawns.Length;

			for (x = 0; x < m_arrTargetPawns.Length; ++x)
			{
				m_TetherAttachmentActors[ x ] = Spawn( class'DynamicPointInSpace', self );
				m_TetherParticles[ x ].Particles.Length = 0;
			}
			UpdateAttachmentLocations( );
			DoTetherParticleFX( true );
		}

		m_kPawn.arrTargetingPerkContent.AddItem( self );
		if (m_CasterDurationMITV != none)
		{
			m_CasterDurationMITV.ApplyMITV( m_kPawn );
		}

		PrepTargetMITVs( m_TargetDurationMITVs, m_PerkData.TargetDurationMITV );
		PrepTargetMITVs( m_TargetDurationEndMITVs, m_PerkData.TargetDurationEndMITV );
		for (x = 0; x < m_arrTargetPawns.Length; ++x)
		{
			TargetPawn = m_arrTargetPawns[x];

			TargetPawn.arrTargetingPerkContent.AddItem( self );

			if (m_PerkData.TargetDurationMITV != none)
			{
				m_TargetDurationMITVs[x].ApplyMITV( TargetPawn );
			}
		}

		for (x = 0; x < m_arrTargetEffects.Length; ++x)
		{
			if (m_arrTargetEffects[ x ].ObjectID == 0)
				RemovePerkTarget( m_arrTargets[ x ] );
		}
	}

	simulated event EndState( name nmNext )
	{
		local XComUnitPawnNativeBase TargetPawn;
		local int x;

		m_kPawn.arrTargetingPerkContent.RemoveItem( self );

		foreach m_arrTargetPawns( TargetPawn )
		{
			TargetPawn.arrTargetingPerkContent.RemoveItem( self );
		}
		m_ActiveTargetCount = 0;

		EndCasterParticleFX( m_PerkData.CasterDurationFX, m_CasterDurationParticles );
		EndTargetsParticleFX( m_TargetDurationParticles );

		StopSoundCue( m_kPawn, m_PerkData.CasterDurationSound );
		StopTargetsSoundCues( m_PerkData.TargetDurationSound, m_arrTargetPawns );
		StopTargetLocationSoundCue( m_LocationDurationSounds );

		TimerDoEffects( m_PerkData.CasterDurationEndedFX, DoCasterDurationEndedParticleFX );
		TimerDoEffects( m_PerkData.TargetDurationEndedFX, DoTargetDurationEndedParticleFX );

		PlaySoundCue( m_kPawn, m_PerkData.CasterDurationEndSound );
		PlayTargetsSoundCues( m_PerkData.TargetDurationEndSound, m_arrTargetPawns );
		PlayTargetLocationSoundCue( m_PerkData.TargetLocationsDurationEndSound, m_arrTargetLocations, m_LocationDurationSounds );

		if (m_PerkData.TetherToTargetFX.Length != 0)
		{
			StopExistingTetherFX( );
			DoTetherShutdownParticleFX( );
			UpdateTetherParticleParams( );

			for (x = 0; x < m_arrTargetPawns.Length; ++x)
			{
				if (m_TetherAttachmentActors[x] != none)
					m_TetherAttachmentActors[x].Destroy( );
			}
		}

		if (m_CasterDurationMITV != none)
		{
			if (m_CasterDurationMITV.bApplyFullUnitMaterial)
			{
				m_kPawn.CleanUpMITV( );
			}
			else
			{
				m_CasterDurationMITV.ResetPawnName = m_kPawn.Name;
				m_CasterDurationMITV.ResetMaterial( );
			}
		}

		for (x = 0; x < m_arrTargetPawns.Length; ++x)
		{
			TargetPawn = m_arrTargetPawns[x];
			if (TargetPawn == none)
				continue;

			if (m_TargetDurationMITVs[x] != none)
			{
				if (m_TargetDurationMITVs[x].bApplyFullUnitMaterial)
				{
					TargetPawn.CleanUpMITV( );
				}
				else
				{
					m_TargetDurationMITVs[x].ResetPawnName = TargetPawn.Name;
					m_TargetDurationMITVs[x].ResetMaterial( );
				}
			}

			if (m_TargetDurationEndMITVs[x] != none)
			{
				m_TargetDurationEndMITVs[x].ApplyMITV( TargetPawn );
			}
		}
	}

	simulated function OnPerkDurationEnd( )
	{
		GotoState( 'PendingDestroy' );
	}

Begin:
}

simulated state PendingDestroy
{
	simulated function BeginState(  Name PreviousStateName  )
	{
		m_kCasterPawn.arrPawnPerkContent.RemoveItem( self );
	}

	simulated event Tick(float fDeltaT)
	{
		local TTargetParticles TargetParticles;
		local ParticleSystemComponent Particles;
		local bool ActiveParticlesFound;

		ActiveParticlesFound = false;

		foreach m_TargetDurationEndedParticles( TargetParticles )
		{
			foreach TargetParticles.Particles( Particles )
			{
				ActiveParticlesFound = ActiveParticlesFound || (!Particles.bWasDeactivated && !Particles.bWasCompleted);
			}
		}

		foreach m_TargetDeactivationParticles( TargetParticles )
		{
			foreach TargetParticles.Particles( Particles )
			{
				ActiveParticlesFound = ActiveParticlesFound || (!Particles.bWasDeactivated && !Particles.bWasCompleted);
			}
		}

		foreach m_TetherParticles( TargetParticles )
		{
			foreach TargetParticles.Particles( Particles )
			{
				ActiveParticlesFound = ActiveParticlesFound || (!Particles.bWasDeactivated && !Particles.bWasCompleted);
			}
		}

		foreach m_CasterDurationEndedParticles( Particles )
		{
			ActiveParticlesFound = ActiveParticlesFound || (!Particles.bWasDeactivated && !Particles.bWasCompleted);
		}

		foreach m_CasterDeactivationParticles( Particles )
		{
			ActiveParticlesFound = ActiveParticlesFound || (!Particles.bWasDeactivated && !Particles.bWasCompleted);
		}

		if (!ActiveParticlesFound)
			Destroy( );
	}

	Begin:
}