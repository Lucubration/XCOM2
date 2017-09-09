class X2Effect_Lucu_Sniper_SetUp extends X2Effect_Squadsight;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    local int i;
    local name ActionPointType;

    ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

    for (i = UnitState.ActionPoints.Length - 1; i >= 0; --i)
    {
	    if (UnitState.ActionPoints[i] == ActionPointType)
	    {
		    // Remove action point
		    UnitState.ActionPoints.Remove(i, 1);

			//`LOG("Lucubration Sniper Class: Set Up tick removed 1 " @ string(ActionPointType) @ " action point from unit " @ kNewTargetUnitState.GetFullName() @ ".");

		    break;
	    }
    }

		//`LOG("Lucubration Sniper Class: Set Up tick ended with " @ string(kNewTargetUnitState.ActionPoints.Length) @ " action points on unit " @ kNewTargetUnitState.GetFullName() @ ".");
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	if (AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length > 0 &&
		SourceUnit.AffectedByEffectNames.Find(class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.RelocationActiveEffectName) == INDEX_NONE)
	{
		// If the unit moved for any reason without having Relocation active, remove this effect
		EffectState.RemoveEffect(NewGameState, NewGameState);
	}

	return false;
}
