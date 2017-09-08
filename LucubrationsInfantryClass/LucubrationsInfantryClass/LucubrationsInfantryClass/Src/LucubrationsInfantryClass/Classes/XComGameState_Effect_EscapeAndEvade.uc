// This is the old version of the Escape and Evade effect which procced off of dodges
class XComGameState_Effect_EscapeAndEvade extends XComGameState_BaseObject
	config (LucubrationsInfantryClass);

var name AbilityToActivate;
var name ActionPointName;
var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Lucubration Infantry Class: Escape and Evade 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;

	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Escape and Evade states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Lucubration Infantry Class: Escape and Evade passive effect unregistered from events.");

	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory			History;
	local StateObjectReference			AbilityRef;
	local XComGameStateContext_Ability	AbilityContext, ActiveAbilityContext;
	local XComGameState_Ability			AbilityState, ActiveAbilityState;
	local EAbilityHitResult				TargetHitResult;
	local XComGameState_Unit			Unit;
	local int							i;
	local int							NumMovementTiles;
	local bool							UnitWasTarget;
	local name							CanStealthCode;
	local XComGameState					NewGameState;
	
	//`LOG("Lucubration Infantry Class: Escape and Evade 'AbilityActivated' event listener delegate invoked.");
	
	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
	{
		//`LOG("Lucubration Infantry Class: Escape and Evade not triggered (no ability).");

		return ELR_NoInterrupt;
	}
	
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));	
	if (AbilityState.GetMyTemplate().Hostility != eHostility_Offensive)
	{
		//`LOG("Lucubration Infantry Class: Escape and Evade not triggered due to ability " @ AbilityState.GetMyTemplate().DataName @ " (not an attack).");

		return ELR_NoInterrupt;
	}

	UnitWasTarget = false;

	if (AbilityContext.InputContext.PrimaryTarget.ObjectID == UnitRef.ObjectID)
	{
		// A hostile ability targeted our unit. Grab the hit result value
		TargetHitResult = AbilityContext.ResultContext.HitResult;
		UnitWasTarget = true;
	}

	if (!UnitWasTarget)
	{
		for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; i++)
		{
			if (AbilityContext.InputContext.MultiTargets[i].ObjectID == UnitRef.ObjectID)
			{
				// A hostile multi-target ability targeted our unit. Grab the hit result value
				TargetHitResult = AbilityContext.ResultContext.MultiTargetHitResults[i];
				UnitWasTarget = true;
				break;
			}
		}
	}

	if (!UnitWasTarget)
	{
		//`LOG("Lucubration Infantry Class: Escape and Evade not triggered due to ability " @ AbilityState.GetMyTemplate().DataName @ " (not a target).");

		return ELR_NoInterrupt;
	}
	
	// We found a results set for an ability that targeted us. Check on the result
	if (TargetHitResult != eHit_Graze)
	{
		//`LOG("Lucubration Infantry Class: Escape and Evade not triggered due to ability " @ AbilityState.GetMyTemplate().DataName @ " (not a graze).");

		return ELR_NoInterrupt;
	}

	// Abilities with built-in moves shouldn't be interrupted during movement	
	if (AbilityContext.InputContext.MovementPaths.Length > 0)
	{
		// Determine if all movement has finished for the ability
		for (i = 0; i < AbilityContext.InputContext.MovementPaths.Length; i++)
		{
			NumMovementTiles = Max(NumMovementTiles, AbilityContext.InputContext.MovementPaths[i].MovementTiles.Length);
		}
	
		// Only perform our ability after all movement has finished for the ability
		if (AbilityContext.ResultContext.InterruptionStep < (NumMovementTiles - 1))
		{
			//`LOG("Lucubration Infantry Class: Escape and Evade not triggered due to ability " @ AbilityState.GetMyTemplate().DataName @ " (movement path " @ string(AbilityContext.ResultContext.InterruptionStep) @ "/" @ string(NumMovementTiles - 1) @ ").");
		
			return ELR_NoInterrupt;
		}
	}

	// Grab the unit
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	if (Unit == none)
	{
		//`LOG("Lucubration Infantry Class: Escape and Evade not activated due to ability " @ AbilityState.GetMyTemplate().DataName @ " (no unit).");

		return ELR_NoInterrupt;
	}

	// Get the Escape and Evade active ability from the unit
	foreach Unit.Abilities(AbilityRef)
	{
		ActiveAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
		if (ActiveAbilityState.GetMyTemplateName() == AbilityToActivate)
			break;
		ActiveAbilityState = none;
	}

	if (ActiveAbilityState == none)
	{
		//`LOG("Lucubration Infantry Class: Escape and Evade not activated by unit " @ Unit.GetFullName() @ " due to ability " @ AbilityState.GetMyTemplate().DataName @ " (no stealth ability).");

		return ELR_NoInterrupt;
	}
	
	if (ActionPointName != '')
	{	
		//`LOG("Lucubration Infantry Class: Escape and Evade adding reserved action point to unit " @ Unit.GetFullName() @ ".");

		// Grant an ability point for the shooter
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		Unit = XComGameState_Unit(NewGameState.CreateStateObject(Unit.Class, Unit.ObjectID));
		Unit.ReserveActionPoints.AddItem(ActionPointName);
		NewGameState.AddStateObject(Unit);
	}
		
	CanStealthCode = ActiveAbilityState.CanActivateAbilityForObserverEvent(Unit, Unit);
	if (CanStealthCode != 'AA_Success' && CanStealthCode != 'AA_CannotAfford_ReserveActionPoints')
	{
		// If the unit can't activate stealth, pick up our toys and go home
		History.CleanupPendingGameState(NewGameState);

		//`LOG("Lucubration Infantry Class: Escape and Evade not activated by unit " @ Unit.GetFullName() @ " due to ability " @ AbilityState.GetMyTemplate().DataName @ " (unit can't activate stealth: " @ string(CanStealthCode) @ ").");

		return ELR_NoInterrupt;
	}
	
	`TACTICALRULES.SubmitGameState(NewGameState);
	
	//`LOG("Lucubration Infantry Class: Escape and Evade reserved action point added to unit " @ Unit.GetFullName() @ ".");

	// Perform stealth ability
	ActiveAbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(ActiveAbilityState, Unit.ObjectID);
	if (!ActiveAbilityContext.Validate())
	{
		// Testing always seems to display this message, and yet stealth occurs anyways. I guess it'll do?
		//`LOG("Lucubration Infantry Class: Escape and Evade not activated by unit " @ Unit.GetFullName() @ " due to ability " @ AbilityState.GetMyTemplate().DataName @ " (stealth ability context not valid)?");

		return ELR_NoInterrupt;
	}

	`TACTICALRULES.SubmitGameStateContext(ActiveAbilityContext);

	//`LOG("Lucubration Infantry Class: Escape and Evade activated by unit " @ Unit.GetFullName() @ " due to ability " @ AbilityState.GetMyTemplate().DataName @ ".");

	return ELR_NoInterrupt;
}
