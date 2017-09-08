class X2Effect_ConditionalDamageModifier extends X2Effect_Persistent;

// If true, this effect modifies damage dealt by the unit this effect applies to
var bool bModifyOutgoingDamage;

// If true, this effect modifies damage received by the unit this effect applies to
var bool bModifyIncomingDamage;

// the multiplicative damage modifier applied to the damage, with a value of 1.0 representing no modifier, 0.5 = 50% damage less, etc.
var float DamageModifier;

// the additive damage modifier applied to the damage
var int DamageBonus;

var array<X2Condition>              ApplyDamageModConditions;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int DamageMod;
	local XComGameState_BaseObject TargetObject;

	DamageMod = 0;

	if( bModifyOutgoingDamage )
	{
		TargetObject = XComGameState_BaseObject(TargetDamageable);

		if( TargetObject != None )
		{
			DamageMod = GetConditionalModifier(CurrentDamage, Attacker, TargetObject);
		}
	}

	return DamageMod;
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;
	local XComGameState_BaseObject TargetObject;

	DamageMod = 0;

	if( bModifyIncomingDamage )
	{
		TargetObject = XComGameState_BaseObject(TargetDamageable);

		if( TargetObject != None )
		{
			DamageMod = GetConditionalModifier(CurrentDamage, Attacker, TargetObject);
		}
	}

	return DamageMod;
}

private function int GetConditionalModifier(int CurrentDamage, XComGameState_Unit Attacker, XComGameState_BaseObject TargetObject)
{
	local int DamageMod;
	local int Index;
	local Name AvailableCode;

	DamageMod = 0;

	AvailableCode = 'AA_Success';
	for( Index = 0; Index < ApplyDamageModConditions.Length; ++Index )
	{
		AvailableCode = ApplyDamageModConditions[Index].MeetsCondition(TargetObject);
		if( AvailableCode != 'AA_Success' )
			break;
		AvailableCode = ApplyDamageModConditions[Index].MeetsConditionWithSource(TargetObject, Attacker);
		if( AvailableCode != 'AA_Success' )
			break;
	}

	if( AvailableCode == 'AA_Success' )
	{
		DamageMod = CurrentDamage * (DamageModifier - 1.0);

		DamageMod += DamageBonus;
	}

	return DamageMod;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Allow
	DamageModifier=1.0
	bDisplayInSpecialDamageMessageUI=true
}