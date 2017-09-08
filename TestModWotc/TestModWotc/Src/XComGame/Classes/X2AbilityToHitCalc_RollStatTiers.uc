class X2AbilityToHitCalc_RollStatTiers extends X2AbilityToHitCalc;

struct StatContestTier
{
	var int BasePercentChance;
	var bool bUseStatInCheck;
};

// Ordered array of percent checks that the ability should use to apply the correct effects
var protected array<StatContestTier> StatContestTiers;

var ECharStatType StatToRoll;	// All checks are done with one stat

function AddNextStatContestTier(int BasePercentChance=100, bool bUseStatInCheck=true)
{
	local StatContestTier NewStatContestTier;

	NewStatContestTier.BasePercentChance = BasePercentChance;
	NewStatContestTier.bUseStatInCheck = bUseStatInCheck;

	StatContestTiers.AddItem(NewStatContestTier);
}

// Use the last entry in StatContestTiers as the final chance for this to be a successful hit
protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog = false)
{
	local XComGameState_Unit UnitState;
	local int FinalHitChance;

	FinalHitChance = 0;

	if (StatContestTiers.Length > 0)
	{
		FinalHitChance = StatContestTiers[StatContestTiers.Length - 1].BasePercentChance;

		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID));
		if ((UnitState != None) && StatContestTiers[StatContestTiers.Length - 1].bUseStatInCheck)
		{
			FinalHitChance -= UnitState.GetCurrentStat(StatToRoll);
		}
	}

	return FinalHitChance;
}

// The array is in the order of expected StatContestResult. Because a StatContestResult of 0 means nothing, adding 1 to the
// current index inside the search loop of StatContestTiers gives the effect's corresponding value.
function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
	local int StatVal, HitChance, RandRoll, i;
	local XComGameState_Unit TargetState;

	ResultContext.HitResult = eHit_Miss;

	TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID));
	if (TargetState != None)
	{
		StatVal = TargetState.GetCurrentStat(StatToRoll);
		
		for (i = 0; i < StatContestTiers.Length; ++i)
		{
			HitChance = StatContestTiers[i].BasePercentChance;
			if (StatContestTiers[i].bUseStatInCheck)
			{
				HitChance -= StatVal;
			}
			RandRoll = `SYNC_RAND(100);

			if (RandRoll < HitChance)
			{
				`log("RollStatTiers for stat" @ StatToRoll @ "@" @ HitChance @ "rolled" @ RandRoll @ "== Success!", true, 'XCom_HitRolls');
				ResultContext.HitResult = eHit_Success;
				ResultContext.StatContestResult = i + 1;	// Add one because a contest result of 0 means nothing
				break;
			}
			else
			{
				`log("RollStatTiers for stat" @ StatToRoll @ "@" @ HitChance @ "rolled" @ RandRoll @ "== Miss!", true, 'XCom_HitRolls');
			}
		}
	}
}

defaultproperties
{
	StatToRoll=eStat_Will
}