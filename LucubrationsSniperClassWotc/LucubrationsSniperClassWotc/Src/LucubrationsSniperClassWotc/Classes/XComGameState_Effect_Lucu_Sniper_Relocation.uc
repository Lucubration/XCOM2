class XComGameState_Effect_Lucu_Sniper_Relocation extends XComGameState_BaseObject;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;

	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Relocation states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Lucubration Sniper Class: Relocation passive effect unregistered from events.");

	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState, TargetUnit;
	local StateObjectReference ActiveAbilityRef;
	local XComGameState_Ability ActiveAbilityState;
	local XComGameStateContext_Ability ActiveAbilityContext;
	local XComGameState NewGameState;
	local UnitValue Value;
	local int Check, i;
	local bool Grant;
	
	History = `XCOMHISTORY;
	
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
		return ELR_NoInterrupt;
	
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	if (AbilityTemplate == none)
		return ELR_NoInterrupt;
	
	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState == none || AbilityState.ObjectID == 0)
		return ELR_NoInterrupt;

	if (AbilityContext.InputContext.SourceObject.ObjectID != UnitRef.ObjectID)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (UnitState == none)
		return ELR_NoInterrupt;

	// Only during the controlling player's turn
	if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID != UnitState.ControllingPlayer.ObjectID)
		return ELR_NoInterrupt;

	// Applies to offensive abilities only
	if (AbilityTemplate.Hostility != eHostility_Offensive || !AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState))
		return ELR_NoInterrupt;

	// Check if we've already granted enough Relocation action points this turn
	if (UnitState.GetUnitValue(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.RelocationName, Value))
		Check = Value.fValue;
	else
		Check = 0;

	if (Check >= class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.RelocationGrants)
		return ELR_NoInterrupt;

	// Check if the primary target was hit
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (AbilityContext.IsResultContextHit())
	{
		if (TargetUnit != none && TargetUnit.ObjectID > 0)
		{
			Grant = true;
		}
	}

	if (!Grant && AbilityContext.InputContext.MultiTargets.Length > 0)
	{
		for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; i++)
		{
			// Check if any multi-targets were hit
			if (AbilityContext.IsResultContextMultiHit(i))
			{
				TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i].ObjectID));
				if (TargetUnit != none && TargetUnit.ObjectID > 0)
				{
					Grant = true;
					break;
				}
			}
		}
	}

	if (Grant)
	{
		// Add the relocation action point
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
		
		// Update the grants for this turn
		UnitState.SetUnitFloatValue(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.RelocationName, Check + 1, eCleanup_BeginTurn);
		NewGameState.AddStateObject(UnitState);
		
		`TACTICALRULES.SubmitGameState(NewGameState);

		// Get the Relocation active ability from the unit
		ActiveAbilityRef = UnitState.FindAbility(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.RelocationActiveAbilityName);
		if (ActiveAbilityRef.ObjectID <= 0)
			return ELR_NoInterrupt;

		ActiveAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ActiveAbilityRef.ObjectID));
		if (ActiveAbilityState == none)
			return ELR_NoInterrupt;

		// Apply the Relocation active effect to the unit
		ActiveAbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(ActiveAbilityState, UnitState.ObjectID);
		if (!ActiveAbilityContext.Validate())
			return ELR_NoInterrupt;

		`TACTICALRULES.SubmitGameStateContext(ActiveAbilityContext);

		`LOG("Lucubration Sniper Class: Relocation triggered for unit " @ UnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ ".");
	}

	return ELR_NoInterrupt;
}
