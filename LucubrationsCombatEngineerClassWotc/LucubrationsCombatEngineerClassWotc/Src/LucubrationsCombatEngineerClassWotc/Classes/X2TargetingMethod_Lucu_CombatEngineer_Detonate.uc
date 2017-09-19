class X2TargetingMethod_Lucu_CombatEngineer_Detonate extends X2TargetingMethod;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	super.Init(InAction, NewTargetIndex);
    
	// Make sure we have targets of some kind.
	`assert(Action.AvailableTargets.Length > 0);

	ShowDamagePreview();
    AddTargetingCamera();

	UpdatePostProcessEffects(true);
}

function Canceled()
{
	super.Canceled();

	ClearTargetedActors();
	RemoveTargetingCamera();

	FiringUnit.IdleStateMachine.bTargeting = false;

	UpdatePostProcessEffects(false);
}

function Committed()
{
    super.Canceled();

	ClearTargetedActors();
	RemoveTargetingCamera();

	UpdatePostProcessEffects(false);
}

function int GetTargetIndex()
{
	return 0;
}

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
    AdditionalTargets = Action.AvailableTargets[0];
	return true;
}

function Update(float DeltaTime);

function ShowDamagePreview()
{
	local XComGameStateHistory History;
    local AvailableTarget Target;
    local StateObjectReference AdditionalTarget;
    local Actor TargetActor;
	local XComDestructibleActor Destructible;
    local array<TTile> Tiles;
    local array<TTile> AllTiles;
    local TTile Tile;
	local array<Actor> CurrentlyMarkedTargets;
    
	History = `XCOMHISTORY;

    foreach Action.AvailableTargets(Target)
    {
        foreach Target.AdditionalTargets(AdditionalTarget)
        {
            TargetActor = History.GetVisualizer(AdditionalTarget.ObjectID);
            if (TargetActor != none)
            {
	            Destructible = XComDestructibleActor(TargetActor);
	            if (Destructible != none)
	            {
		            Destructible.GetRadialDamageTiles(Tiles);
                    foreach Tiles(Tile)
                    {
                        AllTiles.AddItem(Tile);
                    }
	            }
            }
        }
    }
    
	if (Tiles.Length > 1)
	{
		GetTargetedActorsInTiles(AllTiles, CurrentlyMarkedTargets, false);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);
		MarkTargetedActors(CurrentlyMarkedTargets, eTeam_None);
		DrawAOETiles(AllTiles);
		AOEMeshActor.SetHidden(false);
	}
	else
	{
		ClearTargetedActors();
		AOEMeshActor.SetHidden(true);
	}
}

function AddTargetingCamera()
{
	local XComGameStateHistory History;
	local X2Camera_Midpoint MidpointCamera;
    local AvailableTarget Target;
    local StateObjectReference AdditionalTarget;
    local Actor TargetActor;
    
	History = `XCOMHISTORY;

	if (FiringUnit.TargetingCamera != None)
	{
		if (X2Camera_Midpoint(FiringUnit.TargetingCamera) == None)
		{
			RemoveTargetingCamera();
		}
	}

	FiringUnit.TargetingCamera = new class'X2Camera_Midpoint';

	MidpointCamera = X2Camera_Midpoint(FiringUnit.TargetingCamera);
	MidpointCamera.TargetActor = FiringUnit;
	MidpointCamera.ClearFocusActors();
    MidpointCamera.AddFocusActor(FiringUnit);
    foreach Action.AvailableTargets(Target)
    {
        foreach Target.AdditionalTargets(AdditionalTarget)
        {
            TargetActor = History.GetVisualizer(AdditionalTarget.ObjectID);
            if (TargetActor != none)
            {
	            MidpointCamera.AddFocusActor(TargetActor);
            }
        }
    }

	`CAMERASTACK.AddCamera(FiringUnit.TargetingCamera);

	MidpointCamera.RecomputeLookatPointAndZoom(false);
}

private function RemoveTargetingCamera()
{
	if( FiringUnit.TargetingCamera != none )
	{
		`CAMERASTACK.RemoveCamera(FiringUnit.TargetingCamera);
		FiringUnit.TargetingCamera = none;
	}
}
