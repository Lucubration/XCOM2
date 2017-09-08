//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_InteractOpenClose extends X2Action;

//Cached info for performing the action and the target object
//*************************************
var XComInteractiveLevelActor   Interactor;
var name                        InteractSocketName;
var TTile                       InteractTile;
var AnimNodeSequence			PlayingSequence;
var bool						bWasUsingLOD_TickRate;
//*************************************

function Init()
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;

	super.Init();
	AbilityContext = XComGameStateContext_Ability(StateChangeContext);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	`assert(UnitState != none);

	Interactor = XComInteractiveLevelActor(Metadata.VisualizeActor);

	GetInteractionInformation();
}

private function GetInteractionInformation()
{
	local array<XComInteractPoint> InteractionPoints;
	local XComWorldData World;
	local Vector UnitLocation;
	

	World = class'XComWorldData'.static.GetWorldData();

	UnitLocation = UnitPawn.Location;
	UnitLocation.Z = World.GetFloorZForPosition(UnitLocation) + class'XComWorldData'.const.Cover_BufferDistance;
	World.GetInteractionPoints(UnitLocation, 8.0f, 90.0f, InteractionPoints);
	if (InteractionPoints.Length > 0)
	{		
		InteractSocketName = InteractionPoints[0].InteractSocketName;
	}
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
Begin:
	bWasUsingLOD_TickRate = Interactor.LOD_TickRate > 0.0f; //Record whether this interactive level actor is using a reduced tick rate before we animate it

	// Play animations
	FinishAnim(Interactor.PlayAnimations(Unit, InteractSocketName));

	Interactor.AnimNode.SetActiveChild(0, 1.0f);
	
	Sleep(1.0f * GetDelayModifier());

	if (bWasUsingLOD_TickRate)
	{
		//Put it back to the low freq tick now that it is done animating
		Interactor.LOD_TickRate = 1.0f; 
	}

	CompleteAction();
}

defaultproperties
{
}

