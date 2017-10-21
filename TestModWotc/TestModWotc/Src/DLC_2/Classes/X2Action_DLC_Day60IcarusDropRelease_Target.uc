//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_DLC_Day60IcarusDropRelease_Target extends X2Action_DLC_Day60IcarusDropRelease;

//Cached info for performing the action
//*************************************
var protected XComGameState_Unit			UnitState;
var private Actor							PartnerVisualizer;
var private XComUnitPawn					PartnerUnitPawn;
var private vector                          StartingLocation;
var private float                           DistanceFromStartSquared;
var private float                           StopDistanceSquared; // distance from the origin of the grapple past which we are done
var private vector                          UnitEndLoc;
var private AnimNodeSequence                SourceAnim;
var private float                           fHurtDropStopDistance;
//*************************************

function Init()
{
	local XComWorldData WorldData;
	
	super.Init();

	WorldData = `XWORLD;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Metadata.StateObject_NewState.ObjectID, , StateChangeContext.AssociatedState.HistoryIndex));

	// Save Unit info
	UnitEndLoc = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);
	UnitEndLoc.Z = Unit.GetDesiredZForLocation(UnitEndLoc, false);

	fHurtDropStopDistance = UnitPawn.GetAnimTreeController().ComputeAnimationRMADistance('NO_IcarusDrop_HurtDropStop');

//	`SHAPEMGR.DrawSphere(UnitEndLoc, vect(15,15,15), MakeLinearColor(0,1,0,1), true);
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{

Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	PlayReleaseStartAnim(Unit, UnitPawn);

	// to protect against overshoot, rather than check the distance to the target, we check the distance from the source.
	// Otherwise it is possible to go from too far away in front of the target, to too far away on the other side
	StartingLocation = UnitPawn.Location;
	StopDistanceSquared = Square(VSize(UnitEndLoc - StartingLocation) - fHurtDropStopDistance);

	DistanceFromStartSquared = 0;
	while( DistanceFromStartSquared < StopDistanceSquared )
	{
		Sleep(0.0f);
		DistanceFromStartSquared = VSizeSq(UnitPawn.Location - StartingLocation);
	}

	SourceAnim = PlayReleaseStopAnim(UnitPawn, UnitEndLoc);

	FinishAnim(SourceAnim);

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}

DefaultProperties
{
}
