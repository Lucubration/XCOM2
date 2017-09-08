class PA_ParthenoEffect extends X2Effect_ParthenogenicPoison;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameStateHistory History;
	local XComHumanPawn HumanPawn;

	`log("davea debug partheno enter");
	History = `XCOMHISTORY;
	TargetUnit = XComGameState_Unit(kNewTargetState);
	`assert(TargetUnit != none);
	// do not force human pawn since advent unit is probably target
	UnitToSpawnName = 'ChryssalidCocoonHuman';

	if (TargetUnit != none && !TargetUnit.IsAlive())
	{
		// The target died from the ability attaching this effect
		// The cocoon spawn should happen now
		`log("davea debug partheno middle");
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}
	`log("davea debug partheno bottom");
}

function ETeam GetTeam(const out EffectAppliedData ApplyEffectParameters)
{
	return GetSourceUnitsTeam(ApplyEffectParameters);
}

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState)
{
	local XComGameState_Unit DeadUnitGameState, NewUnitGameState;
	local bool bAddDeadUnit;
	local X2EventManager EventManager;
	local XComUnitPawn PawnVisualizer;

	`log("davea debug onspawn enter");
	EventManager = `XEVENTMGR;

	bAddDeadUnit = false;
	DeadUnitGameState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( DeadUnitGameState == none)
	{
		bAddDeadUnit = true;
		DeadUnitGameState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	}
	`assert(DeadUnitGameState != none);

	NewUnitGameState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));
	`assert(NewUnitGameState != none);

	// The Dead unit's Loot is lost
	DeadUnitGameState.bBodyRecovered = false;

	DeadUnitGameState.RemoveUnitFromPlay();

	if( bAddDeadUnit )
	{
		NewGameState.AddStateObject(DeadUnitGameState);
	}

	// Record the DeadUnitGameState's ID so the cocoon knows who spawned it
	NewUnitGameState.m_SpawnedCocoonRef = DeadUnitGameState.GetReference();

	PawnVisualizer = XGUnit(NewUnitGameState.GetVisualizer()).GetPawn();
	PawnVisualizer.RagdollFlag = eRagdoll_Never;

	// Remove the dead unit from play
	EventManager.TriggerEvent('UnitRemovedFromPlay', DeadUnitGameState, DeadUnitGameState, NewGameState);

	EventManager.TriggerEvent(default.ParthenogenicPoisonCocoonSpawnedName, NewUnitGameState, NewUnitGameState);
	`log("davea debug onspawn bottom");
}


