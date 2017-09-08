class X2TargetingMethod_Lucu_Garage_Radius extends X2TargetingMethod_Grenade;

var vector NewTargetLocation;
var XComGameState_Item WeaponItem;
var bool PenetratesCover;

function Init(AvailableAction InAction)
{
	super.Init(InAction);
	
	WeaponItem = Ability.GetSourceWeapon();
}

function Canceled()
{
	super.Canceled();
}

static function bool UseGrenadePath() { return false; }

function Update(float DeltaTime)
{
	local XComWorldData World;
	local VoxelRaytraceCheckResult Raytrace;
	local array<Actor> CurrentlyMarkedTargets;
	local int Direction, CanSeeFromDefault;
	local UnitPeekSide PeekSide;
	local int OutRequiresLean;
	local TTile PeekTile, UnitTile;
	local bool GoodView;
	local CachedCoverAndPeekData PeekData;
	local array<TTile> Tiles;
	local vector FiringUnitLocation, BlockedPosition, BackPath;
	local UnitValue CheckValue;
	
	World = `XWORLD;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z += World.WORLD_FloorHeight;

	if( NewTargetLocation != CachedTargetLocation )
	{
		GoodView = false;
		FiringUnitLocation = FiringUnit.Location;
		FiringUnitLocation.Z += World.WORLD_FloorHeight;
		if (UnitState.GetUnitValue(class'X2Ability_Sectopod'.default.HighLowValueName, CheckValue) && CheckValue.fValue == class'X2Ability_Sectopod'.const.SECTOPOD_HIGH_VALUE)
			FiringUnitLocation.Z += class'Lucu_Garage_Config'.default.HighStanceHeightDelta;
		if (!PenetratesCover)
		{
			if (World.VoxelRaytrace_Locations(FiringUnitLocation, NewTargetLocation, Raytrace))
			{
				BlockedPosition = Raytrace.TraceBlocked;
				//  check left and right peeks
				FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

				if (PeekSide != eNoPeek)
				{
					UnitTile = World.GetTileCoordinatesFromPosition(FiringUnit.Location);
					PeekData = World.GetCachedCoverAndPeekData(UnitTile);
					if (PeekSide == ePeekLeft)
						PeekTile = PeekData.CoverDirectionInfo[Direction].LeftPeek.PeekTile;
					else
						PeekTile = PeekData.CoverDirectionInfo[Direction].RightPeek.PeekTile;

					if (!World.VoxelRaytrace_Tiles(UnitTile, PeekTile, Raytrace))
						GoodView = true;
					else
						BlockedPosition = Raytrace.TraceBlocked;
				}

				if (!GoodView)
				{
					// Move the blocked position several units backwards along the path in X and Y dimensions to try to prevent target cursor clipping.
					// This is mostly applicable for non-penetrating rockets like Shredders
					BackPath = FiringUnitLocation - BlockedPosition;
					if (BackPath.X != 0)
						BackPath.X = 10*Abs(BackPath.X / BackPath.X);
					if (BackPath.Y != 0)
						BackPath.Y = 10*Abs(BackPath.Y / BackPath.Y);
					BlockedPosition.X += BackPath.X;
					BlockedPosition.Y += BackPath.Y;
				}
			}		
			else
			{
				GoodView = true;
			}
		}
		else
		{
			GoodView = true;
		}

		if (!GoodView)
		{
			NewTargetLocation = BlockedPosition;
			Cursor.CursorSetLocation(NewTargetLocation);
			//`SHAPEMGR.DrawSphere(LastTargetLocation, vect(25,25,25), MakeLinearColor(1,0,0,1), false);
		}

		// Find the firing distance. Store it for later reference
		FiringUnitLocation = `XWORLD.GetPositionFromTileCoordinates(UnitState.TileLocation);

		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.UpdateTargetLocation(DeltaTime);
}

simulated protected function Vector GetSplashRadiusCenter()
{
	return NewTargetLocation;
}

simulated protected function DrawSplashRadius()
{
	local Vector Center;
	local float Radius;
	local LinearColor CylinderColor;

	Center = GetSplashRadiusCenter();
	Radius = Ability.GetAbilityRadius();
	
	if (ExplosionEmitter != none)
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

function GetTargetLocations(out array<vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(NewTargetLocation);
}

DefaultProperties
{
	PenetratesCover=false
}
