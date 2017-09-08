class X2Effect_HolyWarriorDeath extends X2Effect_ApplyWeaponDamage config(GameData_SoldierSkills);

var config array<name> DoNotKillUnitTypes;

var float DelayTimeS;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local XComGameState_Unit TargetUnit;
	local int DamageAmount;
	local XComGameStateHistory History;
	local UnitValue DamageThisTurnValue;
	local WeaponDamageValue DamageValue;

	History = `XCOMHISTORY;
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));

	DamageAmount = 0;
	if ((TargetUnit != none) && !TargetUnit.IsDead())
	{
		if (DoNotKillUnitTypes.Find(TargetUnit.GetMyTemplateGroupName()) == INDEX_NONE)
		{
			DamageAmount = TargetUnit.GetCurrentStat(eStat_HP);
		}
		else if (SourceUnit != none)
		{
			SourceUnit.GetUnitValue('LastEffectDamage', DamageThisTurnValue);
			DamageAmount = DamageThisTurnValue.fValue;
		}

		DamageValue.Damage = DamageAmount;
	}

	return DamageValue;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;
	local X2Action_CameraLookAt LookAtAction;
	local X2Action_Delay DelayAction;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState != None)
	{
		LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		LookAtAction.LookAtDuration = 2.0f;
		LookAtAction.UseTether = false;
		LookAtAction.LookAtObject = UnitState;
		LookAtAction.BlockUntilActorOnScreen = false;
	}

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	DelayAction.Duration = DelayTimeS;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
}

defaultproperties
{
	bIgnoreBaseDamage=true
	bIgnoreArmor=true
	bBypassShields=true
}