//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DLC_Day60Resources.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_DLC_Day60Resources extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreateCorpseViperKing());
	Resources.AddItem(CreateCorpseBerserkerQueen());
	Resources.AddItem(CreateCorpseArchonKing());

	return Resources;
}

static function X2DataTemplate CreateCorpseViperKing()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseViperKing');

	Template.strImage = "img:///UILibrary_DLC2Images.LOOT_ViperKing";
	Template.ItemCat = 'resource';
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;
	Template.bAlwaysRecovered = true;

	Template.ItemRecoveredAsLootEventToTrigger = 'AlienRulerCorpseRecovered';

	return Template;
}

static function X2DataTemplate CreateCorpseBerserkerQueen()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseBerserkerQueen');

	Template.strImage = "img:///UILibrary_DLC2Images.LOOT_BerserkerQueen";
	Template.ItemCat = 'resource';
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;
	Template.bAlwaysRecovered = true;

	Template.ItemRecoveredAsLootEventToTrigger = 'AlienRulerCorpseRecovered';

	return Template;
}

static function X2DataTemplate CreateCorpseArchonKing()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseArchonKing');

	Template.strImage = "img:///UILibrary_DLC2Images.LOOT_ArchonKing";
	Template.ItemCat = 'resource';
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;
	Template.bAlwaysRecovered = true;

	Template.ItemRecoveredAsLootEventToTrigger = 'AlienRulerCorpseRecovered';

	return Template;
}