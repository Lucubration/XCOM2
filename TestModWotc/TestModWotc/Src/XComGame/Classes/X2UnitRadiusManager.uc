
class X2UnitRadiusManager extends Actor;

var private transient TTile LastCursorTile; // the last tile the cursor was in
var private transient bool Enabled;

simulated event Tick( float DeltaTime )
{
	local XComWorldData WorldData;
	local vector CursorLocation;
	local TTile CursorTile;
	local XComGameState_Unit Unit;
	local XComUnitPawn UnitPawn;
	local bool ShouldDraw;
	local int CivReactionTileRadius;
	local float CivReactionWorldRadius;

	if (!Enabled)
	{
		return;
	}

	WorldData = `XWORLD;
	CivReactionTileRadius = class'XGAIBehavior_Civilian'.default.CIVILIAN_NEAR_TERROR_REACT_RADIUS;
	CivReactionWorldRadius = CivReactionTileRadius * class'XComWorldData'.const.WORLD_StepSize;

	// default case, we just pick to the normal cursor location
	CursorLocation = `Cursor.Location;

	// snap the location to the ground
	CursorLocation.Z = WorldData.GetFloorZForPosition( CursorLocation );
	CursorTile = WorldData.GetTileCoordinatesFromPosition( CursorLocation );

	if (LastCursorTile == CursorTile)
	{
		return;
	}

	LastCursorTile = CursorTile;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		UnitPawn = XGUnit( Unit.GetVisualizer( ) ).GetPawn( );

		if ((UnitPawn == none) || (UnitPawn.m_eTeam != eTeam_Neutral))
		{
			continue;
		}

		if( Unit.bRemovedFromPlay )
		{
			UnitPawn.DetachRangeIndicator();
			continue;
		}

		ShouldDraw = UnitPawn.IsVisibleToTeam(eTeam_XCom) && !Unit.IsDead();

		if (ShouldDraw)
		{
			UnitPawn.AttachRangeIndicator(2 * CivReactionWorldRadius, UnitPawn.CivilianRescueRing);
		}
		else
		{
			UnitPawn.DetachRangeIndicator( );
		}
	}
}

function SetEnabled( bool BeEnabled )
{
	Enabled = BeEnabled;
}