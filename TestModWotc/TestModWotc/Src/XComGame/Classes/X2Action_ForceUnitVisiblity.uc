//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor.
//-----------------------------------------------------------
class X2Action_ForceUnitVisiblity extends X2Action;

var EForceVisibilitySetting ForcedVisible;
var bool bMatchToGameStateLoc;

var private vector UpdatedLocation;

//------------------------------------------------------------------------------------------------

function Init()
{
	local XComGameState_Unit UnitState;
	local XComWorldData World;

	super.Init();

	if( bMatchToGameStateLoc )
	{
		World = `XWORLD;

		UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
		UpdatedLocation = World.GetPositionFromTileCoordinates(UnitState.TileLocation);
		UpdatedLocation.Z = Unit.GetDesiredZForLocation(UpdatedLocation);

		UnitPawn.SetLocation(UpdatedLocation);
	}

}

simulated state Executing
{
Begin:
	Unit.SetForceVisibility(ForcedVisible);
	Unit.GetPawn().UpdatePawnVisibility();
	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return false;
}

defaultproperties
{
	bMatchToGameStateLoc=false
}