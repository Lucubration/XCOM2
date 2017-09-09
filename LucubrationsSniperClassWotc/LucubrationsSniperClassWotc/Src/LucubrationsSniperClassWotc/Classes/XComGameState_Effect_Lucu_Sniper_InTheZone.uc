class XComGameState_Effect_Lucu_Sniper_InTheZone extends XComGameState_BaseObject;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Lucubration Sniper Class: In the Zone 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("In the Zone states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Lucubration Sniper Class: In the Zone passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Unit TargetUnitState, OldTargetUnitState, SourceUnitState, OldSourceUnitState;
	local GameRulesCache_VisibilityInfo VisibilityInfoFromSource;
	local XComGameState_Item ItemState;
	local X2WeaponTemplate WeaponTemplate;
	local XComGameState NewGameState;
	local bool TargetIsFlankedOrUncovered, TargetIsDead;
	local int i;
	
	History = `XCOMHISTORY;
	
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
		return ELR_NoInterrupt;
	
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;
	
	// Check if the source object was the unit ref for this effect, and make sure the target was not
	if (AbilityContext.InputContext.SourceObject.ObjectID != UnitRef.ObjectID ||
		AbilityContext.InputContext.SourceObject.ObjectID == AbilityContext.InputContext.PrimaryTarget.ObjectID)
		return ELR_NoInterrupt;
		
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	if (AbilityTemplate == none)
		return ELR_NoInterrupt;
	
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	if (AbilityState == none || AbilityState.ObjectID == 0)
		return ELR_NoInterrupt;

	ItemState = AbilityState.GetSourceWeapon();
	if (ItemState == none)
		return ELR_NoInterrupt;

	WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
	if (WeaponTemplate == none || (WeaponTemplate.InventorySlot != eInvSlot_PrimaryWeapon && WeaponTemplate.InventorySlot != eInvSlot_SecondaryWeapon))
		return ELR_NoInterrupt;

	// Must be the controlling player's turn
	SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID != SourceUnitState.ControllingPlayer.ObjectID)
		return ELR_NoInterrupt;

	// Applies to offensive abilities only
	if (AbilityTemplate.Hostility != eHostility_Offensive || !AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState))
		return ELR_NoInterrupt;

	OldTargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	TargetUnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (OldTargetUnitState != none && OldTargetUnitState.ObjectID > 0 &&
		TargetUnitState != none && TargetUnitState.ObjectID > 0)
	{
		// Check if the target was flanked or uncovered
		TargetIsFlankedOrUncovered = true;
		if (TargetUnitState.CanTakeCover())
		{
			// Sabot Round ignores cover for In the Zone
			if (AbilityTemplate.DataName != class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundAbilityName &&
				AbilityTemplate.DataName != class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundSetUpAbilityName)
			{
				`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnitState.ObjectID, TargetUnitState.ObjectID, VisibilityInfoFromSource);
				if (VisibilityInfoFromSource.TargetCover != CT_None)
					TargetIsFlankedOrUncovered = false;
			}
		}

		if (TargetIsFlankedOrUncovered)
			TargetIsDead = TargetUnitState.IsDead();
	}

	if (!TargetIsFlankedOrUncovered || !TargetIsDead)
	{
		if (AbilityContext.InputContext.MultiTargets.Length > 0)
		{
			for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; i++)
			{
				OldTargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i].ObjectID));
				TargetUnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i].ObjectID));
				if (OldTargetUnitState != none && OldTargetUnitState.ObjectID > 0 &&
					TargetUnitState != none && TargetUnitState.ObjectID > 0)
				{
					// Check if the target was flanked or uncovered
					TargetIsFlankedOrUncovered = true;
					if (TargetUnitState.CanTakeCover())
					{
						// Sabot Round ignores cover for In the Zone
						if (AbilityTemplate.DataName != class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundAbilityName &&
							AbilityTemplate.DataName != class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundSetUpAbilityName)
						{
							`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnitState.ObjectID, TargetUnitState.ObjectID, VisibilityInfoFromSource);
							if (VisibilityInfoFromSource.TargetCover != CT_None)
								TargetIsFlankedOrUncovered = false;
						}
					}
					
					if (TargetIsFlankedOrUncovered)
						TargetIsDead = TargetUnitState.IsDead();

					if (TargetIsFlankedOrUncovered && TargetIsDead)
						break;
				}
			}
		}
	}

	if (TargetIsFlankedOrUncovered && TargetIsDead)
	{
		OldSourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID,, AbilityContext.AssociatedState.HistoryIndex - 1));

		if (OldSourceUnitState != none)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = InTheZoneVisualizationFn;
			SourceUnitState = XComGameState_Unit(NewGameState.CreateStateObject(SourceUnitState.Class, SourceUnitState.ObjectID));
			NewGameState.AddStateObject(SourceUnitState);

			// Grant a single 'run and gun' action point
			SourceUnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);

			// Submit changed state
			`TACTICALRULES.SubmitGameState(NewGameState);

			`LOG("Lucubration Sniper Class: In the Zone triggered for unit " @ SourceUnitState.GetFullName() @ " ability " @ string(AbilityState.GetMyTemplateName()) @ ".");
		}
	}

	return ELR_NoInterrupt;
}

function InTheZoneVisualizationFn(XComGameState VisualizeGameState)
{
	local XComGameState_Unit            UnitState;
	local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;
	local VisualizationActionMetadata   ActionMetadata;
	local XComGameStateHistory          History;
	local X2AbilityTemplate             AbilityTemplate;

	History = `XCOMHISTORY;

	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('Lucu_Sniper_InTheZone');
    
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.VisualizeActor = UnitState.GetVisualizer();
		
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
    	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage, 0.75, true);
		
		break;
	}
}
