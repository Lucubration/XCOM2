//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeSecondaryWeaponSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeSecondaryWeaponSelectors extends X2ChallengeElement;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateConventionalWeapons());
	Templates.AddItem(CreateMagneticWeapons());
	Templates.AddItem(CreateBeamWeapons());
	Templates.AddItem(CreateRandomMix());

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSecondaryWeapon CreateConventionalWeapons()
{
	local X2ChallengeSecondaryWeapon	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSecondaryWeapon', Template, 'ChallengeSecondaryConventionalWeapons');

	Template.Weight = 7;

	Template.SecondaryWeapons.Length = 7;

	Template.SecondaryWeapons[0].SoldierClassName = 'Sharpshooter';
	Template.SecondaryWeapons[0].SecondaryWeapons.AddItem(CreateEntry('Pistol_CV', 1));

	Template.SecondaryWeapons[1].SoldierClassName = 'Grenadier';
	Template.SecondaryWeapons[1].SecondaryWeapons.AddItem(CreateEntry('GrenadeLauncher_CV', 1));

	Template.SecondaryWeapons[2].SoldierClassName = 'Specialist';
	Template.SecondaryWeapons[2].SecondaryWeapons.AddItem(CreateEntry('Gremlin_CV', 1));

	Template.SecondaryWeapons[3].SoldierClassName = 'Ranger';
	Template.SecondaryWeapons[3].SecondaryWeapons.AddItem(CreateEntry('Sword_CV', 1));

	Template.SecondaryWeapons[4].SoldierClassName = 'PsiOperative';
	Template.SecondaryWeapons[4].SecondaryWeapons.AddItem(CreateEntry('PsiAmp_CV', 1));

	Template.SecondaryWeapons[5].SoldierClassName = 'Templar';
	Template.SecondaryWeapons[5].SecondaryWeapons.AddItem(CreateEntry('Sidearm_CV', 1));

	Template.SecondaryWeapons[6].SoldierClassName = 'Skirmisher';
	Template.SecondaryWeapons[6].SecondaryWeapons.AddItem(CreateEntry('WristBlade_CV', 1));

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSecondaryWeapon CreateMagneticWeapons()
{
	local X2ChallengeSecondaryWeapon	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSecondaryWeapon', Template, 'ChallengeSecondaryMagneticWeapons');

	Template.Weight = 10;

	Template.SecondaryWeapons.Length = 7;

	Template.SecondaryWeapons[0].SoldierClassName = 'Sharpshooter';
	Template.SecondaryWeapons[0].SecondaryWeapons.AddItem(CreateEntry('Pistol_MG', 1));

	Template.SecondaryWeapons[1].SoldierClassName = 'Grenadier';
	Template.SecondaryWeapons[1].SecondaryWeapons.AddItem(CreateEntry('GrenadeLauncher_MG', 1));

	Template.SecondaryWeapons[2].SoldierClassName = 'Specialist';
	Template.SecondaryWeapons[2].SecondaryWeapons.AddItem(CreateEntry('Gremlin_MG', 1));

	Template.SecondaryWeapons[3].SoldierClassName = 'Ranger';
	Template.SecondaryWeapons[3].SecondaryWeapons.AddItem(CreateEntry('Sword_MG', 1));

	Template.SecondaryWeapons[4].SoldierClassName = 'PsiOperative';
	Template.SecondaryWeapons[4].SecondaryWeapons.AddItem( CreateEntry('PsiAmp_MG', 1));

	Template.SecondaryWeapons[5].SoldierClassName = 'Templar';
	Template.SecondaryWeapons[5].SecondaryWeapons.AddItem(CreateEntry('Sidearm_MG', 1));

	Template.SecondaryWeapons[6].SoldierClassName = 'Skirmisher';
	Template.SecondaryWeapons[6].SecondaryWeapons.AddItem(CreateEntry('WristBlade_MG', 1));
	
	return Template;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSecondaryWeapon CreateBeamWeapons()
{
	local X2ChallengeSecondaryWeapon	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSecondaryWeapon', Template, 'ChallengeSecondaryBeamWeapons');

	Template.Weight = 7;

	Template.SecondaryWeapons.Length = 7;

	Template.SecondaryWeapons[0].SoldierClassName = 'Sharpshooter';
	Template.SecondaryWeapons[0].SecondaryWeapons.AddItem(CreateEntry('Pistol_BM', 1));

	Template.SecondaryWeapons[1].SoldierClassName = 'Grenadier';
	Template.SecondaryWeapons[1].SecondaryWeapons.AddItem(CreateEntry('GrenadeLauncher_MG', 1));

	Template.SecondaryWeapons[2].SoldierClassName = 'Specialist';
	Template.SecondaryWeapons[2].SecondaryWeapons.AddItem(CreateEntry('Gremlin_BM', 1));

	Template.SecondaryWeapons[3].SoldierClassName = 'Ranger';
	Template.SecondaryWeapons[3].SecondaryWeapons.AddItem(CreateEntry('Sword_BM', 1));

	Template.SecondaryWeapons[4].SoldierClassName = 'PsiOperative';
	Template.SecondaryWeapons[4].SecondaryWeapons.AddItem(CreateEntry('PsiAmp_BM', 1));

	Template.SecondaryWeapons[5].SoldierClassName = 'Templar';
	Template.SecondaryWeapons[5].SecondaryWeapons.AddItem(CreateEntry('Sidearm_BM', 1));

	Template.SecondaryWeapons[6].SoldierClassName = 'Skirmisher';
	Template.SecondaryWeapons[6].SecondaryWeapons.AddItem(CreateEntry('WristBlade_BM', 1));

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeSecondaryWeapon CreateRandomMix()
{
	local X2ChallengeSecondaryWeapon	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSecondaryWeapon', Template, 'ChallengeSecondaryRandom');

	Template.Weight = 5;

	Template.SecondaryWeapons.Length = 7;

	Template.SecondaryWeapons[0].SoldierClassName = 'Sharpshooter';
	Template.SecondaryWeapons[0].SecondaryWeapons.AddItem(CreateEntry('Pistol_CV', 1));
	Template.SecondaryWeapons[0].SecondaryWeapons.AddItem(CreateEntry('Pistol_MG', 1));
	Template.SecondaryWeapons[0].SecondaryWeapons.AddItem(CreateEntry('Pistol_BM', 1));

	Template.SecondaryWeapons[1].SoldierClassName = 'Grenadier';
	Template.SecondaryWeapons[1].SecondaryWeapons.AddItem(CreateEntry('GrenadeLauncher_CV', 1));
	Template.SecondaryWeapons[1].SecondaryWeapons.AddItem(CreateEntry('GrenadeLauncher_MG', 1));

	Template.SecondaryWeapons[2].SoldierClassName = 'Specialist';
	Template.SecondaryWeapons[2].SecondaryWeapons.AddItem(CreateEntry('Gremlin_CV', 1));
	Template.SecondaryWeapons[2].SecondaryWeapons.AddItem(CreateEntry('Gremlin_MG', 1));
	Template.SecondaryWeapons[2].SecondaryWeapons.AddItem(CreateEntry('Gremlin_BM', 1));

	Template.SecondaryWeapons[3].SoldierClassName = 'Ranger';
	Template.SecondaryWeapons[3].SecondaryWeapons.AddItem(CreateEntry('Sword_CV', 1));
	Template.SecondaryWeapons[3].SecondaryWeapons.AddItem(CreateEntry('Sword_MG', 1));
	Template.SecondaryWeapons[3].SecondaryWeapons.AddItem(CreateEntry('Sword_BM', 1));

	Template.SecondaryWeapons[4].SoldierClassName = 'PsiOperative';
	Template.SecondaryWeapons[4].SecondaryWeapons.AddItem(CreateEntry('PsiAmp_CV', 1));
	Template.SecondaryWeapons[4].SecondaryWeapons.AddItem(CreateEntry('PsiAmp_MG', 1));
	Template.SecondaryWeapons[4].SecondaryWeapons.AddItem(CreateEntry('PsiAmp_BM', 1));

	Template.SecondaryWeapons[5].SoldierClassName = 'Templar';
	Template.SecondaryWeapons[5].SecondaryWeapons.AddItem(CreateEntry('Sidearm_CV', 1));
	Template.SecondaryWeapons[5].SecondaryWeapons.AddItem(CreateEntry('Sidearm_MG', 1));
	Template.SecondaryWeapons[5].SecondaryWeapons.AddItem(CreateEntry('Sidearm_BM', 1));

	Template.SecondaryWeapons[6].SoldierClassName = 'Skirmisher';
	Template.SecondaryWeapons[6].SecondaryWeapons.AddItem(CreateEntry('WristBlade_CV', 1));
	Template.SecondaryWeapons[6].SecondaryWeapons.AddItem(CreateEntry('WristBlade_MG', 1));
	Template.SecondaryWeapons[6].SecondaryWeapons.AddItem(CreateEntry('WristBlade_BM', 1));

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = false
}