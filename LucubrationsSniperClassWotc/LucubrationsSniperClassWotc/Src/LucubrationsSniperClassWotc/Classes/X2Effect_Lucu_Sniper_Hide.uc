class X2Effect_Lucu_Sniper_Hide extends X2Effect_ToHitModifier;

var int StealthCritBonus;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit kOldTargetUnitState, kNewTargetUnitState;
	local UnitValue Value;
	local int Check;
	local bool bContinueTicking;
	
	bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication);

	kOldTargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (kOldTargetUnitState != None && kOldTargetUnitState.ObjectID > 0)
	{
		kNewTargetUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', kOldTargetUnitState.ObjectID));

		// Tick occurs at the end of the player's turn. Check whether they attacked during their turn
		if (kOldTargetUnitState.GetUnitValue('AttacksThisTurn', Value))
			Check = Value.fValue;
		else
			Check = 0;
		
		// If the unit didn't attack during their turn, set the "Can Hide" flag in preparation for next turn
		if (Check == 0)
			kNewTargetUnitState.SetUnitFloatValue(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.CanHideName, 1, eCleanup_BeginTactical);

		NewGameState.AddStateObject(kNewTargetUnitState);
	}

	return bContinueTicking;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	if (kAbility.GetMyTemplate().Hostility == eHostility_Offensive)
	{
		// If the unit used any offensive ability, clear the "Can Hide" flag
		SourceUnit.SetUnitFloatValue(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.CanHideName, 0, eCleanup_BeginTactical);
	}

	return false;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo;

	if (Attacker.IsConcealed())
	{
		AccuracyInfo.ModType = eHit_Crit;
		AccuracyInfo.Value = StealthCritBonus;
		AccuracyInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(AccuracyInfo);
	}
}
