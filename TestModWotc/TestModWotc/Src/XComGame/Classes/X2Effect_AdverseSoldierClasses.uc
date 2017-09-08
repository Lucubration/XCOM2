class X2Effect_AdverseSoldierClasses extends X2Effect_Persistent;

var array<name> AdverseClasses;
var float DmgMod;

function int GetBaseDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	if (NewGameState != none)
	{
		//	only increase damage against attacks, not from e.g. an effect ticking
		if (XComGameStateContext_Ability(NewGameState.GetContext()) == none)
			return 0;
	}
	if (AdverseClasses.Find(Attacker.GetSoldierClassTemplateName()) != INDEX_NONE)
	{
		return CurrentDamage * DmgMod;
	}

	return 0;
}

function int ModifyDamageFromDestructible(XComGameState_Destructible DestructibleState, int IncomingDamage, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState) 
{ 
	//	I know this is super ugly, but......................................  -jbouscher
	if (AdverseClasses.Find('Reaper') != INDEX_NONE)
	{
		if (DestructibleState.SpawnedDestructibleArchetype == class'X2Ability_ReaperAbilitySet'.default.ClaymoreDestructibleArchetype ||
			DestructibleState.SpawnedDestructibleArchetype == class'X2Ability_ReaperAbilitySet'.default.ShrapnelDestructibleArchetype)
		{
			return IncomingDamage * DmgMod;
		}
	}

	return 0; 
}

DefaultProperties
{
	bDisplayInSpecialDamageMessageUI=true
}