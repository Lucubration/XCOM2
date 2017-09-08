class X2TargetingMethod_RemoteStart extends X2TargetingMethod;

var private X2Camera_LookAtActor LookatCamera;
var private int LastTarget;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	super.Init(InAction, NewTargetIndex);

	// make sure this ability has a target
	`assert(InAction.AvailableTargets.Length > 0);

	LookatCamera = new class'X2Camera_LookAtActor';
	LookatCamera.UseTether = false;
	LookatCamera.SnapToFloor = false;
	`CAMERASTACK.AddCamera(LookatCamera);

	DirectSetTarget(0);
}

function Canceled()
{
	super.Canceled();
	`CAMERASTACK.RemoveCamera(LookatCamera);
	ClearTargetedActors();
}

function Committed()
{
	Canceled();
}

function Update(float DeltaTime);

function NextTarget()
{
	DirectSetTarget(LastTarget + 1);
}

function PrevTarget()
{
	if(LastTarget > 0)
	{
		DirectSetTarget(LastTarget - 1);
	}
	else
	{
		DirectSetTarget(Action.AvailableTargets.Length - 1);
	}
}

function int GetTargetIndex()
{
	return LastTarget;
}

function DirectSetTarget(int TargetIndex)
{
	local XComPresentationLayer Pres;
	local UITacticalHUD TacticalHud;
	local Actor TargetedActor;
	local array<TTile> Tiles;
	local TTile TargetedActorTile;
	local XGUnit TargetedPawn;
	local vector TargetedLocation;
	local XComWorldData World;
	local array<Actor> CurrentlyMarkedTargets;

	World = `XWORLD;

	// advance the target counter
	LastTarget = TargetIndex % Action.AvailableTargets.Length;

	// put the targeting reticle on the new target
	Pres = `PRES;
		TacticalHud = Pres.GetTacticalHUD();
	TacticalHud.TargetEnemy(GetTargetedObjectID());

	// have the idle state machine look at the new target
	FiringUnit.IdleStateMachine.CheckForStanceUpdate();

	// have the camera look at the new target (or the source unit if no target is available)
	TargetedActor = GetTargetedActor();
	if (TargetedActor != none)
	{
		LookatCamera.ActorToFollow = TargetedActor;
	}
	else
	{
		LookatCamera.ActorToFollow = FiringUnit;
	}

	TargetedPawn = XGUnit(TargetedActor);
	if (TargetedPawn != none)
	{
		TargetedLocation = TargetedPawn.GetFootLocation();
		TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
		TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);
	}
	else
	{
		TargetedLocation = TargetedActor.Location;
	}
	X2AbilityTarget_RemoteStart( Ability.GetMyTemplate().AbilityTargetStyle ).GetValidTilesForActor(Ability, TargetedActor, Tiles);

	GetTargetedActorsInTiles(Tiles, CurrentlyMarkedTargets);
	CheckForFriendlyUnit(CurrentlyMarkedTargets);
	MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None);
	DrawAOETiles(Tiles);
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
	local Actor TargetedActor;
	local X2VisualizerInterface TargetVisualizer;

	TargetedActor = GetTargetedActor();

	if (TargetedActor != none)
	{
		TargetVisualizer = X2VisualizerInterface(TargetedActor);
		if (TargetVisualizer != None)
		{
			Focus = TargetVisualizer.GetTargetingFocusLocation();
		}
		else
		{
			Focus = TargetedActor.Location;
		}

		return true;
	}

	return false;
}