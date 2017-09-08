//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeSoldierRankSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeSoldierRankSelectors extends X2ChallengeElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// All One Rank Selectors
	Templates.AddItem(CreateAllSquaddiesSelector());
	Templates.AddItem(CreateAllCorporalsSelector());
	Templates.AddItem(CreateAllSergeantsSelector());
	Templates.AddItem(CreateAllLieutenantsSelector());
	Templates.AddItem(CreateAllCaptainsSelector());
	Templates.AddItem(CreateAllMajorsSelector());
	Templates.AddItem(CreateAllColonelsSelector());

	// All One Rank Single Branch Selectors
	Templates.AddItem(CreateAllCorporalsSingleBranchSelector());
	Templates.AddItem(CreateAllSergeantsSingleBranchSelector());
	Templates.AddItem(CreateAllLieutenantsSingleBranchSelector());
	Templates.AddItem(CreateAllCaptainsSingleBranchSelector());
	Templates.AddItem(CreateAllMajorsSingleBranchSelector());
	Templates.AddItem(CreateAllColonelsSingleBranchSelector());

	// Mixed Rank Selectors
	Templates.AddItem(CreateLowRankSelector());
	Templates.AddItem(CreateMediumRankSelector());
	Templates.AddItem(CreateHighRankSelector());
	Templates.AddItem(CreateHalfHighHalfLowRankSelector());
	Templates.AddItem(CreateOneHighRestLowRankSelector());

	// Mixed Rank Single Branch Selectors
	Templates.AddItem(CreateLowRankSingleBranchSelector());
	Templates.AddItem(CreateMediumRankSingleBranchSelector());
	Templates.AddItem(CreateHighRankSingleBranchSelector());
	Templates.AddItem(CreateHalfHighHalfLowRankSingleBranchSelector());
	Templates.AddItem(CreateOneHighRestLowRankSingleBranchSelector());

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllSquaddiesSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllSquaddies');

	Template.Weight = 5;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.SelectSoldierRanksFn = AllSquaddiesSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllSquaddiesSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(1);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllCorporalsSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllCorporals');

	Template.Weight = 5;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.SelectSoldierRanksFn = AllCorporalsSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllCorporalsSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(2);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllCorporalsSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllCorporalsSingleBranch');

	Template.Weight = 6;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.SelectSoldierRanksFn = AllCorporalsSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllCorporalsSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(2);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllSergeantsSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllSergeants');

	Template.Weight = 7;
	Template.SelectSoldierRanksFn = AllSergeantsSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllSergeantsSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(3);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllSergeantsSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllSergeantsSingleBranch');

	Template.Weight = 8;
	Template.SelectSoldierRanksFn = AllSergeantsSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllSergeantsSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(3);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllLieutenantsSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllLieutenants');

	Template.Weight = 7;
	Template.SelectSoldierRanksFn = AllLieutenantsSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllLieutenantsSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(4);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllLieutenantsSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllLieutenantsSingleBranch');

	Template.Weight = 8;
	Template.SelectSoldierRanksFn = AllLieutenantsSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllLieutenantsSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(4);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllCaptainsSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllCaptains');

	Template.Weight = 7;
	Template.SelectSoldierRanksFn = AllLieutenantsSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllCaptainsSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(5);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllCaptainsSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllCaptainsSingleBranch');

	Template.Weight = 8;
	Template.SelectSoldierRanksFn = AllLieutenantsSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllCaptainsSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(5);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllMajorsSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllMajors');

	Template.Weight = 4;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierRanksFn = AllMajorsSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllMajorsSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(6);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllMajorsSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllMajorsSingleBranch');

	Template.Weight = 5;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierRanksFn = AllMajorsSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllMajorsSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(6);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllColonelsSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllColonels');

	Template.Weight = 4;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierRanksFn = AllColonelsSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllColonelsSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(7);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateAllColonelsSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_AllColonelsSingleBranch');

	Template.Weight = 5;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierRanksFn = AllColonelsSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function AllColonelsSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(7);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateLowRankSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_LowRank');

	Template.Weight = 7;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.SelectSoldierRanksFn = LowRankSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function LowRankSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(1);
	NumRanks.AddItem(2);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateLowRankSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_LowRankSingleBranch');

	Template.Weight = 8;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.SelectSoldierRanksFn = LowRankSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function LowRankSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(1);
	NumRanks.AddItem(2);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateMediumRankSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_MediumRank');

	Template.Weight = 9;
	Template.SelectSoldierRanksFn = MediumRankSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function MediumRankSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(3);
	NumRanks.AddItem(4);
	NumRanks.AddItem(5);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateMediumRankSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_MediumRankSingleBranch');

	Template.Weight = 10;
	Template.SelectSoldierRanksFn = MediumRankSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function MediumRankSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(3);
	NumRanks.AddItem(4);
	NumRanks.AddItem(5);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateHighRankSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_HighRank');

	Template.Weight = 6;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierRanksFn = HighRankSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function HighRankSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks;

	NumRanks.AddItem(6);
	NumRanks.AddItem(7);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateHighRankSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_HighRankSingleBranch');

	Template.Weight = 7;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierRanksFn = HighRankSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function HighRankSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> NumRanks, BranchNums;
	local array<name> ClassTemplateNames;

	NumRanks.AddItem(6);
	NumRanks.AddItem(7);
	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiers(StartState, XComUnits, NumRanks, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateHalfHighHalfLowRankSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_HalfHighHalfLowRank');

	Template.Weight = 8;
	Template.SelectSoldierRanksFn = HalfHighHalfLowRankSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function HalfHighHalfLowRankSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	RankUpAllSoldiersHalfHighHalfLow(StartState, XComUnits);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateHalfHighHalfLowRankSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_HalfHighHalfLowRankSingleBranch');

	Template.Weight = 9;
	Template.SelectSoldierRanksFn = HalfHighHalfLowRankSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function HalfHighHalfLowRankSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> BranchNums;
	local array<name> ClassTemplateNames;

	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiersHalfHighHalfLow(StartState, XComUnits, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateOneHighRestLowRankSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_OneHighRestLowRank');

	Template.Weight = 9;
	Template.SelectSoldierRanksFn = OneHighRestLowRankSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function OneHighRestLowRankSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	RankUpAllSoldiersOneHighRestLow(StartState, XComUnits);
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierRank CreateOneHighRestLowRankSingleBranchSelector()
{
	local X2ChallengeSoldierRank	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierRank', Template, 'ChallengeRank_OneHighRestLowRankSingleBranch');

	Template.Weight = 10;
	Template.SelectSoldierRanksFn = OneHighRestLowRankSingleBranchSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function OneHighRestLowRankSingleBranchSelector(X2ChallengeSoldierRank Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local array<int> BranchNums;
	local array<name> ClassTemplateNames;

	BuildClassBranchMap(XComUnits, ClassTemplateNames, BranchNums);
	RankUpAllSoldiersOneHighRestLow(StartState, XComUnits, ClassTemplateNames, BranchNums);
}

//---------------------------------------------------------------------------------------
static function RankUpAllSoldiersOneHighRestLow(XComGameState StartState, array<XComGameState_Unit> XComUnits, optional array<name> ClassTemplateNames, optional array<int> BranchNums)
{
	local XComGameState_Unit UnitState;
	local array<int> LowRanks, HighRanks;
	local int RandRank, BranchNum, Index;
	local bool bHighRank;

	bHighRank = true;
	LowRanks.AddItem(1);
	LowRanks.AddItem(2);
	HighRanks.AddItem(6);
	HighRanks.AddItem(7);

	foreach XComUnits(UnitState)
	{
		if(bHighRank)
		{
			RandRank = HighRanks[`SYNC_RAND_STATIC(HighRanks.Length)];
		}
		else
		{
			RandRank = LowRanks[`SYNC_RAND_STATIC(LowRanks.Length)];
		}

		Index = ClassTemplateNames.Find(UnitState.GetSoldierClassTemplateName());

		if(Index == INDEX_NONE)
		{
			BranchNum = -1;
		}
		else
		{
			BranchNum = BranchNums[Index];
		}

		RankUpSoldier(StartState, UnitState, RandRank, BranchNum);
		bHighRank = false;
	}
}

//---------------------------------------------------------------------------------------
static function RankUpAllSoldiersHalfHighHalfLow(XComGameState StartState, array<XComGameState_Unit> XComUnits, optional array<name> ClassTemplateNames, optional array<int> BranchNums)
{
	local XComGameState_Unit UnitState;
	local array<int> LowRanks, HighRanks;
	local int RandRank, BranchNum, Index;
	local bool bHighRank;

	bHighRank = true;
	LowRanks.AddItem(1);
	LowRanks.AddItem(2);
	HighRanks.AddItem(6);
	HighRanks.AddItem(7);

	foreach XComUnits(UnitState)
	{
		if(bHighRank)
		{
			RandRank = HighRanks[`SYNC_RAND_STATIC(HighRanks.Length)];
		}
		else
		{
			RandRank = LowRanks[`SYNC_RAND_STATIC(LowRanks.Length)];
		}

		Index = ClassTemplateNames.Find(UnitState.GetSoldierClassTemplateName());

		if(Index == INDEX_NONE)
		{
			BranchNum = -1;
		}
		else
		{
			BranchNum = BranchNums[Index];
		}

		RankUpSoldier(StartState, UnitState, RandRank, BranchNum);
		bHighRank = !bHighRank;
	}
}

//---------------------------------------------------------------------------------------
static function RankUpAllSoldiers(XComGameState StartState, array<XComGameState_Unit> XComUnits, array<int> NumRanks, optional array<name> ClassTemplateNames, optional array<int> BranchNums)
{
	local XComGameState_Unit UnitState;
	local int RandRank, BranchNum, Index;

	foreach XComUnits(UnitState)
	{
		RandRank = NumRanks[`SYNC_RAND_STATIC(NumRanks.Length)];
		Index = ClassTemplateNames.Find(UnitState.GetSoldierClassTemplateName());

		if(Index == INDEX_NONE)
		{
			BranchNum = -1;
		}
		else
		{
			BranchNum = BranchNums[Index];
		}

		RankUpSoldier(StartState, UnitState, RandRank, BranchNum);
	}
}

//---------------------------------------------------------------------------------------
static function RankUpSoldier(XComGameState StartState, XComGameState_Unit UnitState, int NumRanks, optional int ForcedBranch = -1)
{
	local SCATProgression Progress;
	local array<SCATProgression> SoldierProgression;
	local array<SoldierClassAbilityType> RankAbilities;
	local name ClassTemplateName;
	local bool bFactionSoldier, bRandomBranch;
	local int idx, i, BranchNum;

	ClassTemplateName = UnitState.GetSoldierClassTemplateName();
	bFactionSoldier = (ClassTemplateName == 'Reaper' || ClassTemplateName == 'Templar' || ClassTemplateName == 'Skirmisher');
	BranchNum = ForcedBranch;
	bRandomBranch = (BranchNum == -1);

	// Sometimes we want to pick all from the same random branch vs random at every rank
	if(bRandomBranch)
	{
		if(class'X2StrategyGameRulesetDataStructures'.static.Roll(66))
		{
			bRandomBranch = false;

			if(bFactionSoldier)
			{
				BranchNum = `SYNC_RAND_STATIC(3);
			}
			else
			{
				BranchNum = `SYNC_RAND_STATIC(2);
			}
		}
	}

	for(idx = 0; idx < NumRanks; idx++)
	{
		Progress.iRank = idx;

		if(idx == 0)
		{
			// Faction Soldiers start at Squaddie
			if(!bFactionSoldier)
			{
				UnitState.RankUpSoldier(StartState, ClassTemplateName);
			}
			
			RankAbilities = UnitState.AbilityTree[0].Abilities;

			for(i = 0; i < RankAbilities.Length; ++i)
			{
				if(RankAbilities[i].AbilityName != '')
				{
					Progress.iBranch = i;
					SoldierProgression.AddItem(Progress);
				}
			}
		}
		else
		{
			UnitState.RankUpSoldier(StartState, ClassTemplateName);
			RankAbilities = UnitState.AbilityTree[idx].Abilities;

			if(bRandomBranch)
			{
				BranchNum = PickRandomBranch(UnitState, idx, bFactionSoldier);
			}

			if(RankAbilities[BranchNum].AbilityName != '')
			{
				Progress.iBranch = BranchNum;
				SoldierProgression.AddItem(Progress);
			}
		}
	}

	UnitState.SetSoldierProgression(SoldierProgression);
}

//---------------------------------------------------------------------------------------
static function int PickRandomBranch(XComGameState_Unit UnitState, int RankNum, bool bFactionSoldier)
{
	local array<SoldierClassAbilityType> RankAbilities;
	local array<int> ValidIndices;
	local int MaxIndex, idx;

	RankAbilities = UnitState.AbilityTree[RankNum].Abilities;
	ValidIndices.Length = 0;

	if(bFactionSoldier)
	{
		MaxIndex = 2;
	}
	else
	{
		MaxIndex = 1;
	}

	for(idx = 0; idx <= MaxIndex; idx++)
	{
		if(RankAbilities[idx].AbilityName != '')
		{
			ValidIndices.AddItem(idx);
		}
	}

	if(ValidIndices.Length > 0)
	{
		return ValidIndices[`SYNC_RAND_STATIC(ValidIndices.Length)];
	}

	return 0;
}

//---------------------------------------------------------------------------------------
static function BuildClassBranchMap(array<XComGameState_Unit> XComUnits, out array<name> ClassTemplateNames, out array<int> BranchNums)
{
	local XComGameState_Unit UnitState;
	local name ClassTemplateName;

	foreach XComUnits(UnitState)
	{
		ClassTemplateName = UnitState.GetSoldierClassTemplateName();

		if(ClassTemplateNames.Find(ClassTemplateName) == INDEX_NONE)
		{
			ClassTemplateNames.AddItem(ClassTemplateName);

			if(ClassTemplateName == 'Reaper' || ClassTemplateName == 'Templar' || ClassTemplateName == 'Skirmisher')
			{
				BranchNums.AddItem(`SYNC_RAND_STATIC(3));
			}
			else
			{
				BranchNums.AddItem(`SYNC_RAND_STATIC(2));
			}
		}
	}
}

defaultproperties
{
	bShouldCreateDifficultyVariants = false
}