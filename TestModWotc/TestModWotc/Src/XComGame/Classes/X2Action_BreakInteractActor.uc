//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_BreakInteractActor extends X2Action;

//Cached info for performing the action and the target object
//*************************************
var XComInteractiveLevelActor   Interactor;
var name                        InteractSocketName;
var TTile                       InteractTile;
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

	//Typically, this action will be on the track of the door/etc that's getting hit.
	//We want the UnitPawn that's doing the breaking in that case.
	if (UnitPawn == None)
	{
		Unit = XGUnit(UnitState.GetVisualizer());
		UnitPawn = Unit.GetPawn();
	}

	GetInteractionInformation();
}

private function GetInteractionInformation()
{
	local array<XComInteractPoint> InteractionPoints;
	local XComWorldData World;
	local Vector UnitLocation;	
	local Vector SocketLocation;

	World = class'XComWorldData'.static.GetWorldData();

	UnitLocation = UnitPawn.Location;
	UnitLocation.Z = World.GetFloorZForPosition(UnitLocation) + class'XComWorldData'.const.Cover_BufferDistance;
	World.GetInteractionPoints(UnitLocation, 8.0f, 90.0f, InteractionPoints);
	if (InteractionPoints.Length > 0)
	{		
		InteractSocketName = InteractionPoints[0].InteractSocketName;
	}
	else
	{
		Interactor.GetClosestSocket(UnitLocation, InteractSocketName, SocketLocation);
	}
}

//Important note here - AllowEvent in some cases will be used to start up an action. In this situation Init() will not have run, so cached values
//from Init cannot be used.
function bool AllowEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComInteractiveLevelActor InteractActor;
	
	//Verify that this kick door event is for us
	if (EventID == 'Visualizer_KickDoor' || EventID == 'Visualizer_ProjectileHit')
	{
		InteractActor = XComInteractiveLevelActor(EventData);
		return InteractActor == Metadata.VisualizeActor;
	}
	
	return super.AllowEvent(EventData, EventSource, GameState, EventID, CallbackData);
}

//Under the current setup, break actions are added after the path has been parsed. So, this code assumes that the 
//move nodes being considered have had their path parameters set
event int ScoreNodeForTreePlacement(X2Action PossibleParent)
{
	local int Score;
	local X2Action_MoveTurn MoveTurn;	
	local X2Action_PlayAnimation PlayAnimation;
	local XComInteractiveLevelActor InteractiveLevelActor;

	Score += class'X2Action'.static.CheckMoveActionForMatch(PossibleParent, Metadata);
	
	//Special check for sliding doors. These should open at a very specific time in the move sequence.
	InteractiveLevelActor = XComInteractiveLevelActor(Metadata.VisualizeActor);
	if (InteractiveLevelActor != none && InteractiveLevelActor.IsDoor() && !InteractiveLevelActor.HasDestroyAnim())
	{
		MoveTurn = X2Action_MoveTurn(PossibleParent);
		if (MoveTurn != none && MoveTurn.ChildActions.Length > 0)
		{
			PlayAnimation = X2Action_PlayAnimation(MoveTurn.ChildActions[0]);
			if (PlayAnimation != none && PlayAnimation.Params.AnimName == 'NO_IdleGunDwnA' )
			{
				Score += 200;
			}
		}
	}

	return Score;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
Begin:
	// Play animations
	Interactor.BreakInteractActor(InteractSocketName);

	Sleep(0.1f); // force a tick, to allow blends to start

	// Wait for interaction to finish
	while(Interactor.IsAnimating())
	{
		if(Interactor.IsInState('_Destroyed') || Interactor.IsInState('Dead') || Interactor.IsInState('_DestructionStarted'))
		{
			break; //Exit if this actor is destroyed. There should be no anim to play in this case
		}
		Sleep(0.1f);
	}
	
	CompleteAction();
}

defaultproperties
{
	InputEventIDs.Add( "Visualizer_ProjectileHit" )	//Signal we'll get when being hit by projectiles
	InputEventIDs.Add( "Visualizer_Interact" )		//If we are interacted with normally
	InputEventIDs.Add( "Visualizer_KickDoor" )		//Get door kick notifies from movement actions
	OutputEventIDs.Add( "Visualizer_WorldDamage" )	//World damage application
	bCauseTimeDilationWhenInterrupting = true
}

