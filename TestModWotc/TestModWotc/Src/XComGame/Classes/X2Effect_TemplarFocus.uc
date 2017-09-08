class X2Effect_TemplarFocus extends X2Effect_ModifyStats;

struct FocusLevelModifiers
{
	var array<StatChange>		StatChanges;
	var int						ArmorMitigation;
	var int						WeaponDamage;
};

var array<FocusLevelModifiers>	arrFocusModifiers;
var localized string SpecialDamageName;

function AddNextFocusLevel(const array<StatChange> NextStatChanges, const int NextArmorMitigation, const int NextWeaponDamage)
{
	local FocusLevelModifiers NextFocusLevel;

	NextFocusLevel.StatChanges = NextStatChanges;
	NextFocusLevel.ArmorMitigation = NextArmorMitigation;
	NextFocusLevel.WeaponDamage = NextWeaponDamage;
	arrFocusModifiers.AddItem(NextFocusLevel);
}

function FocusLevelModifiers GetFocusModifiersForLevel(int FocusLevel)
{
	local FocusLevelModifiers Modifiers;

	if (FocusLevel >= 0)
	{
		if (FocusLevel >= arrFocusModifiers.Length)
			Modifiers = arrFocusModifiers[arrFocusModifiers.Length - 1];
		else
			Modifiers = arrFocusModifiers[FocusLevel];
	}

	return Modifiers;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_TemplarFocus FocusState;

	FocusState = XComGameState_Effect_TemplarFocus(NewEffectState);
	`assert(FocusState != none);

	FocusState.FocusLevel = FocusState.GetStartingFocus(XComGameState_Unit(kNewTargetState));	
	FocusState.StatChanges = GetFocusModifiersForLevel(FocusState.FocusLevel).StatChanges;
	if (FocusState.StatChanges.Length > 0)
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, FocusState);
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	return GetFocusModifiersForLevel(XComGameState_Effect_TemplarFocus(EffectState).FocusLevel).ArmorMitigation;
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int Focus, Damage;

	if (class'X2Ability_TemplarAbilitySet'.default.FocusDamageBoostAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
	{
		//	only apply damage boost to the primary target of an ability
		if (XComGameState_BaseObject(TargetDamageable).ObjectID == AppliedData.AbilityInputContext.PrimaryTarget.ObjectID)
		{
			Focus = Attacker.GetTemplarFocusLevel();
			Damage = GetFocusModifiersForLevel(Focus).WeaponDamage;
		}		
	}
	return Damage;
}

event string GetSpecialDamageMessageName()
{
	return default.SpecialDamageName;
}

DefaultProperties
{
	EffectName = "TemplarFocus"			//	must match TemplarFocusName in X2AbilityTemplateManager
	DuplicateResponse = eDupe_Ignore
	bCanBeRedirected = false
	GameStateEffectClass = class'XComGameState_Effect_TemplarFocus'
	bDisplayInSpecialDamageMessageUI = true
}
