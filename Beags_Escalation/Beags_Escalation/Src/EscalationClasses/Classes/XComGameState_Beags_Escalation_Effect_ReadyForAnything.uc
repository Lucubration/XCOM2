class XComGameState_Beags_Escalation_Effect_ReadyForAnything extends XComGameState_BaseObject;

// This will be set on the unit if they use anything except a damaging attack with the primary/secondary weapon
// during their turn, invalidating Ready for Anything for that turn
var name ReadyForAnythingInvalidName;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Beags Escalation: Ready for Anything 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'PlayerTurnEnded');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Ready for Anything states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Beags Escalation: Ready for Anything passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnPlayerTurnEnded(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory			History;
	local XComGameState_Unit			TargetUnit;
	local UnitValue						UnitValue;
	local StateObjectReference			AbilityRef;
	local XComGameState_Ability			AbilityState;
	local XComGameState					NewGameState;
	local name							CanShootCode;
	local XComGameStateContext_Ability	AbilityContext;
	
	History = `XCOMHISTORY;
	
	// Get or create the target unit
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(UnitRef.ObjectID));
	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	if (TargetUnit == none)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit (unit state not found).");

		return ELR_NoInterrupt;
	}
	
	// If RFA has been invalidated this turn, do nothing
	if (TargetUnit.GetUnitValue(default.ReadyForAnythingInvalidName, UnitValue))
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by end of turn (Ready for Anything invalidated for the turn).");
	
		return ELR_NoInterrupt;
	}

	// Looks like it's time to activate RFA

	// Find Overwatch ability (priority system, here)
	AbilityRef = FindOverwatchAbility(TargetUnit);
	if (AbilityRef.ObjectID == 0)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by end of turn (Overwatch ability ref not found).");

		return ELR_NoInterrupt;
	}

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
	if (AbilityState == none)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by end of turn (Overwatch ability state not found).");

		return ELR_NoInterrupt;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	TargetUnit = XComGameState_Unit(NewGameState.CreateStateObject(TargetUnit.Class, TargetUnit.ObjectID));
	NewGameState.AddStateObject(TargetUnit);

	// Set unit value to prevent Ready for Anything from activating again this turn
	TargetUnit.SetUnitFloatValue(default.ReadyForAnythingInvalidName, 1, eCleanup_BeginTurn);

	// Grant an ability point for the unit
	TargetUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
					
	CanShootCode = AbilityState.CanActivateAbility(TargetUnit);

	if (CanShootCode == 'AA_Success')
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	
		// Activate Overwatch
		AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, TargetUnit.ObjectID);
		if (AbilityContext.Validate())
		{
			`TACTICALRULES.SubmitGameStateContext(AbilityContext);

			`LOG("Beags Escalation: Ready for Anything activated for unit " @ TargetUnit.GetFullName() @ " by end of turn.");
		}
		else
		{
			//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by end of turn (Overwatch ability context not valid).");
		}
	}
	else
	{
		// If the unit can't activate the Overwatch ability, pick up our toys and go home
		History.CleanupPendingGameState(NewGameState);

		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by end of turn (unit cannot activate Overwatch ability: " @ string(CanShootCode) @ ").");
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory			History;
	local XComGameState_Unit			TargetUnit;
	local X2Effect						Effect;
	local XComGameStateContext_Ability	AbilityContext;
	local X2AbilityTemplate				AbilityTemplate;
	local X2AbilityTrigger				AbilityTrigger;
	local X2AbilityTrigger_PlayerInput	PlayerInputTrigger;
	local X2AbilityCost					AbilityCost;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local XComGameState_Item			SourceWeapon;
	local X2EquipmentTemplate			WeaponTemplate;
	local bool							IsPlayerActivated, IsCostly, IsAttack, IsOverwatch;
	local StateObjectReference			AbilityRef;
	local XComGameState_Ability			AbilityState;
	local UnitValue						UnitValue;
	local XComGameState					NewGameState;
	local name							CanShootCode;

	History = `XCOMHISTORY;

	// Get or create the target unit
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(UnitRef.ObjectID));
	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	if (TargetUnit == none)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit (unit state not found).");

		return ELR_NoInterrupt;
	}

	// If RFA has been invalidated this turn, do nothing
	if (TargetUnit.GetUnitValue(default.ReadyForAnythingInvalidName, UnitValue))
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " (Ready for Anything invalidated for the turn).");
	
		return ELR_NoInterrupt;
	}

	// Grab the ability context
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability (ability context not found).");

		return ELR_NoInterrupt;
	}
	
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	if (AbilityTemplate == none)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (ability template not found).");

		return ELR_NoInterrupt;
	}
	
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	if (AbilityState == none)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (ability state not found).");

		return ELR_NoInterrupt;
	}

	// Check if this ability is player-activated
	IsPlayerActivated = false;
	foreach AbilityTemplate.AbilityTriggers(AbilityTrigger)
	{
		PlayerInputTrigger = X2AbilityTrigger_PlayerInput(AbilityTrigger);
		if (PlayerInputTrigger != none)
		{
			IsPlayerActivated = true;
			break;
		}
	}
	if (!IsPlayerActivated)
	{
		// Abilities that are not player-activated do not count towards activation or invalidation of RFA
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (ability is not player-activated).");
			
		return ELR_NoInterrupt;
	}

	// Check if the ability costs action points
	IsCostly = false;
	foreach AbilityTemplate.AbilityCosts(AbilityCost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
		if (ActionPointCost != none && (ActionPointCost.iNumPoints > 0 || ActionPointCost.bConsumeAllPoints || ActionPointCost.bMoveCost) && !ActionPointCost.bFreeCost)
		{
			IsCostly = true;
			break;
		}
	}

	// Check if this ability is a primary or secondary weapon attack
	IsAttack = false;
	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none)
	{
		WeaponTemplate = X2EquipmentTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate != none &&
			(WeaponTemplate.InventorySlot == eInvSlot_PrimaryWeapon || WeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon) &&
			AbilityTemplate.Hostility == eHostility_Offensive)
		{
			IsAttack = true;
		}
	}
	
	// Check if the unit just entered Overwatch (or Suppression)
	IsOverwatch = false;
	foreach AbilityTemplate.AbilityShooterEffects(Effect)
	{
		if (X2Effect_CoveringFire(Effect) != none)
		{
			IsOverwatch = true;
			break;
		}
	}
	if (!IsOverwatch)
	{
		foreach AbilityTemplate.AbilityTargetEffects(Effect)
		{
			if (X2Effect_CoveringFire(Effect) != none || X2Effect_Suppression(Effect) != none)
			{
				IsOverwatch = true;
				break;
			}
		}
	}

	// So. We know some stuff about the ability now; we can make decisions
		
	// First off, making costly non-attacks or entering overwatch will invalidate Ready for Anything for this turn
	if ((IsCostly && !IsAttack) || IsOverwatch)
	{
		// Set unit value to prevent Ready for Anything from activating
		TargetUnit.SetUnitFloatValue(default.ReadyForAnythingInvalidName, 1, eCleanup_BeginTurn);

		//`LOG("Beags Escalation: Ready for Anything invalidated this turn for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ ".");

		return ELR_NoInterrupt;
	}

	// This ability won't invalidate RFA, but will it activate it?

	// Check if the unit is out of action points
	if (TargetUnit.ActionPoints.Length > 0)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (unit did not end turn).");

		return ELR_NoInterrupt;
	}

	// Looks like it's time to activate RFA

	// Find Overwatch ability (priority system, here)
	AbilityRef = FindOverwatchAbility(TargetUnit);
	if (AbilityRef.ObjectID == 0)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (Overwatch ability ref not found).");

		return ELR_NoInterrupt;
	}

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
	if (AbilityState == none)
	{
		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (Overwatch ability state not found).");

		return ELR_NoInterrupt;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	TargetUnit = XComGameState_Unit(NewGameState.CreateStateObject(TargetUnit.Class, TargetUnit.ObjectID));
	NewGameState.AddStateObject(TargetUnit);

	// Set unit value to prevent Ready for Anything from activating again this turn
	TargetUnit.SetUnitFloatValue(default.ReadyForAnythingInvalidName, 1, eCleanup_BeginTurn);

	// Grant an ability point for the unit
	TargetUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
					
	CanShootCode = AbilityState.CanActivateAbility(TargetUnit);

	if (CanShootCode == 'AA_Success')
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	
		// Activate Overwatch
		AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, TargetUnit.ObjectID);
		if (AbilityContext.Validate())
		{
			`TACTICALRULES.SubmitGameStateContext(AbilityContext);

			`LOG("Beags Escalation: Ready for Anything activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ ".");
		}
		else
		{
			//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (Overwatch ability context not valid).");
		}
	}
	else
	{
		// If the unit can't activate the Overwatch ability, pick up our toys and go home
		History.CleanupPendingGameState(NewGameState);

		//`LOG("Beags Escalation: Ready for Anything not activated for unit " @ TargetUnit.GetFullName() @ " by ability " @ AbilityTemplate.DataName @ " (unit cannot activate Overwatch ability: " @ string(CanShootCode) @ ").");
	}

	return ELR_NoInterrupt;
}

function StateObjectReference FindOverwatchAbility(XComGameState_Unit UnitState)
{
	local StateObjectReference AbilityRef;

	AbilityRef = UnitState.FindAbility('LongWatch');
	if (AbilityRef.ObjectID != 0)
		return AbilityRef;

	AbilityRef = UnitState.FindAbility('SniperRifleOverwatch');
	if (AbilityRef.ObjectID != 0)
		return AbilityRef;
	
	AbilityRef = UnitState.FindAbility('Overwatch');
	if (AbilityRef.ObjectID != 0)
		return AbilityRef;
		
	AbilityRef = UnitState.FindAbility('Beags_Escalation_HMGOverwatch');
	if (AbilityRef.ObjectID != 0)
		return AbilityRef;
	
	AbilityRef = UnitState.FindAbility('Beags_Escalation_PistolOverwatch');
	if (AbilityRef.ObjectID != 0)
		return AbilityRef;
	
	return UnitState.FindAbility('PistolOverwatch');
}

DefaultProperties
{
	ReadyForAnythingInvalidName="Beags_Escalation_ReadyForAnythingInvalid"
}
