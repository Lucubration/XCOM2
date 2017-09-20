class X2Condition_Lucu_CombatEngineer_HasActiveDetPack extends X2Condition;

function name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    // Ensure the target has det packs that can be exploded
    return UnitHasActiveDetPack(kTarget);
}

function name UnitHasActiveDetPack(XComGameState_BaseObject kTarget)
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
            if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == kTarget.ObjectID)
            {
			    DestructibleState = XComGameState_Destructible(History.GetGameStateForObjectID(EffectState.CreatedObjectReference.ObjectID));
                if (DestructibleState != none &&
                    class'Lucu_CombatEngineer_Utilities'.static.IsDetPackArchetype(DestructibleState.SpawnedDestructibleArchetype) &&
                    DestructibleState.Health > 0)
                {
                    return 'AA_Success';
                }
            }
		}
	}

    return 'AA_MissingRequiredEffect';
}
