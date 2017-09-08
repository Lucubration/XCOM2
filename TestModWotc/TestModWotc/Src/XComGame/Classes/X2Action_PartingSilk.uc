//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_PartingSilk extends X2Action;

var private Vector DesiredLocation;
var private vector StartingLocation;
var private float DistanceFromStartSquared;
var private float StopDistanceSquared;

var float DistanceCheck_UnrealUnits;

//------------------------------------------------------------------------------------------------
function Init()
{
	local XComGameState_Unit NewUnit;

	super.Init();

	NewUnit = XComGameState_Unit(Metadata.StateObject_NewState);

	DesiredLocation = `XWORLD.GetPositionFromTileCoordinates(NewUnit.TileLocation);
	DesiredLocation.Z = UnitPawn.GetDesiredZForLocation(DesiredLocation);
	
	StartingLocation = UnitPawn.Location;

	StopDistanceSquared = Square(VSize(DesiredLocation - StartingLocation) - DistanceCheck_UnrealUnits);
}

simulated state Executing
{
Begin:
	// Check how far the attacker has moved. This action will complete when the unit is within the 
	// desired radius, allowing reveal actions to run during the move
	DistanceFromStartSquared = 0;
	while (DistanceFromStartSquared < StopDistanceSquared)
	{
		Sleep(0.0f);
		DistanceFromStartSquared = VSizeSq(UnitPawn.Location - StartingLocation);
	}

	CompleteAction();
}