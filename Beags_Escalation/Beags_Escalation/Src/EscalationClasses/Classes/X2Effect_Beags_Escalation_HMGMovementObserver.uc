class X2Effect_Beags_Escalation_HMGMovementObserver extends X2Effect_PersistentStatChange;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local EffectAppliedData MovedEffectData;
	local X2Effect_Persistent MovedEffect;

	if (AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length > 0)
	{
		// If the unit moved for any reason, try to apply the moved effect
		MovedEffectData.EffectRef.SourceTemplateName = 'Beags_Escalation_HMGMoved';
		MovedEffectData.EffectRef.LookupType = TELT_AbilityTargetEffects;
		MovedEffectData.EffectRef.TemplateEffectLookupArrayIndex = 0;
		MovedEffectData.PlayerStateObjectRef = SourceUnit.ControllingPlayer;
		MovedEffectData.SourceStateObjectRef = SourceUnit.GetReference();
		MovedEffectData.TargetStateObjectRef = SourceUnit.GetReference();
		MovedEffect = X2Effect_Persistent(class'X2Effect'.static.GetX2Effect(MovedEffectData.EffectRef));
		if (MovedEffect != none)
			MovedEffect.ApplyEffect(MovedEffectData, SourceUnit, NewGameState);
	}

	return false;
}
