//-----------------------------------------------------------
// Used by the visualizer system to control a Camera
//-----------------------------------------------------------
class X2Action_CameraRemove extends X2Action 
	dependson(X2Camera)
	config(Camera);

var X2Action_CameraLookAt CameraActionToRemove;
var name CameraTagToRemove;

//------------------------------------------------------------------------------------------------
simulated state Executing
{

Begin:

	CompleteAction();
}

function CompleteAction()
{
	local X2Camera Camera;
	local X2CameraStack CameraStack;

	CameraStack = `CAMERASTACK;
	if( CameraActionToRemove != none )
	{
		Camera = CameraActionToRemove.GetCamera();
	}
	else
	{
		Camera = CameraStack.FindCameraWithTag(CameraTagToRemove);
	}

	if( Camera != None )
	{
		CameraStack.RemoveCamera(Camera);
	}

	super.CompleteAction();
}

defaultproperties
{
}
