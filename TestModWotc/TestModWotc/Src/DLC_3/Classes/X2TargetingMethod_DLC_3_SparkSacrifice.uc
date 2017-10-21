class X2TargetingMethod_DLC_3_SparkSacrifice extends X2TargetingMethod_PathTarget;

struct TileCheckedPair
{
	var TTile Tile;
	var name ValidatedReason;
};

var private float VisualRadiusUnits;
var private X2Actor_InvalidTarget InvalidTileActor;
var private array<TileCheckedPair> TilesChecked;
var private float OverlapRadiusTilesSq;
var private name PreviousValidateReturn;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local float RadiusTiles;
	local XGBattle Battle;

	super.Init(InAction, NewTargetIndex);

	Battle = `BATTLE;

	RadiusTiles = Sqrt(class'X2Ability_SparkAbilitySet'.default.SACRIFICE_DISTANCE_SQ);
	VisualRadiusUnits = `TILESTOUNITS(RadiusTiles);

	InvalidTileActor = Battle.Spawn(class'X2Actor_InvalidTarget');

	OverlapRadiusTilesSq = Square(RadiusTiles * 2);
	TilesChecked.Length = 0;

	PreviousValidateReturn = 'AA_Success';
}

function Canceled()
{
	super.Canceled();

	// clean up the ui
	InvalidTileActor.Destroy();

	TilesChecked.Length = 0;
}

simulated protected function DrawInvalidTile(vector Location)
{
	InvalidTileActor.SetHidden(false);
	InvalidTileActor.SetLocation(Location);
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local XComGameState_Unit CheckUnitState;
	local TTile TileLocation;
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local TileCheckedPair TileCheck;
	local int Index;

	if( TargetLocations.Length > 0 )
	{
		History = `XCOMHISTORY;
		WorldData = `XWORLD;

		TileLocation = WorldData.GetTileCoordinatesFromPosition(TargetLocations[0]);

		Index = TilesChecked.Find('Tile', TileLocation);
		if( Index != INDEX_NONE )
		{
			return TilesChecked[Index].ValidatedReason;
		}
	
		TileCheck.Tile = TileLocation;

		foreach History.IterateByClassType(class'XComGameState_Unit', CheckUnitState)
		{
			if( CheckUnitState.ObjectID != UnitState.ObjectID &&
				CheckUnitState.GetTeam() == eTeam_XCom &&
				!CheckUnitState.IsDead() &&
				!CheckUnitState.bRemovedFromPlay &&
				(CheckUnitState.AffectedByEffectNames.Find('SacrificeArmor') != INDEX_NONE) )
			{
				// Check to see if this Unit is within the Targeting Area for Sacrifice
				if( class'Helpers'.static.IsTileInRange(CheckUnitState.TileLocation, TileLocation, OverlapRadiusTilesSq) )
				{
					TileCheck.ValidatedReason = 'AA_NoTargets';
					TilesChecked.AddItem(TileCheck);

					return 'AA_NoTargets';
				}
			}
		}

		TileCheck.ValidatedReason = 'AA_Success';
		TilesChecked.AddItem(TileCheck);
		return 'AA_Success';
	}

	return 'AA_NoTargets';
}

function Update(float DeltaTime)
{
	local array<vector> NewTargetLocations;
	local array<TilePosPair> TilesPosPairs;
	local array<TTile> Tiles;
	local XComWorldData WorldData;
	local int i;
	local name CurrentValidateReason;

	IconManager.UpdateCursorLocation();
	LevelBorderManager.UpdateCursorLocation(Cursor.Location);

	NewTargetLocations.AddItem(Cursor.GetCursorFeetLocation());
	if( NewTargetLocations[0] != CachedTargetLocation )
	{		
		WorldData = `XWORLD;

		WorldData.CollectTilesInSphere(TilesPosPairs, NewTargetLocations[0], VisualRadiusUnits);
	
		for( i = 0; i < TilesPosPairs.Length; ++i )
		{
			Tiles.AddItem(TilesPosPairs[i].Tile);
		}
		
		CurrentValidateReason = ValidateTargetLocations(NewTargetLocations);
		if( PreviousValidateReturn != CurrentValidateReason )
		{
			// If the current and previous Validate Reasons are different, then the AoE mesh needs to change
			if( CurrentValidateReason == 'AA_Success' )
			{
				AOEMeshActor.InstancedMeshComponent.SetStaticMesh(StaticMesh(DynamicLoadObject("UI_3D.Tile.AOETile_Neutral", class'StaticMesh')));
			}
			else
			{
				AOEMeshActor.InstancedMeshComponent.SetStaticMesh(StaticMesh(`CONTENT.RequestGameArchetype("Materials_DLC3.3DUI.AOETile_NA")));
			}

			PreviousValidateReturn = CurrentValidateReason;
		}

		DrawAOETiles(Tiles);
	}

	super.UpdateTargetLocation(DeltaTime);
}