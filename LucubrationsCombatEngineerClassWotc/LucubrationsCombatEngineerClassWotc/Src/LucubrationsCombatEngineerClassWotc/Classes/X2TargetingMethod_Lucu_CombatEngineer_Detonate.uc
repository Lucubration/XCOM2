class X2TargetingMethod_Lucu_CombatEngineer_Detonate extends X2TargetingMethod_TopDown;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	super.Init(InAction, NewTargetIndex);

	ShowDamagePreview();

	UpdatePostProcessEffects(true);
}

function Canceled()
{
	super.Canceled();

	ClearTargetedActors();

	FiringUnit.IdleStateMachine.bTargeting = false;

	UpdatePostProcessEffects(false);
}

function Committed()
{
    super.Canceled();

	ClearTargetedActors();

	UpdatePostProcessEffects(false);
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
        // TODO: Figure out why we don't get destructibles in our final actors list
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
