class X2Effect_Lucu_Sniper_SetUp extends X2Effect_Squadsight;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit kOldTargetUnitState, kNewTargetUnitState;	
	local int i;
	local name ActionPointType;

	super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication);

	kOldTargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( kOldTargetUnitState != None )
	{
		ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

		kNewTargetUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', kOldTargetUnitState.ObjectID));
		for (i = kNewTargetUnitState.ActionPoints.Length - 1; i >= 0; --i)
		{
			if (kNewTargetUnitState.ActionPoints[i] == ActionPointType)
			{
				// Remove action point
				kNewTargetUnitState.ActionPoints.Remove(i, 1);

				//`LOG("Lucubration Sniper Class: Set Up tick removed 1 " @ string(ActionPointType) @ " action point from unit " @ kNewTargetUnitState.GetFullName() @ ".");

				break;
			}
		}

		NewGameState.AddStateObject(kNewTargetUnitState);

		//`LOG("Lucubration Sniper Class: Set Up tick ended with " @ string(kNewTargetUnitState.ActionPoints.Length) @ " action points on unit " @ kNewTargetUnitState.GetFullName() @ ".");
	}

	return true;
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
