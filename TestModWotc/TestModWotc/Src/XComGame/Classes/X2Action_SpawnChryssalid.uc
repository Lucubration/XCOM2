//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_SpawnChryssalid extends X2Action;

var XGUnit CocoonUnit;

var private vector VisualizationLocation;
var private Rotator FacingRot;
var private CustomAnimParams Params;
var private AnimNodeSequence PlayingSequence;

var protected TTile		CurrentTile;

function Init()
{
	local XComGameState_Unit UnitState;
	local vector TowardsTarget;

	super.Init();

	// if our visualizer hasn't been created yet, make sure it is created here.
	if (Unit == none)
	{
		UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
		`assert(UnitState != none);

		UnitState.SyncVisualizer(StateChangeContext.AssociatedState);
		Unit = XGUnit(UnitState.GetVisualizer());
		`assert(Unit != none);
	}

	TowardsTarget = Unit.Location - CocoonUnit.Location;
	TowardsTarget.Z = 0;
	TowardsTarget = Normal(TowardsTarget);
	FacingRot = Rotator(TowardsTarget);

	VisualizationLocation = CocoonUnit.Location;

	//	FacingRot = Rotator(TowardsTarget);
	Params.AnimName = 'NO_CocoonHatch';
	Params.BlendTime = 0.0f;
	Params.DesiredEndingAtoms.Add(1);
	Params.DesiredEndingAtoms[0].Scale = 1.0f;
	Params.DesiredEndingAtoms[0].Translation = Unit.Location;
	Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(FacingRot);
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
Begin:
	// Update the visibility
	VisualizationLocation.Z = Unit.GetDesiredZForLocation(VisualizationLocation);

	// Set the pawn's location and rotation to jump into the desired tile
	UnitPawn.SetLocation(VisualizationLocation);
	UnitPawn.SetRotation(FacingRot);
	
	CurrentTile = `XWORLD.GetTileCoordinatesFromPosition(Unit.Location);
	
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	// Show the unit
	Unit.m_bForceHidden = false;
	`TACTICALRULES.VisibilityMgr.ActorVisibilityMgr.VisualizerUpdateVisibility(Unit, CurrentTile);

	FinishAnim(PlayingSequence);

	CompleteAction();
}

defaultproperties
{
	bCauseTimeDilationWhenInterrupting = true
}