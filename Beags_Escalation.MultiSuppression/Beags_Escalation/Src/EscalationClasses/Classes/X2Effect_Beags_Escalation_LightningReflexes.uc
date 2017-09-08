class X2Effect_Beags_Escalation_LightningReflexes extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Beags_Escalation_Effect_LightningReflexes LightningReflexesEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetLightningReflexesComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		LightningReflexesEffectState = XComGameState_Beags_Escalation_Effect_LightningReflexes(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_LightningReflexes'));
		LightningReflexesEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(LightningReflexesEffectState);
		NewGameState.AddStateObject(LightningReflexesEffectState);
	
		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = LightningReflexesEffectState;

		// This callback will re-roll the next Lightning Reflexes value after the unit it attacked by reaction fire
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', LightningReflexesEffectState.OnAbilityActivated, ELD_OnStateSubmitted);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', LightningReflexesEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Beags Escalation: Lightning Reflexes passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function XComGameState_Beags_Escalation_Effect_LightningReflexes GetLightningReflexesComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_LightningReflexes(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_LightningReflexes'));
    return none;
}

//Occurs once per turn during the Unit Effects phase
simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit != None)
	{
		// Lightning Reflexes rolls again at the start of each turn
		RollLightningReflexes(TargetUnit, `SYNC_RAND(100), NewGameState);
	}

	return true;
}

static function RollLightningReflexes(XComGameState_Unit UnitState, int Roll, optional XComGameState NewGameState)
{
	local UnitValue							UnitValue;
	local int								HitModifier;
	local int								Grants;
	local bool								SubmitGameState;

	// Look up the hit modifier based on the number of Lighting Reflex grants have been given this turn
	if (UnitState.GetUnitValue(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.LightningReflexesStateName, UnitValue))
	{
		Grants = UnitValue.fValue;

		// Grants caps out at the max index of the hit modifiers array. No need to count higher
		if (Grants >= class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.LightningReflexesHitModifiers.Length)
			Grants = class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.LightningReflexesHitModifiers.Length - 1;
	}
	else
	{
		// Must be the start of a turn; grants is reset to zero
		Grants = 0;
	}

	`LOG("Beags Escalation: Lightning Reflexes grants for unit " @ UnitState.GetFullName() @ "=" @ Grants @ ".");
	
	HitModifier = class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.LightningReflexesHitModifiers[Grants];

	if (NewGameState == none)
	{
		// If a gamestate wasn't passed in, create a change container for updating the unit value
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		SubmitGameState = true;
	}

	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
	NewGameState.AddStateObject(UnitState);

	// Update grants this turn unit value
	UnitState.SetUnitFloatValue(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.LightningReflexesStateName, Grants + 1, eCleanup_BeginTurn);

	`LOG("Beags Escalation: Lightning Reflexes roll for unit " @ UnitState.GetFullName() @ "=" @ string(Roll) @ " vs " @ string(HitModifier) @ "(" @ (Roll < HitModifier ? "Success" : "Failure") @ ").");

	// Update the flag on the unit state reflecting whether Lightning Reflexes will apply to the next reaction fire shot against them
	UnitState.bLightningReflexes = Roll < HitModifier;
	
	if (SubmitGameState)
	{
		// If we created a gamestate change container, we need to submit it now
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
}