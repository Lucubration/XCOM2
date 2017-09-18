class X2Condition_Lucu_CombatEngineer_IsActiveDetPack extends X2Condition;

var bool IsDetPack;

function name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    // Ensure the target is an active det pack of the source
    return UnitIsActiveDetPack(kTarget, kSource);
}

function name UnitIsActiveDetPack(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local XComGameState_Destructible DestructibleState;
	local X2Effect_Lucu_CombatEngineer_DetPack DetPackEffect;
    
	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		DetPackEffect = X2Effect_Lucu_CombatEngineer_DetPack(EffectState.GetX2Effect());
		if (DetPackEffect != none)
		{
            if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == kSource.ObjectID &&
                EffectState.CreatedObjectReference.ObjectID == kTarget.ObjectID)
            {
			    DestructibleState = XComGameState_Destructible(History.GetGameStateForObjectID(EffectState.CreatedObjectReference.ObjectID));
                if (DestructibleState != none &&
                    DestructibleState.SpawnedDestructibleArchetype == class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.DetPackDestructibleArchetype &&
                    DestructibleState.Health > 0)
                {
                    if (!IsDetPack)
                    {
                        return 'AA_UnitIsWrongType';
                    }

                    return 'AA_Success';
                }
            }
		}
	}

    if (!IsDetPack)
    {
        return 'AA_Success';
    }

    return 'AA_MissingRequiredEffect';
}

DefaultProperties
{
    IsDetPack=true
}