class X2Effect_SpectralZombie extends X2Effect_SpectralArmyUnit config(GameCore);

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit SpectralUnit;

	SpectralUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( SpectralUnit != None )
	{
		// Jwats: Only call the super if we aren't going to explode. The super removes us from play and we fail to activate the explode ability
		if( SpectralUnit.AffectedByEffectNames.Find(class'X2Ability_ChosenWarlock'.default.PsiSelfDestructEffectName) == INDEX_NONE )
		{
			super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
		}
	}	
}

DefaultProperties
{
	EffectName="SpectralZombieEffect"
}