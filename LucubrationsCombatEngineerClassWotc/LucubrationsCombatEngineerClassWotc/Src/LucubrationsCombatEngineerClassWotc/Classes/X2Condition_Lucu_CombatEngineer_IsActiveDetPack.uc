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

    // Iterate all det pack effects
	foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		DetPackEffect = X2Effect_Lucu_CombatEngineer_DetPack(EffectState.GetX2Effect());
		if (DetPackEffect != none)
		{
            if (EffectState.CreatedObjectReference.ObjectID == kTarget.ObjectID)
            {
			    DestructibleState = XComGameState_Destructible(History.GetGameStateForObjectID(EffectState.CreatedObjectReference.ObjectID));
                if (DestructibleState != none &&
                    class'Lucu_CombatEngineer_Utilities'.static.IsDetPackArchetype(DestructibleState.SpawnedDestructibleArchetype) &&
                    DestructibleState.Health > 0)
                {
                    // If we are ensuring this IS NOT a det pack, we don't check ownership, just archetype
                    if (!IsDetPack)
                    {
                        return 'AA_UnitIsWrongType';
                    }

                    // If we are ensuring this IS a det pack, we're also ensuring ownership
                    if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == kSource.ObjectID)
                    {
                        return 'AA_Success';
                    }
                }
            }
		}
	}

    // Return appropriate result code depending on what we're checking (IS or IS NOT)
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