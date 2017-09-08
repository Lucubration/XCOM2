//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_PreppingCallReinforcementsRemoved extends X2Action;

var localized string m_sPreppingCallReinforcementsRemovedMessage;

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function RequestLookAtCamera()
	{		
		local X2Camera_LookAtActorTimed LookAtCam;
		local XComCamera Cam;

		if( Unit != none && ShouldAddCameras() )
		{	
			Cam = XComCamera(GetALocalPlayerController().PlayerCamera);
			if(Cam == none) return;

			LookAtCam = new class'X2Camera_LookAtActorTimed';
			LookAtCam.ActorToFollow = Unit;
			LookAtCam.LookAtDuration = 2.0f;
			Cam.CameraStack.AddCamera(LookAtCam);
		}
	}
Begin:
	
	RequestLookAtCamera();
	if( `CHEATMGR.bWorldDebugMessagesEnabled )
	{
		`PRES.QueueWorldMessage(m_sPreppingCallReinforcementsRemovedMessage, Unit.GetLocation(), Unit.GetVisualizedStateReference(), eColor_Bad, , , Unit.m_eTeamVisibilityFlags, , , , , , , , , , , , , true);
	}

	CompleteAction();
}

defaultproperties
{
}

