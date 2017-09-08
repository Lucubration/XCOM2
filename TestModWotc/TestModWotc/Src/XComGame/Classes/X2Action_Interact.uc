//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Interact extends X2Action;

//Cached info for performing the action
//*************************************
var XComInteractiveLevelActor   Interactor;
var name                        InteractSocketName;
var XComGameState_Unit          UnitState;

var StateObjectReference InteractorObjectReference;
var int							InteractedObjectID;
var bool						bWasUsingLOD_TickRate;
//*************************************

function Init()
{
	local XComGameStateContext_Ability AbilityContext;

	super.Init();
	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
	InteractedObjectID = AbilityContext.InputContext.PrimaryTarget.ObjectID;

	UnitState = XComGameState_Unit( AbilityContext.AssociatedState.GetGameStateForObjectID( AbilityContext.InputContext.SourceObject.ObjectID ) );
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit( `XCOMHISTORY.GetGameStateForObjectID( AbilityContext.InputContext.SourceObject.ObjectID, , AbilityContext.AssociatedState.HistoryIndex ) );
	}
	`assert(UnitState != none);

	GetInteractionInformation();
}

private function GetInteractionInformation()
{
	local array<XComInteractPoint> InteractionPoints;
	local XComWorldData World;
	local Vector UnitLocation;
	local int Index;
	local int InteractionPointsIndex;
	InteractionPointsIndex = 0;

	World = class'XComWorldData'.static.GetWorldData();

	UnitLocation = World.GetPositionFromTileCoordinates(UnitState.TileLocation);
	World.GetInteractionPoints(UnitLocation, 8.0f, 90.0f, InteractionPoints);

	//Intentionally did it this way to retain original code logic, if there's no InteractedObjectID found it defaults to 0 Chang You Wong 2015-7-28
	for(Index = 0; Index < InteractionPoints.Length; ++Index)
	{
		if( InteractionPoints[Index].InteractiveActor.ObjectID == InteractedObjectID )
		{
			InteractionPointsIndex = Index;
		}
	}

	if (InteractionPoints.Length > 0)
	{
		Interactor = InteractionPoints[InteractionPointsIndex].InteractiveActor;
		InteractSocketName = InteractionPoints[InteractionPointsIndex].InteractSocketName;

		if (Interactor != none)
		{
			InteractorObjectReference = `XCOMHISTORY.GetGameStateForObjectID(Interactor.ObjectID).GetReference();
		}
	}
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{
	local AnimNotify_KickDoor KickDoorNotify;

	super.OnAnimNotify(ReceiveNotify);

	//Send kick door notification to doors
	if (Interactor != none && Interactor.IsDoor())
	{
		KickDoorNotify = AnimNotify_KickDoor(ReceiveNotify);
		if (KickDoorNotify != none && InteractorObjectReference.ObjectID > 0)
		{
			`XEVENTMGR.TriggerEvent('Visualizer_KickDoor', Interactor, self);			
		}
	}
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function UpdateInteractCover(XComInteractiveLevelActor InteractiveActor)
	{
		`XWORLD.RefreshActorTileData(InteractiveActor);
	}

Begin:
	// make sure we still have the interactive actor. If the actor was destroyed as part of opening the door (such
	// as a revealed gatekeeper smashing through the door and destroying it), the actor will no longer exist in
	// the world data. This is a super edge case, but better to catch it and not crash, even if it does look a bit
	// strange to not have him open the door before the reveal.
	if(Interactor != none)
	{
		bWasUsingLOD_TickRate = Interactor.LOD_TickRate > 0.0f;

		Interactor.BeginInteraction(Unit, InteractSocketName);
		if(Interactor.bUseRMATranslation || Interactor.bUseRMARotation)
		{
			UnitPawn.EnableRMA(Interactor.bUseRMATranslation, Interactor.bUseRMARotation);
			UnitPawn.EnableRMAInteractPhysics(true);
		}

		// Play animations
		FinishAnim(Interactor.PlayAnimations(Unit, InteractSocketName)); 

		if(Interactor.bUseRMATranslation || Interactor.bUseRMARotation)
		{
			UnitPawn.EnableRMA(true,true);
			UnitPawn.EnableRMAInteractPhysics(true);
		}
		// Finish interaction and refresh interact icon for the current unit
		Interactor.EndInteraction(Unit, InteractSocketName);	

		// Wait for interaction to finish
		while (Interactor.IsAnimating())
		{
			Sleep(0.1f);
		}
	
		if( Interactor.bTouchActivated )
		{
			Interactor.bWasTouchActivated = true;
		}

		if (bWasUsingLOD_TickRate)
		{
			Interactor.LOD_TickRate = 1.0f; //Put it back to the low freq tick now that it is done animating
		}

		// force an update of the objective tiles in case this interaction caused them to no longer be needed
		XComTacticalController(GetALocalPlayerController()).m_kPathingPawn.UpdateObjectiveTiles(UnitState);

		UpdateInteractCover(Interactor);
	}

	CompleteAction();
}

defaultproperties
{
	OutputEventIDs.Add( "Visualizer_Interact" )
}

