//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeArmorSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeArmorSelectors extends X2ChallengeElement;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Standard Medium Armors
	Templates.AddItem(CreateStandardConventionalArmor());
	Templates.AddItem(CreateStandardPlatedArmor());
	Templates.AddItem(CreateStandardPoweredArmor());

	// Random Armor Sizes
	Templates.AddItem(CreateRandomPlatedArmor());
	Templates.AddItem(CreateRandomPoweredArmor());

	// All Light Armors
	Templates.AddItem(CreateLightPlatedArmor());
	Templates.AddItem(CreateLightPoweredArmor());

	// All Heavy Armors
	Templates.AddItem(CreateHeavyPlatedArmor());
	Templates.AddItem(CreateHeavyPoweredArmor());

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateStandardConventionalArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeStandardConventionalArmor');

	Template.Weight = 7;
	Template.SelectArmorFn = StandardConventionalArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function StandardConventionalArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'ReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'TemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'SkirmisherArmor';
			break;
		default:
			ArmorTemplateName = 'KevlarArmor';
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateStandardPlatedArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeStandardPlatedArmor');

	Template.Weight = 10;
	Template.SelectArmorFn = StandardPlatedArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function StandardPlatedArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PlatedReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PlatedTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PlatedSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = 'MediumPlatedArmor';
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateStandardPoweredArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeStandardPoweredArmor');

	Template.Weight = 5;
	Template.SelectArmorFn = StandardPoweredArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function StandardPoweredArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PoweredReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PoweredTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PoweredSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = 'MediumPoweredArmor';
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateRandomPlatedArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeRandomPlatedArmor');

	Template.Weight = 8;
	Template.SelectArmorFn = RandomPlatedArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function RandomPlatedArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;
	local array<name> RandomArmors;

	RandomArmors.AddItem('LightPlatedArmor');
	RandomArmors.AddItem('MediumPlatedArmor');
	RandomArmors.AddItem('HeavyPlatedArmor');

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PlatedReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PlatedTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PlatedSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = RandomArmors[`SYNC_RAND_STATIC(RandomArmors.Length)];
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateRandomPoweredArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeRandomPoweredArmor');

	Template.Weight = 5;
	Template.SelectArmorFn = RandomPoweredArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function RandomPoweredArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;
	local array<name> RandomArmors;

	RandomArmors.AddItem('LightPoweredArmor');
	RandomArmors.AddItem('MediumPoweredArmor');
	RandomArmors.AddItem('HeavyPoweredArmor');

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PoweredReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PoweredTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PoweredSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = RandomArmors[`SYNC_RAND_STATIC(RandomArmors.Length)];
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateLightPlatedArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeLightPlatedArmor');

	Template.Weight = 7;
	Template.SelectArmorFn = LightPlatedArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function LightPlatedArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PlatedReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PlatedTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PlatedSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = 'LightPlatedArmor';
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateLightPoweredArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeLightPoweredArmor');

	Template.Weight = 3;
	Template.SelectArmorFn = LightPoweredArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function LightPoweredArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PoweredReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PoweredTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PoweredSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = 'LightPoweredArmor';
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateHeavyPlatedArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeHeavyPlatedArmor');

	Template.Weight = 6;
	Template.SelectArmorFn = HeavyPlatedArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function HeavyPlatedArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PlatedReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PlatedTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PlatedSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = 'HeavyPlatedArmor';
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

//---------------------------------------------------------------------------------------
static function X2ChallengeArmor CreateHeavyPoweredArmor()
{
	local X2ChallengeArmor	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeArmor', Template, 'ChallengeHeavyPoweredArmor');

	Template.Weight = 2;
	Template.SelectArmorFn = HeavyPoweredArmorSelector;

	return Template;
}

//---------------------------------------------------------------------------------------
static function HeavyPoweredArmorSelector(X2ChallengeArmor Selector, array<XComGameState_Unit> XComUnits, XComGameState StartState)
{
	local XComGameState_Unit Unit;
	local name ArmorTemplateName;

	foreach XComUnits(Unit)
	{
		switch(Unit.GetSoldierClassTemplateName())
		{
		case 'Reaper':
			ArmorTemplateName = 'PoweredReaperArmor';
			break;
		case 'Templar':
			ArmorTemplateName = 'PoweredTemplarArmor';
			break;
		case 'Skirmisher':
			ArmorTemplateName = 'PoweredSkirmisherArmor';
			break;
		default:
			ArmorTemplateName = 'HeavyPoweredArmor';
		}

		class'X2ChallengeArmor'.static.ApplyArmor(ArmorTemplateName, Unit, StartState);
	}
}

defaultproperties
{
	bShouldCreateDifficultyVariants = false
}