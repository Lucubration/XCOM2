//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_SelectNextActiveUnit extends X2Action
	;

//Cached info for performing the action
//*************************************
var int				TargetID;
//*************************************

function SelectTargetUnit()
{
	local XComTacticalController Controller;

	Controller = XComTacticalController(GetALocalPlayerController());
	Controller.Visualizer_SelectUnit(XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetID)));
	Controller.bManuallySwitchedUnitsWhileVisualizerBusy = true;
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
Begin:
	SelectTargetUnit();

	CompleteAction();
}

DefaultProperties
{
}
