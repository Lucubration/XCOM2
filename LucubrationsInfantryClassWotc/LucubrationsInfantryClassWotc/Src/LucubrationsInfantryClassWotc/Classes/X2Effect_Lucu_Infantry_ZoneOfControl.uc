class X2Effect_Lucu_Infantry_ZoneOfControl extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Lucu_Infantry_Effect_ZoneOfControl ZoneOfControlEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetZoneOfControlComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		ZoneOfControlEffectState = XComGameState_Lucu_Infantry_Effect_ZoneOfControl(NewGameState.CreateStateObject(class'XComGameState_Lucu_Infantry_Effect_ZoneOfControl'));
		ZoneOfControlEffectState.ShooterRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(ZoneOfControlEffectState);
		NewGameState.AddStateObject(ZoneOfControlEffectState);

		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = ZoneOfControlEffectState;
	
		EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', class'XComGameState_Lucu_Infantry_Effect_ZoneOfControl'.static.OnAbilityActivated, ELD_OnStateSubmitted);
		EventMgr.RegisterForEvent(ListenerObj, 'PlayerTurnEnded', class'XComGameState_Lucu_Infantry_Effect_ZoneOfControl'.static.OnPlayerTurnEnded, ELD_OnStateSubmitted);

		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', class'XComGameState_Lucu_Infantry_Effect_ZoneOfControl'.static.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Lucubration Infantry Class: Zone of Control passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local bool bContinueTicking;
	local XComGameState_Unit Shooter;
	local EffectAppliedData DefenseEffectParams;
	local X2Effect DefenseEffect;
	local name ApplyEffectResult;

	bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication, Player);

	Shooter = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (Shooter == none)
	{
		Shooter = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		`assert(Shooter != none);
		Shooter = XComGameState_Unit(NewGameState.CreateStateObject(Shooter.Class, Shooter.ObjectID));
		NewGameState.AddStateObject(Shooter);
	}
	`assert(Shooter != none);

	//`LOG("Lucubration Infantry Class: Zone of Control counterattack defense effect ticks for unit " @ Shooter.GetFullName() @ ".");

	// Find and apply the defense effect
	DefenseEffectParams.EffectRef.LookupType = TELT_AbilityShooterEffects;
	DefenseEffectParams.EffectRef.SourceTemplateName = class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlCounterAttackDefenseAbilityName;
	DefenseEffectParams.EffectRef.TemplateEffectLookupArrayIndex = 0;
	DefenseEffectParams.TargetStateObjectRef = Shooter.GetReference();
	DefenseEffectParams.SourceStateObjectRef = Shooter.GetReference();
	DefenseEffectParams.PlayerStateObjectRef = `TACTICALRULES.GetCachedUnitActionPlayerRef();

	DefenseEffect = class'X2Effect'.static.GetX2Effect(DefenseEffectParams.EffectRef);
	`assert(DefenseEffect != none);
	ApplyEffectResult = DefenseEffect.ApplyEffect(DefenseEffectParams, Shooter, NewGameState);
	//if (ApplyEffectResult != 'AA_Success')
		//`LOG("Lucubration Infantry Class: Zone of Control counterattack defense effect not applied to unit " @ Shooter.GetFullName() @ " (" @ string(ApplyEffectResult) @ ").");
	//else
		//`LOG("Lucubration Infantry Class: Zone of Control counterattack defense effect applied to unit " @ Shooter.GetFullName() @ ".");

	return bContinueTicking;
}

static function XComGameState_Lucu_Infantry_Effect_ZoneOfControl GetZoneOfControlComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Lucu_Infantry_Effect_ZoneOfControl(Effect.FindComponentObject(class'XComGameState_Lucu_Infantry_Effect_ZoneOfControl'));
    return none;
}
