class XComGameState_Beags_Escalation_Effect_LightningReflexes extends XComGameState_BaseObject;

var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Beags Escalation: Lightning Reflexes 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;
	
	EventManager.UnRegisterFromEvent(ListenerObj, 'AbilityActivated');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Lightning Reflexes states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Beags Escalation: Lightning Reflexes passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		AbilityContext;
	local X2AbilityTemplate					AbilityTemplate;
	local X2AbilityToHitCalc_StandardAim	AbilityToHitCalc;
	local XComGameState_Unit				UnitState;
	
	History = `XCOMHISTORY;
	
    //`LOG("Beags Escalation: Lightning Reflexes 'AbilityActivated' event listener delegate invoked.");
	
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
	{
		//`LOG("Beags Escalation: Lightning Reflexes not activated (no ability context).");
		return ELR_NoInterrupt;
	}

	if (AbilityContext.InputContext.PrimaryTarget.ObjectID != UnitRef.ObjectID)
	{
		//`LOG("Beags Escalation: Lightning Reflexes not activated (wrong target).");
		return ELR_NoInterrupt;
	}
	
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	if (AbilityTemplate == none)
	{
		//`LOG("Beags Escalation: Lightning Reflexes not activated (no ability template).");
		return ELR_NoInterrupt;
	}
	
	AbilityToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
	if (AbilityTemplate == none || !AbilityToHitCalc.bReactionFire)
	{
		//`LOG("Beags Escalation: Lightning Reflexes not activated (not reaction fire).");
		return ELR_NoInterrupt;
	}
	
	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(UnitRef.ObjectID));
	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	if (UnitState == none)
	{
		//`LOG("Beags Escalation: Lightning Reflexes not activated (missing unit state).");
		return ELR_NoInterrupt;
	}

	// This unit was the target of a reaction fire ability. Re-roll lightning reflexes in preparation for the next attack
	class'X2Effect_Beags_Escalation_LightningReflexes'.static.RollLightningReflexes(UnitState, `SYNC_RAND(100));

	return ELR_NoInterrupt;
}