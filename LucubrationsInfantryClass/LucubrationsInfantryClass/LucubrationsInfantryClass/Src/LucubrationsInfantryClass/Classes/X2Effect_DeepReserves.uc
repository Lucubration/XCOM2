class X2Effect_DeepReserves extends X2Effect_Persistent;

// I can't get these to stick on persistent effects. Perhaps because of how I'm doing my testing? I'm sticking them on the state object for later persistence
var int HealAmountPerTurn;
var float HealDamagePercent;
var int MaxTotalHealAmount;
var name HealthRegeneratedName;
var name DamageTakenName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Effect_DeepReserves DeepReservesEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	if (GetDeepReservesComponent(NewEffectState) == none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);

		// Create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		DeepReservesEffectState = XComGameState_Effect_DeepReserves(NewGameState.CreateStateObject(class'XComGameState_Effect_DeepReserves'));
		DeepReservesEffectState.HealAmountPerTurn = HealAmountPerTurn;
		DeepReservesEffectState.DamageTakenName = DamageTakenName;
		DeepReservesEffectState.HealDamagePercent = HealDamagePercent;
		DeepReservesEffectState.MaxTotalHealAmount = MaxTotalHealAmount;
		DeepReservesEffectState.HealthRegeneratedName = HealthRegeneratedName;
		DeepReservesEffectState.UnitRef = TargetUnit.GetReference();
		NewEffectState.AddComponentObject(DeepReservesEffectState);
		NewGameState.AddStateObject(DeepReservesEffectState);

		EventMgr = `XEVENTMGR;
	
		// The gamestate component should handle the callback
		ListenerObj = DeepReservesEffectState;
		
		EventMgr.RegisterForEvent(ListenerObj, 'UnitTakeEffectDamage', class'XComGameState_Effect_DeepReserves'.static.OnUnitTakeEffectDamage, ELD_OnStateSubmitted, , TargetUnit);
		
		// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
		// by having the gamestate itself handle this callback
		EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', class'XComGameState_Effect_DeepReserves'.static.OnTacticalGameEnd, ELD_OnStateSubmitted);

		`LOG("Lucubration Infantry Class: Deep Reserves passive effect registered for events.");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

function bool RegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Effect_DeepReserves DeepReservesEffectState;
	local XComGameState_Unit OldTargetState, NewTargetState;
	local UnitValue DamageTaken, HealthRegenerated;
	local int AmountToHeal, Healed;
	
	//`LOG("Lucubration Infantry Class: Deep Reserves regeneration ticked.");

	DeepReservesEffectState = GetDeepReservesComponent(kNewEffectState);

	OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (OldTargetState.IsDead())
	{
		//`LOG("Lucubration Infantry Class: Deep Reserves unit not healed (unit is dead).");
		return false;
	}

	OldTargetState.GetUnitValue(DeepReservesEffectState.DamageTakenName, DamageTaken);
	OldTargetState.GetUnitValue(DeepReservesEffectState.HealthRegeneratedName, HealthRegenerated);

	//`LOG("Lucubration Infantry Class: Deep Reserves damage taken = " @ string(DamageTaken.fValue) @ ".");
	//`LOG("Lucubration Infantry Class: Deep Reserves health regenerated = " @ string(HealthRegenerated.fValue) @ ".");
	//`LOG("Lucubration Infantry Class: Deep Reserves max total heal amount = " @ string(DeepReservesEffectState.MaxTotalHealAmount) @ ".");

	// Heal amount is determine based on this formula
	AmountToHeal = int((DeepReservesEffectState.HealDamagePercent * DamageTaken.fValue) - HealthRegenerated.fValue);
	if (AmountToHeal <= 0)
	{
		//`LOG("Lucubration Infantry Class: Deep Reserves unit not healed (max amount to heal reached " @ string(DeepReservesEffectState.HealDamagePercent * DamageTaken.fValue) @").");
		return false;
	}

	//`LOG("Lucubration Infantry Class: Deep Reserves amount to heal = " @ string(AmountToHeal) @ ".");

	// Ensure the unit is not healed for more than the maximum allowed amount (per turn)
	AmountToHeal = min(DeepReservesEffectState.HealAmountPerTurn, AmountToHeal);
	// Ensure the unit is not healed for more than the maximum allowed amount (total)
	AmountToHeal = min(DeepReservesEffectState.MaxTotalHealAmount - HealthRegenerated.fValue, AmountToHeal);
	if (AmountToHeal <= 0)
	{
		//`LOG("Lucubration Infantry Class: Deep Reserves unit not healed (max amount to heal reached " @ string(DeepReservesEffectState.MaxTotalHealAmount) @").");
		return false;
	}

	// Perform the heal
	NewTargetState = XComGameState_Unit(NewGameState.CreateStateObject(OldTargetState.Class, OldTargetState.ObjectID));
	NewTargetState.ModifyCurrentStat(estat_HP, AmountToHeal);
	NewGameState.AddStateObject(NewTargetState);

	// Save how much the unit was healed
	Healed = NewTargetState.GetCurrentStat(eStat_HP) - OldTargetState.GetCurrentStat(eStat_HP);
	
	//`LOG("Lucubration Infantry Class: Deep Reserves regeneration healed for " @ string(Healed) @ ".");

	if (Healed > 0)
	{
		NewTargetState.SetUnitFloatValue(DeepReservesEffectState.HealthRegeneratedName, HealthRegenerated.fValue + Healed, eCleanup_BeginTactical);

		//`LOG("Lucubration Infantry Class: Deep Reserves total healed by unit " @ NewTargetState.GetFullName() @ " updated to " @ string(HealthRegenerated.fValue + Healed) @ ".");
	}

	return false;
}

static function XComGameState_Effect_DeepReserves GetDeepReservesComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Effect_DeepReserves(Effect.FindComponentObject(class'XComGameState_Effect_DeepReserves'));
    return none;
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;

	OldUnit = XComGameState_Unit(BuildTrack.StateObject_OldState);
	NewUnit = XComGameState_Unit(BuildTrack.StateObject_NewState);

	Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
	
	if( Healed > 0 )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "+" $ Healed, '', eColor_Good);
	}
}

defaultproperties
{
	EffectName="Regeneration"
	EffectTickedFn=RegenerationTicked
}