class XComGameState_Beags_Escalation_Effect_FireSuperiority extends XComGameState_BaseObject;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Beags Escalation: Fire Superiority 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Fire Superiority states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Beags Escalation: Fire Superiority passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit PrimaryTargetUnitState, SourceUnitState, UnitState;
	local XComGameState_Ability AbilityState;
	local StateObjectReference ActiveAbilityRef;
	local XComGameState_Ability ActiveAbilityState;
	local XComGameStateContext_Ability ActiveAbilityContext;
	local XComGameState NewGameState;
	local name CanShootCode;
	
	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		//`LOG("Beags Escalation: Fire Superiority not triggered (wrong interruption status).");
		return ELR_NoInterrupt;
	}

	// Check if the source object is an enemy shooting at a nearby friendly target
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	if (UnitState == none)
	{
		//`LOG("Beags Escalation: Fire Superiority not triggered (unit state not found).");
		return ELR_NoInterrupt;
	}

	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (SourceUnitState == none || !SourceUnitState.IsEnemyUnit(UnitState))
	{
		//`LOG("Beags Escalation: Fire Superiority not triggered for unit " @ UnitState.GetFullName() @ " (missing or invalid source unit).");
		return ELR_NoInterrupt;
	}

	PrimaryTargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (PrimaryTargetUnitState == none || !PrimaryTargetUnitState.IsFriendlyUnit(UnitState) || PrimaryTargetUnitState.TileDistanceBetween(UnitState) > class'X2Ability_Beags_Escalation_GunnerAbilitySet'.default.FireSuperiorityReturnFireRadius)
	{
		//`LOG("Beags Escalation: Fire Superiority not triggered for unit " @ UnitState.GetFullName() @ " (missing or invalid primary target unit).");
		return ELR_NoInterrupt;
	}

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	if (AbilityState == none || AbilityState.GetMyTemplate().Hostility != eHostility_Offensive)
	{
		//`LOG("Beags Escalation: Fire Superiority not triggered for unit " @ UnitState.GetFullName() @ " (missing or invalid ability).");
		return ELR_NoInterrupt;
	}
	
	// Get the Overwatch Shot ability from the shooter unit
	ActiveAbilityRef = UnitState.FindAbility('OverwatchShot');
	if (ActiveAbilityRef.ObjectID <= 0)
	{
		//`LOG("Beags Escalation: Fire Superiority not triggered for unit " @ UnitState.GetFullName() @ " (reaction fire ability ref not found).");
		return ELR_NoInterrupt;
	}

	ActiveAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ActiveAbilityRef.ObjectID));
	if (ActiveAbilityState == none)
	{
		//`LOG("Beags Escalation: Fire Superiority not triggered for unit " @ UnitState.GetFullName() @ " (reaction fire ability state not found).");
		return ELR_NoInterrupt;
	}
	
	// Grant an overwatch action point
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
	UnitState.ReserveActionPoints.AddItem(class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint);
	NewGameState.AddStateObject(UnitState);
	
	CanShootCode = ActiveAbilityState.CanActivateAbilityForObserverEvent(SourceUnitState, UnitState);
	if (CanShootCode != 'AA_Success')
	{
		// If the shooter can't fire at the target, pick up our toys and go home
		History.CleanupPendingGameState(NewGameState);

		//`LOG("Beags Escalation: Fire Superiority not activated by unit " @ UnitState.GetFullName() @ " against unit " @ SourceUnitState.GetFullName() @ " (can't fire at this unit: " @ string(CanShootCode) @ ").");

		return ELR_NoInterrupt;
	}

	`TACTICALRULES.SubmitGameState(NewGameState);
	
	//`LOG("Beags Escalation: Fire Superiority reserved action point added to unit " @ UnitState.GetFullName() @ ".");
	
	// Perform reaction fire against the target
	ActiveAbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(ActiveAbilityState, UnitState.ObjectID);
	if (!ActiveAbilityContext.Validate())
	{
		// Testing always seems to display this message, but the movement observer triggers pistol overwatch anyways. I guess it'll do?
		//`LOG("Beags Escalation: Fire Superiority not activated by unit " @ UnitState.GetFullName() @ " against unit " @ SourceUnitState.GetFullName() @ " (reaction fire ability context not valid)?");

		return ELR_NoInterrupt;
	}

	`TACTICALRULES.SubmitGameStateContext(ActiveAbilityContext);

	`LOG("Beags Escalation: Fire Superiority triggered for unit " @ UnitState.GetFullName() @ ".");

	return ELR_NoInterrupt;
}
