class X2SoldierClass_DefaultChampionClasses extends X2SoldierClass
	config(ClassData);

var config array<name> ChampionClasses;
var privatewrite name VektorRifleGuaranteedHit;
var config name ShadowScopePostProcessOn, ShadowScopePostProcessOff, ScopePostProcessOn, ScopePostProcessOff;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2SoldierClassTemplate Template;
	local name ChampionClassName;

	foreach default.ChampionClasses(ChampionClassName)
	{
		`CREATE_X2TEMPLATE(class'X2SoldierClassTemplate', Template, ChampionClassName);
		Templates.AddItem(Template);

		if (ChampionClassName == 'Reaper')
		{
			//Template.CheckSpecialGuaranteedHitFn = Reaper_CheckSpecialGuaranteedHit;
			//Template.CheckSpecialCritLabelFn = Reaper_CheckSpecialCritLabel;
			Template.GetTargetingMethodPostProcessFn = Reaper_GetTargetingMethodPostProcess;
		}
	}

	return Templates;
}

function name Reaper_CheckSpecialGuaranteedHit(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, XComGameState_Item WeaponState, XComGameState_Unit TargetState)
{
	if (WeaponState != none && WeaponState.GetWeaponCategory() == 'vektor_rifle')
		return default.VektorRifleGuaranteedHit;

	return '';
}

function string Reaper_CheckSpecialCritLabel(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, XComGameState_Item WeaponState, XComGameState_Unit TargetState)
{
	if (UnitState.HasSoldierAbility('Executioner') && UnitState.IsSuperConcealed() && TargetState.IsFlanked(UnitState.GetReference()))
	{
		return class'XLocalizedData'.default.ExecutionChanceLabel;
	}

	return "";
}

function bool Reaper_GetTargetingMethodPostProcess(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, XComGameState_Item WeaponState, XComGameState_Unit TargetState, out name EnabledPostProcess, out name DisabledPostProcess)
{
	if (Reaper_CheckSpecialGuaranteedHit(UnitState, AbilityState, WeaponState, TargetState) == default.VektorRifleGuaranteedHit)
	{
		if (UnitState.IsSuperConcealed())
		{
			EnabledPostProcess = default.ShadowScopePostProcessOn;
			DisabledPostProcess = default.ShadowScopePostProcessOff;
		}
		else
		{
			EnabledPostProcess = default.ScopePostProcessOn;
			DisabledPostProcess = default.ScopePostProcessOff;
		}
		return true;
	}
	return false;
}

DefaultProperties
{
	VektorRifleGuaranteedHit = "VektorRifle"
}