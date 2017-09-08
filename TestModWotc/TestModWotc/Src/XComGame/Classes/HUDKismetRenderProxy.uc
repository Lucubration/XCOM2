class HUDKismetRenderProxy extends Actor;

// Has the proxy been assigned to player controllers yet?
var bool HasAddedToAllControllers;
// List of HUD render events
var PrivateWrite array<HUDKismetSeqEvent_RenderHUD> RenderHUDSequenceEvents;

function AddRenderHUDSequenceEvent(HUDKismetSeqEvent_RenderHUD RenderHUDSequenceEvent)
{
	local int i;

	// Check if the Render HUD sequence event already exists
	if (RenderHUDSequenceEvents.Length > 0)
	{
		for (i = 0; i < RenderHUDSequenceEvents.Length; ++i)
		{
			if (RenderHUDSequenceEvents[i] == RenderHUDSequenceEvent)
			{
				return;
			}
		}
	}

	// Add the render HUD sequence event into the array
	RenderHUDSequenceEvents.AddItem(RenderHUDSequenceEvent);
}

function Tick(float DeltaTime)
{
	local PlayerController PlayerController;

	if (!HasAddedToAllControllers)
	{
		// Add the render proxy to all of the local player controllers
		ForEach WorldInfo.AllControllers(class'PlayerController', PlayerController)
		{
			if (PlayerController != None && PlayerController.MyHUD != None)
			{
				PlayerController.MyHUD.bShowOverlays = true;
				PlayerController.MyHUD.AddPostRenderedActor(Self);
				HasAddedToAllControllers = true;
			}
		}
	}

	Super.Tick(DeltaTime);
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	local int i;

	// Abort if the canvas is invalid, or there is no sequence events to render
	if (Canvas == None || RenderHUDSequenceEvents.Length <= 0)
	{
		return;
	}

	// For each HUD render sequence, propagate the render
	for (i = 0; i < RenderHUDSequenceEvents.Length; ++i)
	{
		if (RenderHUDSequenceEvents[i] != None)
		{
			// Pass the player controller for Kismet
			RenderHUDSequenceEvents[i].PlayerController = PC;
			// Pass the camera position for Kismet
			RenderHUDSequenceEvents[i].CameraPosition = CameraPosition;
			// Pass the camera direction for Kismet
			RenderHUDSequenceEvents[i].CameraDirection = CameraDir;
			// Pass the render call
			RenderHUDSequenceEvents[i].Render(Canvas);
		}
	}
}

defaultproperties
{
	bPostRenderIfNotVisible=true
}