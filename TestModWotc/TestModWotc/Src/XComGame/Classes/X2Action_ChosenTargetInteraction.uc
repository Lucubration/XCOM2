//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ChosenTargetInteraction extends X2Action;

//Cached info for performing the action
//*************************************
var	protected CustomAnimParams ChosenParams, TargetParams;
var protected XComUnitPawn TargetPawn;
var private XComUnitPawn TargetUnitPawn;
var private XGUnit TargetUnit;
var private vector TargetGameStatePos, Direction, VisualizationLocation;
var private AnimNodeSequence ChosenAnim, TargetAnim;
var private XComWorldData WorldData;
var private XComGameState_Unit TargetGameState;
var private vector FixupOffset;			//The offset that needs to be applied to the mesh due to the desired z location change.

var name ChosenAnimName, TargetAnimName;
var bool bUseSourceLocationForTarget;	// If true, the Target pawn is visualized in the same location as the Source (targert/source may be different height or size)

function Init()
{
	super.Init();

	WorldData = `XWORLD;

	if( Metadata.AdditionalVisualizeActors.Length != 1 )
	{ 
		`redscreen( "X2Action_ChosenTargetInteraction: An AdditionalVisualzeActor is expected to be present" );
	}

	TargetUnit = XGUnit(Metadata.AdditionalVisualizeActors[0]);
	TargetUnitPawn = TargetUnit.GetPawn();
	TargetGameStatePos = TargetUnit.GetGameStateLocation();

	//The fixup only applies to the Z coordinate.
	FixupOffset.X = 0;
	FixupOffset.Y = 0;
	FixupOffset.Z = UnitPawn.fBaseZMeshTranslation - TargetUnitPawn.fBaseZMeshTranslation;

	//`SHAPEMGR.DrawSphere(Unit.Location, vect(15,15,15), MakeLinearColor(1,0,0,1), true);
	//`SHAPEMGR.DrawSphere(VisualizationLocation, vect(15,15,15), MakeLinearColor(0,1,0,1), true);
}

simulated state Executing
{
Begin:
	// Chosen setup
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;
	UnitPawn.EnableFootIK(false);

	// Target setup
	TargetUnitPawn.EndRagDoll();
	TargetUnitPawn.EnableRMA(true, true);
	TargetUnitPawn.EnableRMAInteractPhysics(true);
	TargetUnitPawn.bSkipIK = true;
	TargetUnitPawn.bRunPhysicsWithNoController = false;
	TargetUnitPawn.EnableFootIK(false);

	// Set facing and position
	if( !bUseSourceLocationForTarget )
	{
		Direction = TargetGameStatePos - UnitPawn.Location;
		Direction.Z = 0.0f;
		Direction = Normal(Direction);
		VisualizationLocation = UnitPawn.Location + (Direction * WorldData.WORLD_StepSize);
	}
	else
	{
		VisualizationLocation = UnitPawn.Location;
	}

	VisualizationLocation.Z = TargetUnitPawn.GetDesiredZForLocation(UnitPawn.Location);
	TargetUnitPawn.SetLocation(VisualizationLocation);
	TargetUnitPawn.SetRotation(UnitPawn.Rotation);

	// Play Chosen animation
	ChosenParams.AnimName = ChosenAnimName;
	ChosenAnim = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(ChosenParams);

	// Play Target animation
	TargetParams.AnimName = TargetAnimName;
	TargetParams.BlendTime = 0.0f;

	// This unit may be locked down (stun) so we need to allow this action to animate it
	TargetUnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	TargetAnim = TargetUnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(TargetParams);

	FinishAnim(ChosenAnim);
	FinishAnim(TargetAnim);

	TargetGameStatePos.Z = TargetUnitPawn.GetDesiredZForLocation(TargetGameStatePos);
	TargetUnitPawn.SetLocation(TargetGameStatePos);

	CompleteAction();
}

defaultproperties
{
	bUseSourceLocationForTarget=false
}