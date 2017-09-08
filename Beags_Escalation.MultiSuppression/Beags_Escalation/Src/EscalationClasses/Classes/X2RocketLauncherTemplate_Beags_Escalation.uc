class X2RocketLauncherTemplate_Beags_Escalation extends X2WeaponTemplate;

var int IncreaseRocketRange;
var int IncreaseRocketRadius;
var float MaxRocketScatter;
var int MoveRangePenalty;
var float MaxAimPenalty;
var float SuppressionRangePenalty;

// This is the entryway for gathering all rocket-specific range modifiers for a rocket launch. Values given in tiles
function float ModifyRocketRange(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, float RocketRange)
{
	local XComGameStateHistory									History;
	local float													SnapshotRange;
	local StateObjectReference									EffectRef;
	local XComGameState_Effect									EffectState;
	local X2Effect_Beags_Escalation_RocketRangeModifySnapshot	SnapshotRangeEffect;
	local X2Effect_Beags_Escalation_RocketRangeModifyFlat		FlatRangeEffect;
	local X2Effect_Beags_Escalation_RocketRangeModifyPercent	PercentRangeEffect;

	History = `XCOMHISTORY;

	// The weapon itself has a modifier
	RocketRange += IncreaseRocketRange;

	// Snapshot effects are a specialized type of flat range modifier that can decrease or increase the rocket range,
	// but never above the base range
	SnapshotRange = 0;
	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			SnapshotRangeEffect = X2Effect_Beags_Escalation_RocketRangeModifySnapshot(EffectState.GetX2Effect());
			if (SnapshotRangeEffect != none)
				SnapshotRange = SnapshotRangeEffect.ModifyRocketRange(UnitState, AbilityState, SnapshotRange);
		}
	}

	// Limit the snapshot range to zero
	if (SnapshotRange <= 0)
		RocketRange += SnapshotRange;

	// Various effects on the unit can modify the range. Apply flat range modifiers first
	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			FlatRangeEffect = X2Effect_Beags_Escalation_RocketRangeModifyFlat(EffectState.GetX2Effect());
			if (FlatRangeEffect != none)
				RocketRange = FlatRangeEffect.ModifyRocketRange(UnitState, AbilityState, RocketRange);
		}
	}
	// Apply percent range modifiers second
	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			PercentRangeEffect = X2Effect_Beags_Escalation_RocketRangeModifyPercent(EffectState.GetX2Effect());
			if (PercentRangeEffect != none)
				RocketRange = PercentRangeEffect.ModifyRocketRange(UnitState, AbilityState, RocketRange);
		}
	}
	
	return RocketRange;
}

// This just gathers the basic aim modifier for a rocket launch
function float GetAimModifiers(XComGameState_Unit UnitState, XComGameState_Ability AbilityState)
{
	local float AimModifier;
	local UnitValue Value;

	AimModifier = 0.0f;
	// The weapon template defines an aim penalty to be applied based on firing distance
	if (UnitState.GetUnitValue(class'X2TargetingMethod_Beags_Escalation_Rocket'.default.FiringDistanceRatioName, Value))
		AimModifier += MaxAimPenalty * Value.fValue;
	
	return AimModifier;
}

DefaultProperties
{
	WeaponCat = "beags_escalation_rocket_launcher";
	InventorySlot = eInvSlot_SecondaryWeapon;
	StowedLocation = eSlot_RightBack;
	bSoundOriginatesFromOwnerLocation = false;
}