//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_RebootRobot extends X2Action_PlayAnimation;

function Init()
{
	super.Init();

	Params.AnimName = 'HL_RobotBattleSuitStop';
}

simulated state Executing
{
Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));

	UnitPawn.EnableFootIK(true);
	UnitPawn.bSkipIK = false;

	CompleteAction();
}