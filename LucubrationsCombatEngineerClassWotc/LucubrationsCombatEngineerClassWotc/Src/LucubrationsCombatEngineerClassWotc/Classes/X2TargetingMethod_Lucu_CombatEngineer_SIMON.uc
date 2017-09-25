class X2TargetingMethod_Lucu_CombatEngineer_SIMON extends X2TargetingMethod_Grenade;

var vector NewTargetLocation;

static function bool UseGrenadePath() { return false; }

function Update(float DeltaTime)
{
	local XComWorldData World;
	local VoxelRaytraceCheckResult Raytrace;
	local array<Actor> CurrentlyMarkedTargets;
	local int Direction, CanSeeFromDefault;
	local UnitPeekSide PeekSide;
	local int OutRequiresLean;
	local TTile BlockedTile, PeekTile, UnitTile;
	local bool GoodView;
	local CachedCoverAndPeekData PeekData;
	local array<TTile> Tiles;
	local GameRulesCache_VisibilityInfo OutVisibilityInfo;
    
	World = `XWORLD;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z += World.WORLD_FloorHeight;

	if (NewTargetLocation != CachedTargetLocation)
	{
		GoodView = false;
		if (World.VoxelRaytrace_Locations(FiringUnit.Location, NewTargetLocation, Raytrace))
		{
			BlockedTile = Raytrace.BlockedTile;
			//  check left and right peeks
			FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, OutVisibilityInfo, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

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
					BlockedTile = Raytrace.BlockedTile;
			}				
		}		
		else
		{
			GoodView = true;
		}

		if (!GoodView)
		{
			NewTargetLocation = World.GetPositionFromTileCoordinates(BlockedTile);
			Cursor.CursorSetLocation(NewTargetLocation);
		}
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		//DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.UpdateTargetLocation(DeltaTime);
}

simulated protected function Vector GetSplashRadiusCenter( bool SkipTileSnap = false )
{
	return NewTargetLocation;
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(NewTargetLocation);
}

protected function GetTargetedActors(const vector Location, out array<Actor> TargetActors, optional out array<TTile> TargetTiles)
{
	local X2AbilityTemplate AbilityTemplate;
    local X2AbilityMultiTarget_Radius AbilityMultiTarget;
    
	AbilityTemplate = Ability.GetMyTemplate();
    AbilityMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);

    // Get tiles in the blast radius using ability targeting logic
    AbilityMultiTarget.GetValidTilesForLocation(Ability, Location, TargetTiles);

    // Gather multi-targets for tiles in the blast radius using native logic
    GetTargetedActorsInTiles(TargetTiles, TargetActors, false);
}
