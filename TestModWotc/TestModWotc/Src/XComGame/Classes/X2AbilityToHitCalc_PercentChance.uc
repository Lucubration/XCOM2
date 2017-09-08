//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityToHitCalc_PercentChange.uc
//  AUTHOR:  Scott Boeckmann
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AbilityToHitCalc_PercentChance extends X2AbilityToHitCalc;

var() int PercentToHit;
var() bool bNoGameStateOnMiss;

function bool NoGameStateOnMiss() { return bNoGameStateOnMiss; }

protected function int GetPercentToHit(XComGameState_Ability kAbility, AvailableTarget kTarget)
{
	return PercentToHit;
}

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
	local int MultiIndex, RandRoll;
	local ArmorMitigationResults NoArmor;
	local int LocalPercentToHit;

	LocalPercentToHit = GetPercentToHit(kAbility, kTarget);

	RandRoll = `SYNC_RAND_TYPED(100, ESyncRandType_Generic);
	ResultContext.HitResult = RandRoll < LocalPercentToHit ? eHit_Success : eHit_Miss;
	ResultContext.ArmorMitigation = NoArmor;
	ResultContext.CalculatedHitChance = LocalPercentToHit;

	for (MultiIndex = 0; MultiIndex < kTarget.AdditionalTargets.Length; ++MultiIndex)
	{
		RandRoll = `SYNC_RAND_TYPED(100, ESyncRandType_Generic);
		ResultContext.MultiTargetHitResults.AddItem(RandRoll < LocalPercentToHit ? eHit_Success : eHit_Miss);
		ResultContext.MultiTargetArmorMitigation.AddItem(NoArmor);
		ResultContext.MultiTargetStatContestResult.AddItem(0);
	}
}

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog = false)
{
	return GetPercentToHit(kAbility, kTarget);
}

function int GetShotBreakdown(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog = false)
{
	m_ShotBreakdown.HideShotBreakdown = true;
	m_ShotBreakdown.FinalHitChance = GetPercentToHit(kAbility, kTarget);
	return m_ShotBreakdown.FinalHitChance;
}

defaultproperties
{
	PercentToHit=100;
}