//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeSquadAlienSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeSquadAlienSelectors extends X2ChallengeElement;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates( )
{
	local array<X2DataTemplate> Templates;

	// Random Selectors
	Templates.AddItem(CreateAllRandomSelector());
	Templates.AddItem(CreateRandomAdventSelector());
	Templates.AddItem(CreateRandomAliensSelector());

	// Tribe Selectors
	Templates.AddItem(CreateRobotTribeSelector());
	Templates.AddItem(CreatePsiTribeSelector());
	Templates.AddItem(CreateBeastTribeSelector());

	// All One Alien Selectors
	Templates.AddItem(CreateAllPurifiersSelector());
	Templates.AddItem(CreateAllPriestsSelector());
	Templates.AddItem(CreateAllSpectresSelector());
	Templates.AddItem(CreateAllStunLancersSelector());
	Templates.AddItem(CreateAllMECsSelector());
	Templates.AddItem(CreateAllVipersSelector());
	Templates.AddItem(CreateAllChryssalidsSelector());
	Templates.AddItem(CreateAllMutonsSelector());
	Templates.AddItem(CreateAllBerserkersSelector());
	Templates.AddItem(CreateAllArchonsSelector());
	Templates.AddItem(CreateAllAndromedonsSelector());
	Templates.AddItem(CreateAllCodicesSelector());
	Templates.AddItem(CreateAllSectoidsSelector());

	// Other Selectors
	Templates.AddItem(CreateVipersMutonsSelector());
	Templates.AddItem(CreateBerserkersMutonsSelector());
	Templates.AddItem(CreateSingleSectopodSelector());
	Templates.AddItem(CreateSingleSectopodRandomAdventSelector());
	Templates.AddItem(CreateSingleSectopodRandomAliensSelector());
	Templates.AddItem(CreateSingleGatekeeperSelector());
	Templates.AddItem(CreateSingleGatekeeperRandomAdventSelector());
	Templates.AddItem(CreateSingleGatekeeperRandomAliensSelector());

	return Templates;
}

//---------------------------------------------------------------------------------------
// RANDOM SELECTORS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllRandomSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllRandom');

	Template.Weight = 7;

	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvTrooperMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvCaptainMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvStunLancerMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvShieldBearerMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvMEC_MP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvPurifierMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvPriestMP', 1));

	Template.WeightedAlienTypes.AddItem(CreateEntry('SectoidMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('FacelessMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('ViperMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('MutonMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('CyberusMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('BerserkerMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('ArchonMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('ChryssalidMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AndromedonMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('SpectreMP', 1));

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateRandomAdventSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_RandomAdvent');

	Template.Weight = 7;

	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvTrooperMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvCaptainMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvStunLancerMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvShieldBearerMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvMEC_MP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvPurifierMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvPriestMP', 1));

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateRandomAliensSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_RandomAliens');

	Template.Weight = 7;

	Template.WeightedAlienTypes.AddItem(CreateEntry('SectoidMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('FacelessMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('ViperMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('MutonMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('CyberusMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('BerserkerMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('ArchonMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('ChryssalidMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AndromedonMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('SpectreMP', 1));

	return Template;
}

//---------------------------------------------------------------------------------------
// TRIBE SELECTORS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateRobotTribeSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_RobotTribe');

	Template.Weight = 10;

	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvMEC_MP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('AndromedonMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('SpectreMP', 1));

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreatePsiTribeSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_PsiTribe');

	Template.Weight = 10;

	Template.WeightedAlienTypes.AddItem(CreateEntry('AdvPriestMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('SectoidMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('CyberusMP', 1));

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateBeastTribeSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_BeastTribe');

	Template.Weight = 10;

	Template.WeightedAlienTypes.AddItem(CreateEntry('FacelessMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('BerserkerMP', 1));
	Template.WeightedAlienTypes.AddItem(CreateEntry('ChryssalidMP', 1));

	return Template;
}

//---------------------------------------------------------------------------------------
// ALL ONE ALIEN SELECTORS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllPurifiersSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllPurifiers');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllPurifiersSelector;

	return Template;
}
static function array<name> AllPurifiersSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('AdvPurifierMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllPriestsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllPriests');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllPriestsSelector;

	return Template;
}
static function array<name> AllPriestsSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('AdvPriestMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllSpectresSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllSpectres');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllSpectresSelector;

	return Template;
}
static function array<name> AllSpectresSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('SpectreMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllStunLancersSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllStunLancers');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllStunLancersSelector;

	return Template;
}
static function array<name> AllStunLancersSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('AdvStunLancerMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllMECsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllMECs');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllMECsSelector;

	return Template;
}
static function array<name> AllMECsSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('AdvMEC_MP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllVipersSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllVipers');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllVipersSelector;

	return Template;
}
static function array<name> AllVipersSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('ViperMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllChryssalidsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllChryssalids');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllChryssalidsSelector;

	return Template;
}
static function array<name> AllChryssalidsSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('ChryssalidMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllMutonsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllMutons');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllMutonsSelector;

	return Template;
}
static function array<name> AllMutonsSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('MutonMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllBerserkersSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllBerserkers');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllBerserkersSelector;

	return Template;
}
static function array<name> AllBerserkersSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('BerserkerMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllArchonsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllArchons');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllArchonsSelector;

	return Template;
}
static function array<name> AllArchonsSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('ArchonMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllAndromedonsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllAndromedons');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllAndromedonsSelector;

	return Template;
}
static function array<name> AllAndromedonsSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('AndromedonMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllCodicesSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllCodices');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllCodicesSelector;

	return Template;
}
static function array<name> AllCodicesSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('CyberusMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateAllSectoidsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_AllSectoids');

	Template.Weight = 2;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.SelectSquadAliensFn = AllSectoidsSelector;

	return Template;
}
static function array<name> AllSectoidsSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('SectoidMP', count);
}

//---------------------------------------------------------------------------------------
// OTHER SELECTORS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateVipersMutonsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_VipersMutons');

	Template.Weight = 7;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.SelectSquadAliensFn = VipersMutonsSelector;

	return Template;
}
static function array<name> VipersMutonsSelector(X2ChallengeSquadAlien Selector, int count)
{
	local array<name> AlienTypes;

	for(count = count; count > 0; --count)
	{
		if((count % 2) == 0)
		{
			AlienTypes.AddItem('ViperMP');
		}
		else
		{
			AlienTypes.AddItem('MutonMP');
		}
		
	}

	return AlienTypes;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateBerserkersMutonsSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_BerserkersMutons');

	Template.Weight = 7;
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.SelectSquadAliensFn = BerserkersMutonsSelector;

	return Template;
}
static function array<name> BerserkersMutonsSelector(X2ChallengeSquadAlien Selector, int count)
{
	local array<name> AlienTypes;

	for(count = count; count > 0; --count)
	{
		if((count % 2) == 0)
		{
			AlienTypes.AddItem('BerserkerMP');
		}
		else
		{
			AlienTypes.AddItem('MutonMP');
		}

	}

	return AlienTypes;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateSingleSectopodSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_SingleSectopod');

	Template.Weight = 1;

	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienAliens');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienMixed');

	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienXCom');
	
	Template.SelectSquadAliensFn = SingleSectopodSelector;

	return Template;
}
static function array<name> SingleSectopodSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('SectopodMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateSingleSectopodRandomAdventSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_SingleSectopodRandomAdvent');

	Template.Weight = 1;
	
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienXCom');

	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienAliens');
	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienMixed');

	Template.SelectSquadAliensFn = SingleSectopodRandomAdventSelector;

	return Template;
}
static function array<name> SingleSectopodRandomAdventSelector(X2ChallengeSquadAlien Selector, int count)
{
	local X2ChallengeSquadAlien Template;
	local array<name> AlienTypes;

	Template = X2ChallengeSquadAlien(class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager().FindChallengeTemplate('ChallengeAlienSquad_RandomAdvent'));
	AlienTypes = class'X2ChallengeSquadAlien'.static.WeightedTypeSelected(Template, (count - 1));
	AlienTypes.AddItem('SectopodMP');

	return AlienTypes;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateSingleSectopodRandomAliensSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_SingleSectopodRandomAliens');

	Template.Weight = 1;
	
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienXCom');

	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienAliens');
	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienMixed');

	Template.SelectSquadAliensFn = SingleSectopodRandomAliensSelector;

	return Template;
}
static function array<name> SingleSectopodRandomAliensSelector(X2ChallengeSquadAlien Selector, int count)
{
	local X2ChallengeSquadAlien Template;
	local array<name> AlienTypes;

	Template = X2ChallengeSquadAlien(class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager().FindChallengeTemplate('ChallengeAlienSquad_RandomAliens'));
	AlienTypes = class'X2ChallengeSquadAlien'.static.WeightedTypeSelected(Template, (count - 1));
	AlienTypes.AddItem('SectopodMP');

	return AlienTypes;
}


//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateSingleGatekeeperSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_SingleGatekeeper');

	Template.Weight = 5;
	
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienAliens');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienMixed');

	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienXCom');

	Template.SelectSquadAliensFn = SingleGatekeeperSelector;

	return Template;
}
static function array<name> SingleGatekeeperSelector(X2ChallengeSquadAlien Selector, int count)
{
	return AllOneTypeSelector('GatekeeperMP', count);
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateSingleGatekeeperRandomAdventSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_SingleGatekeeperRandomAdvent');

	Template.Weight = 1;

	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienXCom');

	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienAliens');
	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienMixed');

	Template.SelectSquadAliensFn = SingleGatekeeperRandomAdventSelector;

	return Template;
}
static function array<name> SingleGatekeeperRandomAdventSelector(X2ChallengeSquadAlien Selector, int count)
{
	local X2ChallengeSquadAlien Template;
	local array<name> AlienTypes;

	Template = X2ChallengeSquadAlien(class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager().FindChallengeTemplate('ChallengeAlienSquad_RandomAdvent'));
	AlienTypes = class'X2ChallengeSquadAlien'.static.WeightedTypeSelected(Template, (count - 1));
	AlienTypes.AddItem('GatekeeperMP');

	return AlienTypes;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadAlien CreateSingleGatekeeperRandomAliensSelector()
{
	local X2ChallengeSquadAlien	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadAlien', Template, 'ChallengeAlienSquad_SingleGatekeeperRandomAliens');

	Template.Weight = 1;
	
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_AlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienSmall');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienNormal');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_XComAlienLarge');
	Template.ExcludeSelectorNames.AddItem('ChallengeSquadSize_BigAlienXCom');

	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienAliens');
	Template.PreferSelectorNames.AddItem('ChallengeSquadSize_BigAlienMixed');

	Template.SelectSquadAliensFn = SingleGatekeeperRandomAliensSelector;

	return Template;
}
static function array<name> SingleGatekeeperRandomAliensSelector(X2ChallengeSquadAlien Selector, int count)
{
	local X2ChallengeSquadAlien Template;
	local array<name> AlienTypes;

	Template = X2ChallengeSquadAlien(class'X2ChallengeTemplateManager'.static.GetChallengeTemplateManager().FindChallengeTemplate('ChallengeAlienSquad_RandomAliens'));
	AlienTypes = class'X2ChallengeSquadAlien'.static.WeightedTypeSelected(Template, (count - 1));
	AlienTypes.AddItem('GatekeeperMP');

	return AlienTypes;
}

//---------------------------------------------------------------------------------------
// HELPERS
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
private static function array<name> AllOneTypeSelector(name AlienType, int count)
{
	local array<name> AlienTypes;

	for(count = count; count > 0; --count)
	{
		AlienTypes.AddItem(AlienType);
	}

	return AlienTypes;
}


//---------------------------------------------------------------------------------------
defaultproperties
{
	bShouldCreateDifficultyVariants = false
}