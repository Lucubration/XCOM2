//-----------------------------------------------------------
// Used by the visualizer system to control a Camera
//-----------------------------------------------------------
class X2Action_CameraFollowUnit extends X2Action 
	dependson(X2Camera)
	config(Camera);

// ability that this action should be framing
var XComGameStateContext_Ability AbilityToFrame;
var bool bLockFloorZ;
var bool bIsPlayerControlledMove;

// the camera that will frame the ability
var X2Camera_FollowMovingUnit FollowCamera;

//Path data set from ParsePath. These are set into the unit and then referenced for the rest of the path
var private PathingInputData		CurrentMoveData;
var private PathingResultData		CurrentMoveResultData;

var name CameraTag;

function Init()
{
	local XComGameState_Unit UnitState;

	super.Init();

	Unit.CurrentMoveData = CurrentMoveData;
	Unit.CurrentMoveResultData = CurrentMoveResultData;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityToFrame.InputContext.SourceObject.ObjectID));	 
	if (UnitState != none)
	{
		bIsPlayerControlledMove = UnitState.IsPlayerControlled();
	}
}

function ParsePathSetParameters(const out PathingInputData InputData, const out PathingResultData ResultData)
{
	CurrentMoveData = InputData;
	CurrentMoveResultData = ResultData;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function bool ShouldCameraFrameAction()
	{
		local XComGameState_Unit UnitState;
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityToFrame.InputContext.SourceObject.ObjectID));

		if (`XENGINE.IsMultiplayerGame())
		{
			if (UnitState != None && UnitState.IsFriendlyToLocalPlayer() && UnitState.IsConcealed())
			{
				return !bNewUnitSelected;
			}
			return false;
		}
		return !bNewUnitSelected;
	}

Begin:

	if (ShouldCameraFrameAction())
	{
		// create the camera to frame the action
		FollowCamera = new class'X2Camera_FollowMovingUnit';
		FollowCamera.Unit = XGUnit(Metadata.VisualizeActor);
		FollowCamera.MoveAbility = AbilityToFrame;
		FollowCamera.Priority = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityToFrame.InputContext.AbilityTemplateName).CameraPriority;
		FollowCamera.bLockFloorZ = bLockFloorZ;
		FollowCamera.CameraTag = CameraTag;
		`CAMERASTACK.AddCamera(FollowCamera);

		// wait for it to get to the lookat point on screen, unless the unit moving is a local player unit ( let the player move their units as fast quickly as they like )
		while( !bIsPlayerControlledMove && FollowCamera != None && !FollowCamera.HasArrived && FollowCamera.IsLookAtValid() )
		{
			Sleep(0.0);
		}
	}
	
	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return false;
}

event HandleNewUnitSelection()
{
	if( FollowCamera != None )
	{
		`CAMERASTACK.RemoveCamera(FollowCamera);
		FollowCamera = None;
	}
}
