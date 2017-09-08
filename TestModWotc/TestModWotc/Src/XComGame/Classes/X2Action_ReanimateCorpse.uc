//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ReanimateCorpse extends X2Action
	config(GameCore);

var private const config float LookAtZombieDurationSec; // in seconds

//Cached info for the unit performing the action
//*************************************
var protected XGUnit			ReanimatedUnit;
var protected TTile				CurrentTile;
var protected CustomAnimParams	AnimParams;

var private XComGameState_Unit			ReanimatedUnitState;
var private X2Camera_LookAtActorTimed	LookAtCam;
var private Actor						FOWViewer;					// The current FOW Viewer actor

// Set by visualizer so we know who to mimic
var bool						ShouldCopyAppearance;
var name                        ReanimationName;
var XComGameState_Ability       ReanimatorAbilityState;
var bool                        bWaitForDeadUnitMessage;
//*************************************

function Init()
{
	local XComGameStateHistory History;
	super.Init();

	History = `XCOMHISTORY;
	ReanimatedUnit = XGUnit(Metadata.VisualizeActor);

	ReanimatedUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ReanimatedUnit.ObjectID));
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{	
	private function RequestLookAtCamera()
	{
		if( ShouldAddCameras() )
		{
			LookAtCam = new class'X2Camera_LookAtActorTimed';
			LookAtCam.ActorToFollow = ReanimatedUnit;
			LookAtCam.LookAtDuration = LookAtZombieDurationSec;
			LookAtCam.UseTether = false;
			`CAMERASTACK.AddCamera(LookAtCam);

			FOWViewer = `XWORLD.CreateFOWViewer(ReanimatedUnit.GetLocation(), 3 * class'XComWorldData'.const.WORLD_StepSize);
		}
	}

	private function ClearLookAtCamera()
	{
		`CAMERASTACK.RemoveCamera(LookAtCam);
		LookAtCam = None;

		if (FOWViewer != None)
		{
			`XWORLD.DestroyFOWViewer(FOWViewer);
			FOWViewer = None;
		}
	}

Begin:

//	RequestLookAtCamera();
//
//	while (!LookAtCam.HasArrived)
//	{
//		Sleep(0.0);
//	}

	ReanimatedUnit.GetPawn().bSkipIK = false;
	ReanimatedUnit.GetPawn().EnableFootIK(true);
	ReanimatedUnit.GetPawn().EnableRMA(true, true);
	ReanimatedUnit.GetPawn().EnableRMAInteractPhysics(true);

	// Now blend in an animation to stand up
	AnimParams = default.AnimParams;
	AnimParams.AnimName = ReanimationName;
	AnimParams.BlendTime = 0.5f;
	AnimParams.DesiredEndingAtoms.Add(1);
	AnimParams.DesiredEndingAtoms[0].Translation = `XWORLD.GetPositionFromTileCoordinates(ReanimatedUnitState.TileLocation);
	AnimParams.DesiredEndingAtoms[0].Translation.Z = ReanimatedUnit.GetDesiredZForLocation(AnimParams.DesiredEndingAtoms[0].Translation);
	AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(ReanimatedUnit.GetPawn().Rotation);
	AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;
	FinishAnim(ReanimatedUnit.GetPawn().GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

//	ClearLookAtCamera();	

	CompleteAction();
}

function CompleteAction()
{	
	ReanimatedUnit.GetPawn().EnableRMA(true, true);
	ReanimatedUnit.GetPawn().EnableRMAInteractPhysics(true);

	super.CompleteAction();
}

DefaultProperties
{
	ShouldCopyAppearance = true;
	TimeoutSeconds=30
	bWaitForDeadUnitMessage=false
}
