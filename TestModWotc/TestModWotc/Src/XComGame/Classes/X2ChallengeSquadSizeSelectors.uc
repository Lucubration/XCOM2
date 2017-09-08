//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeSquadSizeSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeSquadSizeSelectors extends X2ChallengeElement;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates( )
{
	local array<X2DataTemplate> Templates;

	// XCOM only squads
	Templates.AddItem(CreateXComSmallSquadSize());
	Templates.AddItem(CreateXComNormalSquadSize());
	Templates.AddItem(CreateXComLargeSquadSize());

	// ALIEN only squads
	Templates.AddItem(CreateAlienSmallSquadSize());
	Templates.AddItem(CreateAlienNormalSquadSize());
	Templates.AddItem(CreateAlienLargeSquadSize());

	// MIXED squads
	Templates.AddItem(CreateXComAlienSmallSquadSize());
	Templates.AddItem(CreateXComAlienNormalSquadSize());
	Templates.AddItem(CreateXComAlienLargeSquadSize());

	// One Big Alien squads
	Templates.AddItem(CreateBigAlienXComSquadSize());
	Templates.AddItem(CreateBigAlienAliensSquadSize());
	Templates.AddItem(CreateBigAlienMixedSquadSize());

	return Templates;
}

//---------------------------------------------------------------------------------------
// XCOM only squads
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateXComSmallSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_XComSmall');
	
	Template.Weight = 10;

	Template.MinXCom = 3;
	Template.MaxXCom = 3;
	Template.MinAliens = 0;
	Template.MaxAliens = 0;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateXComNormalSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_XComNormal');

	Template.Weight = 7;

	Template.MinXCom = 4;
	Template.MaxXCom = 6;
	Template.MinAliens = 0;
	Template.MaxAliens = 0;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateXComLargeSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_XComLarge');

	Template.Weight = 3;

	Template.MinXCom = 7;
	Template.MaxXCom = 9;
	Template.MinAliens = 0;
	Template.MaxAliens = 0;

	return Template;
}

//---------------------------------------------------------------------------------------
// ALIEN only squads
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateAlienSmallSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_AlienSmall');

	Template.Weight = 10;

	Template.MinXCom = 0;
	Template.MaxXCom = 0;
	Template.MinAliens = 3;
	Template.MaxAliens = 3;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateAlienNormalSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_AlienNormal');

	Template.Weight = 7;

	Template.MinXCom = 0;
	Template.MaxXCom = 0;
	Template.MinAliens = 4;
	Template.MaxAliens = 6;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateAlienLargeSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_AlienLarge');

	Template.Weight = 3;

	Template.MinXCom = 0;
	Template.MaxXCom = 0;
	Template.MinAliens = 7;
	Template.MaxAliens = 9;

	return Template;
}

//---------------------------------------------------------------------------------------
// MIXED squads
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateXComAlienSmallSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_XComAlienSmall');

	Template.Weight = 10;

	Template.MinXCom = 2;
	Template.MaxXCom = 2;
	Template.MinAliens = 1;
	Template.MaxAliens = 1;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateXComAlienNormalSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_XComAlienNormal');

	Template.Weight = 7;

	Template.MinXCom = 2;
	Template.MaxXCom = 3;
	Template.MinAliens = 2;
	Template.MaxAliens = 3;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateXComAlienLargeSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_XComAlienLarge');

	Template.Weight = 3;

	Template.MinXCom = 4;
	Template.MaxXCom = 5;
	Template.MinAliens = 4;
	Template.MaxAliens = 4;

	return Template;
}

//---------------------------------------------------------------------------------------
// ONE BIG ALIEN squads
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateBigAlienXComSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_BigAlienXCom');

	Template.Weight = 1;

	Template.MinXCom = 2;
	Template.MaxXCom = 4;
	Template.MinAliens = 1;
	Template.MaxAliens = 1;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateBigAlienAliensSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_BigAlienAliens');

	Template.Weight = 1;

	Template.MinXCom = 0;
	Template.MaxXCom = 0;
	Template.MinAliens = 3;
	Template.MaxAliens = 5;

	return Template;
}
//---------------------------------------------------------------------------------------
static function X2ChallengeSquadSize CreateBigAlienMixedSquadSize()
{
	local X2ChallengeSquadSize	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeSquadSize', Template, 'ChallengeSquadSize_BigAlienMixed');

	Template.Weight = 1;

	Template.MinXCom = 1;
	Template.MaxXCom = 2;
	Template.MinAliens = 2;
	Template.MaxAliens = 3;

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = false
}