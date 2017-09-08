//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Destructible.uc
//  AUTHOR:  David Burchanowski  --  11/11/2014
//  PURPOSE: This object represents the instance data for an XComDestructibleActor on the
//           battlefield
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_Destructible extends XComGameState_BaseObject
	implements(X2GameRulesetVisibilityInterface, Damageable, X2VisualizedInterface)
	native(Core);

var bool OnlyAllowTargetWithEnemiesInTheBlastRadius;

//Instance-only variables
var ActorIdentifier ActorId;
var TTile TileLocation;
var int Health; // keep track of applied health so we can fire events when this object is destroyed
var bool bTargetableBySpawnedTeamOnly;
var StateObjectReference DestroyedByRemoteStartShooter;

var string SpawnedDestructibleArchetype;
var vector SpawnedDestructibleLocation;
var eTeam SpawnedDestructibleTeam;

cpptext
{
	// True if this object can be included in another viewer's visibility updates (ie. this object can be seen by other objects)
	virtual UBOOL CanEverBeSeen() const
	{
		return TRUE;
	}
};

native function bool IsTargetable(optional ETeam TargetingTeam = eTeam_None);

function SetInitialState(XComDestructibleActor InVisualizer)
{
	local XComWorldData WorldData;

	WorldData = `XWORLD;

	`XCOMHISTORY.SetVisualizer(ObjectID, InVisualizer);
	InVisualizer.SetObjectIDFromState(self);

	ActorId = InVisualizer.GetActorId( );
	TileLocation = WorldData.GetTileCoordinatesFromPosition( InVisualizer.Location );

	if(InVisualizer.Toughness != none && !InVisualizer.Toughness.bInvincible)
	{
		Health = InVisualizer.Toughness.Health;

		if(InVisualizer.IsTargetable() && `SecondWaveEnabled('BetaStrike' ) )
		{
			Health *= class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod;
		}
	}

	bRequiresVisibilityUpdate = true;
}

function Actor FindOrCreateVisualizer( optional XComGameState Gamestate = none )
{
	local XComGameStateHistory History;
	local XComDestructibleActor Visualizer;
	local XComWorldData World;
	local XComDestructibleActor DestructibleTemplate;
	
	Visualizer = XComDestructibleActor(GetVisualizer());
	if(Visualizer == none)
	{
		World = `XWORLD;

		if (SpawnedDestructibleArchetype == "")
		{
			Visualizer = World.FindDestructibleActor( ActorId );
		}
		else
		{
			DestructibleTemplate = XComDestructibleActor(`CONTENT.RequestGameArchetype(SpawnedDestructibleArchetype));
			if (DestructibleTemplate == None)
			{
				`RedScreen("Could not find template for destructible:" @ SpawnedDestructibleArchetype @ "-- object will not be functional! @jbouscher @gameplay");
				return none;
			}

			Visualizer = `XWORLDINFO.Spawn( DestructibleTemplate.Class, , , SpawnedDestructibleLocation, , DestructibleTemplate, , SpawnedDestructibleTeam );
			`assert(Visualizer != none);
			`XWORLD.RuntimeRegisterDestructibleActor(Visualizer);

			if (ActorId.ActorName == '')
				SetInitialState( Visualizer );
		}

		if (Visualizer != none)
		{
			History = `XCOMHISTORY;

			History.SetVisualizer( ObjectID, Visualizer );
			Visualizer.SetObjectIDFromState( self );
		}
		else
		{
			`redscreen("XComGameState_Destructible::SyncVisualizer was unable to find a visualizer for "@ActorId.OuterName@"."@ActorId.ActorName@" we thought was at {"@TileLocation.X@","@TileLocation.Y@","@TileLocation.Z@"}. Maybe it moved, maybe the asset is bad. Either way this session could be unstable.  ~RussellA");
		}
	}

	return Visualizer;
}

function SyncVisualizer(optional XComGameState GameState = none)
{
}

function AppendAdditionalSyncActions( out VisualizationActionMetadata ActionMetadata, const XComGameStateContext Context)
{
}

// X2GameRulesetVisibilityInterface Interface
event float GetVisibilityRadius();
event int GetAssociatedPlayerID() { return -1; }
event SetVisibilityLocation(const out TTile VisibilityLocation);

event bool TargetIsEnemy(int TargetObjectID, int HistoryIndex = -1)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComDestructibleActor DestructibleActor;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(TargetObjectID, , HistoryIndex));
	if(UnitState == none) return false;

	DestructibleActor = XComDestructibleActor(GetVisualizer());
	if(DestructibleActor == none || DestructibleActor.Toughness == none) return false;

	if (bTargetableBySpawnedTeamOnly)
		return UnitState.GetTeam() == SpawnedDestructibleTeam;

	switch(DestructibleActor.Toughness.TargetableBy)
	{
	case TargetableByNone:
		return false;
	case TargetableByXCom:
		return (UnitState.GetTeam() == eTeam_XCom || UnitState.GetTeam() == eTeam_Resistance);
	case TargetableByAliens:
		return (UnitState.GetTeam() == eTeam_Alien || UnitState.GetTeam() == eTeam_TheLost);
	case TargetableByAll:
		return true;
	}

	return false;
}

event bool TargetIsAlly(int TargetObjectID, int HistoryIndex = -1)
{
	return false;
}

event bool ShouldTreatLowCoverAsHighCover( )
{
	return false;
}

event UpdateGameplayVisibility(out GameRulesCache_VisibilityInfo InOutVisibilityInfo)
{
	InOutVisibilityInfo.bVisibleGameplay = InOutVisibilityInfo.bVisibleBasic;
}

native function NativeGetVisibilityLocation(out array<TTile> VisibilityTiles) const;
native function NativeGetKeystoneVisibilityLocation(out TTile VisibilityTile) const;

function GetVisibilityLocation(out array<TTile> VisibilityTiles)
{
	NativeGetVisibilityLocation(VisibilityTiles);
}

function GetKeystoneVisibilityLocation(out TTile VisibilityTile)
{
	NativeGetKeystoneVisibilityLocation(VisibilityTile);
}

event GetVisibilityExtents(out Box VisibilityExtents)
{
	local Vector HalfTileExtents;
	
	HalfTileExtents.X = class'XComWorldData'.const.WORLD_HalfStepSize;
	HalfTileExtents.Y = class'XComWorldData'.const.WORLD_HalfStepSize;
	HalfTileExtents.Z = class'XComWorldData'.const.WORLD_HalfFloorHeight;

	VisibilityExtents.Min = `XWORLD.GetPositionFromTileCoordinates( TileLocation ) - HalfTileExtents;
	VisibilityExtents.Max = `XWORLD.GetPositionFromTileCoordinates( TileLocation ) + HalfTileExtents;
	VisibilityExtents.IsValid = 1;
}

event EForceVisibilitySetting ForceModelVisible()
{
	return eForceVisible;
}

// Damageable Interface
function float GetArmorMitigation(const out ArmorMitigationResults Armor);
function bool IsImmuneToDamage(name DamageType);

event ForceDestroyed( XComGameState NewGameState, XComGameState_EnvironmentDamage AssociatedDamage )
{
	local XComGameState_Unit KillerUnitState;

	Health = 0;

	KillerUnitState = XComGameState_Unit( `XCOMHISTORY.GetGameStateForObjectID( AssociatedDamage.DamageCause.ObjectID ) );
	`XEVENTMGR.TriggerEvent( 'ObjectDestroyed', KillerUnitState, self, NewGameState );
	bRequiresVisibilityUpdate = true;
}

event TakeDamage( XComGameState NewGameState, const int DamageAmount, const int MitigationAmount, const int ShredAmount, optional EffectAppliedData EffectData,
		optional Object CauseOfDeath, optional StateObjectReference DamageSource, optional bool bExplosiveDamage = false, optional array<name> DamageTypes,
		optional bool bForceBleedOut = false, optional bool bAllowBleedout = true, optional bool bIgnoreShields = false, optional array<DamageModifierInfo> SpecialDamageMessages)
{
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComDestructibleActor Visualizer;
	local XComWorldData WorldData;
	local XComGameState_Unit KillerUnitState;
	local int OldHealth;

	WorldData = `XWORLD;
	Visualizer = XComDestructibleActor( GetVisualizer( ) );

	// track overall health. This is tracked in the actor from environment damage, but we need it
	// for game state queries too, and it updates latently on the actor
	if (Health < 0) // either indestructible or we haven't initialized our health value yet, check
	{
		if (Visualizer != none && Visualizer.Toughness != none && !Visualizer.Toughness.bInvincible)
		{
			Health = Visualizer.Toughness.Health;
		}
	}

	// update health and fire death messages, if needed
	if (Health >= 0) // < 0 indicates indestructible
	{
		OldHealth = Health;
		Health = Max( 0, class'XComDestructibleActor'.static.GetNewHealth( Visualizer, Health, DamageAmount ) );

		if (OldHealth != Health)
		{
			if (OldHealth > 0 && Health == 0)
			{
				// fire an event to notify that this object was destroyed
				KillerUnitState = XComGameState_Unit( `XCOMHISTORY.GetGameStateForObjectID( DamageSource.ObjectID ) );
				`XEVENTMGR.TriggerEvent( 'ObjectDestroyed', KillerUnitState, self, NewGameState );
				bRequiresVisibilityUpdate = true;
			}

			if (Visualizer.IsTargetable( ))
			{
				// Add an environment damage state at our location. This will cause the actual damage to the 
				// destructible actor in the world.
				DamageEvent = XComGameState_EnvironmentDamage( NewGameState.CreateNewStateObject( class'XComGameState_EnvironmentDamage' ) );
				DamageEvent.DEBUG_SourceCodeLocation = "UC: XComGameState_Destructible:TakeEffectDamage";
				DamageEvent.DamageAmount = DamageAmount;
				DamageEvent.DamageTypeTemplateName = 'Explosion';
				DamageEvent.HitLocation = WorldData.GetPositionFromTileCoordinates( TileLocation );
				DamageEvent.DamageTiles.AddItem( TileLocation );
				DamageEvent.DamageCause = DamageSource;
				DamageEvent.DamageSource = DamageEvent.DamageCause;
				DamageEvent.bTargetableDamage = true;
				DamageEvent.DamageTarget = GetReference( );
			}
		}
	}
}

function TakeEffectDamage(const X2Effect DmgEffect, const int DamageAmount, const int MitigationAmount, const int ShredAmount, const out EffectAppliedData EffectData, XComGameState NewGameState,
						  optional bool bForceBleedOut = false, optional bool bAllowBleedout = true, optional bool bIgnoreShields = false, optional array<Name> DamageTypes, optional array<DamageModifierInfo> SpecialDamageMessages)
{
	if( DamageTypes.Length == 0 )
	{
		DamageTypes = DmgEffect.DamageTypes;
	}
	TakeDamage( NewGameState, DamageAmount, MitigationAmount, ShredAmount, EffectData, DmgEffect, EffectData.SourceStateObjectRef, DmgEffect.IsExplosiveDamage( ),
					DamageTypes, bForceBleedOut, bAllowBleedout, bIgnoreShields, SpecialDamageMessages);
}

function int GetRupturedValue()
{
	return 0;
}

function AddRupturedValue(const int Rupture)
{
	//  nothin'
}

function AddShreddedValue(const int Shred)
{
	//  nothin'
}

function int GetDestroyedDamagePreview()		//	only for UI stuff
{
	local XComDestructibleActor Visualizer;

	Visualizer = XComDestructibleActor(GetVisualizer());
	if (Visualizer != none)
	{
		return Visualizer.GetDestroyedDamagePreview();
	}
	return 0;
}

DefaultProperties
{	
	bTacticalTransient=true
	Health = -1
	OnlyAllowTargetWithEnemiesInTheBlastRadius = true
}
