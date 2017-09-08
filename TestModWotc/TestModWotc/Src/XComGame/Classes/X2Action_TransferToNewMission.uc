//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_TransferToNewMission extends X2Action;

var string MissionType;
var array<StateObjectReference> ForcedCapturedSoldiers;
var array<StateObjectReference> ForcedEvacSoldiers;

simulated state Executing
{
	function TransferToNewMission()
	{
		local XComPlayerController PlayerController;

		if(MissionType == "")
		{
			`Redscreen("X2Action_TransferToNewMission!");
			return;
		}

		PlayerController = XComPlayerController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());
		PlayerController.TransferToNewMission(MissionType, ForcedCapturedSoldiers, ForcedEvacSoldiers);
	}

Begin:
	TransferToNewMission();

	CompleteAction();
}

DefaultProperties
{
}
