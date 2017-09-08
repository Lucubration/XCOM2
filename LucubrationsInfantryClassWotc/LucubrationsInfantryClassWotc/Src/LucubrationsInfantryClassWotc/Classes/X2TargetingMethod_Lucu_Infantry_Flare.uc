// So this class is basically the grenade targeting method... without the grenade. We're just going to make
// the sphere and highlighted tiles show up similar to Void Rift, except that Void Rift can reference the
// Psi Amp and we don't even have that as a weapon to reference so we had to strip those parts out
class X2TargetingMethod_Lucu_Infantry_Flare extends X2TargetingMethod;

var protected XCom3DCursor Cursor;
var protected transient XComEmitter ExplosionEmitter;
var protected bool bRestrictToSquadsightRange;
var protected XComGameState_Player AssociatedPlayerState;

var bool SnapToTile;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameStateHistory History;
	local float TargetingRange;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityTemplate AbilityTemplate;
	
	super.Init(InAction, NewTargetIndex);

	History = `XCOMHISTORY;

	AssociatedPlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
	`assert(AssociatedPlayerState != none);

	// determine our targeting range
	AbilityTemplate = Ability.GetMyTemplate();
	TargetingRange = Ability.GetAbilityCursorRangeMeters();

	// lock the cursor to that range
	Cursor = `Cursor;
	Cursor.m_fMaxChainedDistance = `METERSTOUNITS(TargetingRange);

	CursorTarget = X2AbilityTarget_Cursor(Ability.GetMyTemplate().AbilityTargetStyle);
	if (CursorTarget != none)
		bRestrictToSquadsightRange = CursorTarget.bRestrictToSquadsightRange;

	if (!AbilityTemplate.SkipRenderOfTargetingTemplate)
	{
		// setup the blast emitter
		ExplosionEmitter = `BATTLE.spawn(class'XComEmitter');
		if(AbilityIsOffensive)
		{
			ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere", class'ParticleSystem')));
		}
		else
		{
			ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere_Neutral", class'ParticleSystem')));
		}
		
		ExplosionEmitter.LifeSpan = 60 * 60 * 24 * 7; // never die (or at least take a week to do so)
	}
}

function Canceled()
{
	super.Canceled();

	// unlock the 3d cursor
	Cursor.m_fMaxChainedDistance = -1;

	// clean up the ui
	ExplosionEmitter.Destroy();
	ClearTargetedActors();
}

function Committed()
{
	Canceled();
}

simulated protected function Vector GetSplashRadiusCenter()
{
	local vector Center;
	local TTile SnapTile;

	Center = Cursor.GetCursorFeetLocation();

	if (SnapToTile)
	{
		SnapTile = `XWORLD.GetTileCoordinatesFromPosition( Center );
		`XWORLD.GetFloorPositionForTile( SnapTile, Center );
	}

	return Center;
}

simulated protected function DrawSplashRadius()
{
	local Vector Center;
	local float Radius;
	local LinearColor CylinderColor;

	Center = GetSplashRadiusCenter();
	Radius = Ability.GetAbilityRadius();
	
	if(ExplosionEmitter != none)
	{
		ExplosionEmitter.SetLocation(Center); // Set initial location of emitter
		ExplosionEmitter.SetDrawScale(Radius / 48.0f);
		ExplosionEmitter.SetRotation( rot(0,0,1) );

		if( !ExplosionEmitter.ParticleSystemComponent.bIsActive )
		{
			ExplosionEmitter.ParticleSystemComponent.ActivateSystem();			
		}

		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, Name("RadiusColor"), CylinderColor);
		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, Name("RadiusColor"), CylinderColor);
	}
}

function Update(float DeltaTime)
{
	local array<Actor> CurrentlyMarkedTargets;
	local vector NewTargetLocation;
	local array<TTile> Tiles;

	NewTargetLocation = GetSplashRadiusCenter();

	if(NewTargetLocation != CachedTargetLocation)
	{		
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.Update(DeltaTime);
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(GetSplashRadiusCenter());
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local TTile TestLoc;
	if (TargetLocations.Length == 1)
	{
		if (bRestrictToSquadsightRange)
		{
			TestLoc = `XWORLD.GetTileCoordinatesFromPosition(TargetLocations[0]);
			if (!class'X2TacticalVisibilityHelpers'.static.CanSquadSeeLocation(AssociatedPlayerState.ObjectID, TestLoc))
				return 'AA_NotVisible';
		}
		return 'AA_Success';
	}
	return 'AA_NoTargets';
}

function int GetTargetIndex()
{
	return 0;
}

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
	Ability.GatherAdditionalAbilityTargetsForLocation(GetSplashRadiusCenter(), AdditionalTargets);
	return true;
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
	Focus = GetSplashRadiusCenter();
	return true;
}

static function name GetProjectileTimingStyle()
{
	return '';
}

static function name GetOrdnanceType()
{
	return '';
}

defaultproperties
{
	SnapToTile = false;
}