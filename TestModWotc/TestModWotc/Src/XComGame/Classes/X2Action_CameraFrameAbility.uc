//-----------------------------------------------------------
// Used by the visualizer system to control a Camera
//-----------------------------------------------------------
class X2Action_CameraFrameAbility extends X2Action 
	dependson(X2Camera)
	config(Camera);

// time, in seconds, to pause on the framed ability after the framing camera arrives
var const config float FrameDuration;

// ability that this action should be framing
var array<XComGameStateContext_Ability> AbilitiesToFrame;

// the camera that will frame the ability
var X2Camera_FrameAbility FramingCamera;

var name CameraTag;

// if true, the camera will follow the units' movement
var bool bFollowMovingActors;

//------------------------------------------------------------------------------------------------
simulated state Executing
{
Begin:
	if( AbilitiesToFrame.Length > 0 )
	{
		if( !bNewUnitSelected )
		{
			// create the camera to frame the action
			FramingCamera = new class'X2Camera_FrameAbility';
			FramingCamera.AbilitiesToFrame = AbilitiesToFrame;
			FramingCamera.Priority = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilitiesToFrame[0].InputContext.AbilityTemplateName).CameraPriority;
			FramingCamera.CameraTag = CameraTag;
			FramingCamera.bFollowMovingActors = bFollowMovingActors;
			`CAMERASTACK.AddCamera(FramingCamera);

			// wait for it to finish framing the scene
			while( FramingCamera != None && !FramingCamera.HasArrived() )
			{
				Sleep(0.0);
			}
		}

		if( !bNewUnitSelected )
		{
			// pause on the frame action before starting it
			Sleep(FrameDuration * GetDelayModifier());
		}
	}
	
	CompleteAction();
}

event HandleNewUnitSelection()
{
	if( FramingCamera != None )
	{
		`CAMERASTACK.RemoveCamera(FramingCamera);
		FramingCamera = None;
	}
}

