//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_PlayPoseOnRagdoll extends X2Action;

//Cached info for performing the action
//*************************************
var private XComGameState_Unit UnitState;
var private CustomAnimParams AnimParams;
//*************************************

function Init()
{
	super.Init();

	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
}

simulated state Executing
{
	function CopyPose()
	{
		AnimParams.AnimName = 'RagdollPose';
		AnimParams.Looping = true;
		AnimParams.BlendTime = 0.0f;
		AnimParams.HasPoseOverride = true;
		AnimParams.Pose = UnitPawn.Mesh.LocalAtoms;

		UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);
	}
Begin:

	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

	CopyPose();

	UnitPawn.EndRagDoll();

	UnitPawn.bRunPhysicsWithNoController = false;
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.EnableFootIK(false);
	UnitPawn.bSkipIK = true;

	UnitPawn.UpdateLootSparklesEnabled(false, UnitState);

	CompleteAction();
}