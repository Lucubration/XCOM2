class HUDKismetSeqEvent_RenderHUD extends SequenceEvent;

var Object PlayerController;
var Vector CameraPosition;
var Vector CameraDirection;

event RegisterEvent()
{
	local WorldInfo WorldInfo;
	local HUDKismetRenderProxy RenderProxy, FoundRenderProxy;

	// Get the world info
	WorldInfo = class'WorldInfo'.static.GetWorldInfo();

	// Abort if the world info isn't found
	if (WorldInfo == None)
	{
		return;
	}

	// Find a render proxy to associate with this render HUD event
	ForEach WorldInfo.DynamicActors(class'HUDKismetRenderProxy', FoundRenderProxy)
	{
		RenderProxy = FoundRenderProxy;
		break;
	}

	// If a render proxy hasn't been found, then create a render proxy
	if (RenderProxy == None)
	{
		RenderProxy = WorldInfo.Spawn(class'HUDKismetRenderProxy');
	}

	// Add this HUD render sequence to the rendering proxy
	if (RenderProxy != None)
	{
		RenderProxy.AddRenderHUDSequenceEvent(Self);
	}
}

function Render(Canvas Canvas)
{
	local int i, j;
	local HUDKismetSeqAct_RenderObject RenderObject;

	// Render output links
	if (OutputLinks.Length > 0)
	{
		for (i = 0; i < OutputLinks.Length; ++i)
		{
			if (OutputLinks[i].Links.Length > 0)
			{
				for (j = 0; j < OutputLinks[i].Links.Length; ++j)
				{
					RenderObject = HUDKismetSeqAct_RenderObject(OutputLinks[i].Links[j].LinkedOp);

					if (RenderObject != None)
					{
						RenderObject.Render(Canvas);
					}
				}
			}
		}
	}
}

defaultproperties
{
	ObjName="Render HUD"
	ObjCategory="ExtHUD"

	MaxTriggerCount=0
	bPlayerOnly=false

	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',bHidden=true,LinkDesc="PlayerController",bWriteable=true,PropertyName=PlayerController)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',bHidden=true,LinkDesc="Camera Position",bWriteable=true,PropertyName=CameraPosition)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',bHidden=true,LinkDesc="Camera Direction",bWriteable=true,PropertyName=CameraDirection)
}