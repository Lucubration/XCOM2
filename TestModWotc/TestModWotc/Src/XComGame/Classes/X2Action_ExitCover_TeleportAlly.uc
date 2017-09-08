//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ExitCover_TeleportAlly extends X2Action_ExitCover;

function Init()
{
	super.Init();

	TargetLocation = AbilityContext.InputContext.TargetLocations[0];
	AimAtLocation = TargetLocation;

	bIsEndMoveAbility = false;
}