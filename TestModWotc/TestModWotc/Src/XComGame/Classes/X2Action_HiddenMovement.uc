//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_HiddenMovement extends X2Action_NoiseIndicator
	native(Core)
	config(GameCore);

var const config int MaxHearingRangeTiles; // maximum range at which an xcom soldier can "hear" an alien unit
var const config int TurnsUntilIndicator; // how many turns do we need to not see aliens before the indicator shows

// From the provided arrays, human that is closest to the aliens
// and under the maximum hearing distance, if any. Then find any pods that he can hear
static private native function bool GetClosestHumanAndPodLocations(out XComGameState_Unit OutClosestHuman,
																   out array<vector> OutPodLocations,
																   out StateObjectReference OutHeardPodLeader);

static function bool AddHiddenMovementActionToBlock(XComGameState GameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_HiddenMovement Action;
	local X2Action_CameraLookAt CameraAction;
	local XComGameState_Unit ClosestHumanUnit;
	local StateObjectReference OutHeardPodLeader;
	local array<vector> PodLocationstoHear;
	local vector PodLocation;

	if(class'XComGameState_Cheats'.static.GetCheatsObject(GameState.HistoryIndex).SuppressHiddenMovementIndicator)
	{
		return false;
	}

	// if we can find an appropriate human and pods to hear, then add a hear sound action for them
	if(GetClosestHumanAndPodLocations(ClosestHumanUnit, PodLocationstoHear, OutHeardPodLeader))
	{
		// Add a camera to center on the unit
		ActionMetadata.StateObject_OldState = ClosestHumanUnit;
		ActionMetadata.StateObject_NewState = ClosestHumanUnit;
		ActionMetadata.VisualizeActor = ClosestHumanUnit.GetVisualizer();

		CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));
		CameraAction.LookAtActor = ActionMetadata.VisualizeActor;
		CameraAction.UseTether = false; // need to fully center on him so the sound indicator doesn't overlap him
		CameraAction.BlockUntilActorOnScreen = true;

		// Add the action for the hidden movement
		Action = X2Action_HiddenMovement(class'X2Action_HiddenMovement'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext()));

		// get the average of all pod locations
		foreach PodLocationstoHear(PodLocation)
		{
			Action.TargetLocation += PodLocation;
		}

		Action.TargetLocation /= PodLocationstoHear.Length;
		Action.HeardUnitReference = OutHeardPodLeader;
	
		
		return true;
	}

	return false;
}

