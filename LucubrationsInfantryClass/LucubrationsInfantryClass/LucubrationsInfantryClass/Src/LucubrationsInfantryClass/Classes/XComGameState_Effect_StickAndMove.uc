class XComGameState_Effect_StickAndMove extends XComGameState_BaseObject
	config (LucubrationsInfantryClass);
	
var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Lucubration Infantry Class: Stick and Move 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;

	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'UnitMoveFinished');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Stick and Move states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Lucubration Infantry Class: Stick and Move passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState, ApplyAbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local XComGameState_Item SourceWeaponState;
	local X2EquipmentTemplate SourceWeaponTemplate;
	local StateObjectReference CompareEffectRef;
	local XComGameState_Effect CompareEffectState;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local XComGameState NewGameState;
	local name ApplyAbilityName, ApplyEffectName, RemoveEffectName;
	local StateObjectReference AbilityRef;
	local bool IsAlreadyAffected, IsAbilityPostActivation;
	local int i;
	
	History = `XCOMHISTORY;
	
	//`LOG("Lucubration Infantry Class: Stick and Move 'AbilityActivated' event listener delegate invoked.");

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated (no ability context).");
		return ELR_NoInterrupt;
	}
	
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	if (AbilityTemplate == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (no ability template).");
		return ELR_NoInterrupt;
	}
	
	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (no ability state).");
		return ELR_NoInterrupt;
	}

	if (AbilityContext.InputContext.SourceObject.ObjectID != UnitRef.ObjectID)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (not Stick and Move unit).");
		return ELR_NoInterrupt;
	}

	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (UnitState == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (no unit).");
		return ELR_NoInterrupt;
	}

	// Check the type of ability
	RemoveEffectName = '';
	if (AbilityTemplate.Hostility == eHostility_Offensive)
	{
		// Offensive abilities apply the mobility effect
		ApplyAbilityName = class'X2Ability_InfantryAbilitySet'.default.StickAndMoveMobilityAbilityName;
		ApplyEffectName = class'X2Ability_InfantryAbilitySet'.default.StickAndMoveMobilityEffectName;

		// If this is the post-activation, we check the source weapon to see if we're going to remove the damage bonus.
		// To determine if it's post-activation, check for any effect apply results
		IsAbilityPostActivation = false;
		if (AbilityContext.ResultContext.TargetEffectResults.ApplyResults.Length > 0)
			IsAbilityPostActivation = true;
		else
		{
			for (i = 0; i < AbilityContext.ResultContext.MultiTargetEffectResults.Length; i++)
			{
				if (AbilityContext.ResultContext.MultiTargetEffectResults[i].ApplyResults.Length > 0)
				{
					IsAbilityPostActivation = true;
					break;
				}
			}
		}

		// If it's post-activation, check the weapon type
		if (IsAbilityPostActivation)
		{
			//`LOG("Lucubration Infantry Class: Stick and Move ability " @ string(AbilityTemplate.DataName) @ " is post-activation.");

			SourceWeaponState = AbilityState.GetSourceWeapon();
			SourceWeaponTemplate = X2EquipmentTemplate(SourceWeaponState.GetMyTemplate());
			if (SourceWeaponTemplate.InventorySlot == eInvSlot_PrimaryWeapon ||
				SourceWeaponTemplate.InventorySlot == eInvSlot_SecondaryWeapon)
			{
				// It's a primary weapon or secondary weapon ability; try to remove the damage bonus
				RemoveEffectName = class'X2Ability_InfantryAbilitySet'.default.StickAndMoveDamageEffectName;
			}
		}
		else
		{
			//`LOG("Lucubration Infantry Class: Stick and Move ability " @ string(AbilityTemplate.DataName) @ " is not post-activation.");
		}
	}
	else if (AbilityContext.InputContext.MovementPaths.Length > 0)
	{
		// Abilities with a movement component apply the damage effect
		ApplyAbilityName = class'X2Ability_InfantryAbilitySet'.default.StickAndMoveDamageAbilityName;
		ApplyEffectName = class'X2Ability_InfantryAbilitySet'.default.StickAndMoveDamageEffectName;
	}
	else
	{
		// Other abilities are not relevant
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (not attack or movement ability).");
		
		return ELR_NoInterrupt;
	}
	
	// Check to see if the unit already has the effect that we're looking to apply
	IsAlreadyAffected = false;
	foreach UnitState.AffectedByEffects(CompareEffectRef)
	{
		CompareEffectState = XComGameState_Effect(History.GetGameStateForObjectID(CompareEffectRef.ObjectID));

		if (CompareEffectState.GetX2Effect().EffectName == ApplyEffectName)
		{
			// We're already affected by the effect
			IsAlreadyAffected = true;
		}

		if (RemoveEffectName != '' && CompareEffectState.GetX2Effect().EffectName == RemoveEffectName)
		{
			// Found the damage bonus effect; now remove it
			EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(CompareEffectState);
			NewGameState = History.CreateNewGameState(true, EffectRemovedState);
			CompareEffectState.RemoveEffect(NewGameState, GameState);

			if( NewGameState.GetNumGameStateObjects() > 0 )
			{
				`TACTICALRULES.SubmitGameState(NewGameState);
			}
			else
			{
				History.CleanupPendingGameState(NewGameState);
			}

			//`LOG("Lucubration Infantry Class: Stick and Move damage effect removed by ability " @ string(AbilityTemplate.DataName) @ ".");
		}
	}

	if (IsAlreadyAffected)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (Stick and Move effect " @ ApplyAbilityName @ " already active for unit).");

		return ELR_NoInterrupt;
	}

	// Get the Stick and Move active ability from the source unit
	foreach UnitState.Abilities(AbilityRef)
	{
		ApplyAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
		if (ApplyAbilityState.GetMyTemplateName() == ApplyAbilityName)
			break;
		ApplyAbilityState = none;
	}

	if (ApplyAbilityState == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (no Stick and Move active ability).");
		return ELR_NoInterrupt;
	}
	
	ApplyAbilityState.AbilityTriggerAgainstSingleTarget(UnitState.GetReference(), false, GameState.HistoryIndex);
	
	//`LOG("Lucubration Infantry Class: Stick and Move effect " @ ApplyAbilityName @ " activated by ability " @ string(AbilityTemplate.DataName));

	return ELR_NoInterrupt;
}

function EventListenerReturn OnUnitMoveFinished(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateContext_Ability AbilityContext;
	local StateObjectReference CompareEffectRef;
	local XComGameState_Effect CompareEffectState;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local XComGameState NewGameState;
	
	//`LOG("Lucubration Infantry Class: Stick and Move 'UnitMoveFinished' event listener delegate invoked.");
	
	History = `XCOMHISTORY;

	// Get the unit
	UnitState = XComGameState_Unit(EventData);
	if (UnitState == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move target not removed (no target).");

		return ELR_NoInterrupt;
	}
	
	// Get the ability related to the moving
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated (no ability context).");

		return ELR_NoInterrupt;
	}
	
	// Get the ability template
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	if (AbilityTemplate == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(AbilityTemplate.DataName) @ " (no ability template).");

		return ELR_NoInterrupt;
	}

	// Make sure an actual move was taken
	if (AbilityContext.InputContext.MovementPaths.Length == 0)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move target not removed (no movement path).");

		return ELR_NoInterrupt;
	}
	
	// Look for the mobility effect
	foreach UnitState.AffectedByEffects(CompareEffectRef)
	{
		CompareEffectState = XComGameState_Effect(History.GetGameStateForObjectID(CompareEffectRef.ObjectID));

		if (CompareEffectState.GetX2Effect().EffectName == class'X2Ability_InfantryAbilitySet'.default.StickAndMoveMobilityEffectName)
		{
			// Found the mobility effect; now remove it
			EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(CompareEffectState);
			NewGameState = History.CreateNewGameState(true, EffectRemovedState);
			CompareEffectState.RemoveEffect(NewGameState, GameState);

			if( NewGameState.GetNumGameStateObjects() > 0 )
			{
				`TACTICALRULES.SubmitGameState(NewGameState);
			}
			else
			{
				History.CleanupPendingGameState(NewGameState);
			}

			//`LOG("Lucubration Infantry Class: Stick and Move mobility effect removed by ability " @ string(AbilityTemplate.DataName) @ ".");

			return ELR_NoInterrupt;
		}
	}

	return ELR_NoInterrupt;
}
