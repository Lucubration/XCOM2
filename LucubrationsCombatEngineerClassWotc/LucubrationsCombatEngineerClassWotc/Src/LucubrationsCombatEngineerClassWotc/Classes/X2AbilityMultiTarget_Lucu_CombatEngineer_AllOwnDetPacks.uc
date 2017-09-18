class X2AbilityMultiTarget_Lucu_CombatEngineer_AllOwnDetPacks extends X2AbilityMultiTarget_AllAllies;

simulated function GetMultiTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local XComGameState_Destructible DestructibleState;
	local X2Effect_Lucu_CombatEngineer_DetPack DetPackEffect;
    local int i;
    local AvailableTarget Target;
    
	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		DetPackEffect = X2Effect_Lucu_CombatEngineer_DetPack(EffectState.GetX2Effect());
		if (DetPackEffect != none)
		{
            for (i = 0; i < Targets.Length; i++)
            {
                Target = Targets[i];
                if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == Target.PrimaryTarget.ObjectID)
                {
			        DestructibleState = XComGameState_Destructible(History.GetGameStateForObjectID(EffectState.CreatedObjectReference.ObjectID));
                    if (DestructibleState.Health > 0)
                    {
                        Target.AdditionalTargets.AddItem(EffectState.CreatedObjectReference);
                        // We apparently have to do this song-and-dance because updating the object doesn't update
                        // it in the array. WTF? Was it copied out?
                        Targets[i] = Target;
                    }
                }
            }
		}
	}
}

simulated function name CheckFilteredMultiTargets(const XComGameState_Ability Ability, const AvailableTarget Target)
{
	local XComGameStateHistory History;
    local StateObjectReference MultiTargetRef;
	local XComGameState_Destructible DestructibleState;
    local name Result;

	History = `XCOMHISTORY;

    Result = 'AA_NoTargets';

    foreach Target.AdditionalTargets(MultiTargetRef)
    {
        DestructibleState = XComGameState_Destructible(History.GetGameStateForObjectID(MultiTargetRef.ObjectID));
        if (DestructibleState.Health <= 0)
        {
            result = 'AA_UnitIsDead';
        }
        result = 'AA_Success';
    }

    return result;
}