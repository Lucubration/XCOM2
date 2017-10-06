class X2AbilityCost_Lucu_CombatEngineer_FreeAbilityEffect extends X2AbilityCost_ActionPoints;

var array<name> DoNotConsumeEffects;
var bool RemoveEffects;

simulated function int GetPointCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local int PointCheck;

    PointCheck = super.GetPointCost(AbilityState, AbilityOwner);

	if (DoNotConsumePoints(AbilityState, AbilityOwner))
	{
		PointCheck = 0;
	}

	return PointCheck;
}

simulated function bool DoNotConsumePoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local int i;

	for (i = 0; i < DoNotConsumeEffects.Length; ++i)
	{
		if (AbilityOwner.AffectedByEffectNames.Find(DoNotConsumeEffects[i]) != INDEX_NONE)
        {
			return true;
        }
	}

	return false;
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent PersistentEffect;

    // Apply the Ability Point cost first
    super.ApplyCost(AbilityContext, kAbility, AffectState, AffectWeapon, NewGameState);
    
    if (RemoveEffects)
    {
        // Remove the named effects afterwards
	    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	    {
		    if (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID)
		    {
			    PersistentEffect = EffectState.GetX2Effect();
			    if (DoNotConsumeEffects.Find(PersistentEffect.EffectName) != INDEX_NONE)
			    {
				    EffectState.RemoveEffect(NewGameState, NewGameState, true);
			    }
		    }
	    }
    }
}

DefaultProperties
{
    RemoveEffects=true
}