//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeSoldierClassSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeSoldierClassSelectors extends X2ChallengeElement;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates( )
{
	local array<X2DataTemplate> Templates;
	
	// Random selectors
	Templates.AddItem(CreateRandomAllSelector());
	Templates.AddItem(CreateRandomVanillaSelector());
	Templates.AddItem(CreateRandomFactionSelector());

	// All one class selectors
	Templates.AddItem(CreateAllPsiSelector());
	Templates.AddItem(CreateAllReaperSelector());
	Templates.AddItem(CreateAllTemplarSelector());
	Templates.AddItem(CreateAllSkirmisherSelector());
	Templates.AddItem(CreateAllRangerSelector());
	Templates.AddItem(CreateAllSpecialistSelector());
	Templates.AddItem(CreateAllSharpshooterSelector());
	Templates.AddItem(CreateAllGrenadierSelector());

	// Split class selectors
	Templates.AddItem(CreateSplitReaperRangerSelector());
	Templates.AddItem(CreateSplitReaperSharpshooterSelector());
	Templates.AddItem(CreateSplitTemplarPsiOpSelector());
	Templates.AddItem(CreateSplitTemplarRangerSelector());
	Templates.AddItem(CreateSplitSkirmisherSpecialistSelector());
	Templates.AddItem(CreateSplitSkirmisherGrenadierSelector());
	Templates.AddItem(CreateSplitSpecialistGrenadierSelector());
	Templates.AddItem(CreateSplitRangerSharpshooterSelector());

	return Templates;
}

//---------------------------------------------------------------------------------------
// RANDOM SELECTORS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateRandomAllSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_RandomAll');

	Template.Weight = 10;

	Template.WeightedSoldierClasses.AddItem(CreateEntry('Sharpshooter', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Grenadier', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Specialist', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Ranger', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('PsiOperative', 1));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Reaper', 1));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Templar', 1));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Skirmisher', 1));

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateRandomVanillaSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_RandomVanilla');

	Template.Weight = 10;

	Template.WeightedSoldierClasses.AddItem(CreateEntry('Sharpshooter', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Grenadier', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Specialist', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Ranger', 2));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('PsiOperative', 1));

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateRandomFactionSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_RandomFaction');

	Template.Weight = 10;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');

	Template.WeightedSoldierClasses.AddItem(CreateEntry('Reaper', 1));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Templar', 1));
	Template.WeightedSoldierClasses.AddItem(CreateEntry('Skirmisher', 1));

	return Template;
}

//---------------------------------------------------------------------------------------
// ALL ONE CLASS SELECTORS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllPsiSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllPsi');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllPsiSelector;

	return Template;
}
static function array<name> AllPsiSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('PsiOperative', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllReaperSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllReaper');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllReaperSelector;

	return Template;
}
static function array<name> AllReaperSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('Reaper', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllTemplarSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllTemplar');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllTemplarSelector;

	return Template;
}
static function array<name> AllTemplarSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('Templar', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllSkirmisherSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllSkirmisher');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllSkirmisherSelector;

	return Template;
}
static function array<name> AllSkirmisherSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('Skirmisher', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllRangerSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllRanger');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllRangerSelector;

	return Template;
}
static function array<name> AllRangerSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('Ranger', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllSpecialistSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllSpecialist');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllSpecialistSelector;

	return Template;
}
static function array<name> AllSpecialistSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('Specialist', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllSharpshooterSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllSharpshooter');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllSharpshooterSelector;

	return Template;
}
static function array<name> AllSharpshooterSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('Sharpshooter', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateAllGrenadierSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_AllGrenadier');

	Template.Weight = 3;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = AllGrenadierSelector;

	return Template;
}
static function array<name> AllGrenadierSelector(X2ChallengeSoldierClass Selector, int count)
{
	return AllOneClassSelector('Grenadier', count);
}

//---------------------------------------------------------------------------------------
// SPLIT CLASS SELECTORS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitReaperRangerSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitReaperRanger');

	Template.Weight = 7;
	Template.SelectSoldierClassesFn = SplitReaperRangerSelector;

	return Template;
}
static function array<name> SplitReaperRangerSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Reaper', 'Ranger', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitReaperSharpshooterSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitReaperSharpshooter');

	Template.Weight = 7;
	Template.SelectSoldierClassesFn = SplitReaperSharpshooterSelector;

	return Template;
}
static function array<name> SplitReaperSharpshooterSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Reaper', 'Sharpshooter', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitTemplarPsiOpSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitTemplarPsiOp');

	Template.Weight = 7;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.SelectSoldierClassesFn = SplitTemplarPsiOpSelector;

	return Template;
}
static function array<name> SplitTemplarPsiOpSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Templar', 'PsiOperative', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitTemplarRangerSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitTemplarRanger');

	Template.Weight = 7;
	Template.SelectSoldierClassesFn = SplitTemplarRangerSelector;

	return Template;
}
static function array<name> SplitTemplarRangerSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Templar', 'Ranger', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitSkirmisherSpecialistSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitSkirmisherSpecialist');

	Template.Weight = 7;
	Template.SelectSoldierClassesFn = SplitSkirmisherSpecialistSelector;

	return Template;
}
static function array<name> SplitSkirmisherSpecialistSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Skirmisher', 'Specialist', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitSkirmisherGrenadierSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitSkirmisherGrenadier');

	Template.Weight = 7;
	Template.SelectSoldierClassesFn = SplitSkirmisherGrenadierSelector;

	return Template;
}
static function array<name> SplitSkirmisherGrenadierSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Skirmisher', 'Grenadier', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitSpecialistGrenadierSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitSpecialistGrenadier');

	Template.Weight = 7;
	Template.SelectSoldierClassesFn = SplitSpecialistGrenadierSelector;

	return Template;
}
static function array<name> SplitSpecialistGrenadierSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Specialist', 'Grenadier', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSoldierClass CreateSplitRangerSharpshooterSelector()
{
	local X2ChallengeSoldierClass	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSoldierClass', Template, 'ChallengeSoldiers_SplitRangerSharpshooter');

	Template.Weight = 7;
	Template.SelectSoldierClassesFn = SplitRangerSharpshooterSelector;

	return Template;
}
static function array<name> SplitRangerSharpshooterSelector(X2ChallengeSoldierClass Selector, int count)
{
	return SplitClassSelector('Ranger', 'Sharpshooter', count);
}

//---------------------------------------------------------------------------------------
// HELPERS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
private static function array<name> AllOneClassSelector(name ClassName, int count)
{
	local array<name> SoldierClasses;

	for(count = count; count > 0; --count)
	{
		SoldierClasses.AddItem(ClassName);
	}

	return SoldierClasses;
}
//---------------------------------------------------------------------------------------
private static function array<name> SplitClassSelector(name ClassNameA, name ClassNameB, int count)
{
	local array<name> SoldierClasses;

	for(count = count; count > 0; --count)
	{
		if((count % 2) == 0)
		{
			SoldierClasses.AddItem(ClassNameA);
		}
		else
		{
			SoldierClasses.AddItem(ClassNameB);
		}
	}

	return SoldierClasses;
}


defaultproperties
{
	bShouldCreateDifficultyVariants = false
}