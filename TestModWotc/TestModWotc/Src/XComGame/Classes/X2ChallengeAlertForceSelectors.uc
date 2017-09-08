//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeAlertForceSelectors.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeAlertForceSelectors extends X2ChallengeElement;

var array<int> SquadAlertMapping;
var array<float> SquadForceMapping;
var array<float> RankScalars;
var array<float> PrimaryWeaponPower;
var array<float> SecondaryWeaponPower;
var array<float> ArmorPower;
var float HeavyWeaponPower;
var float DefaultItemPower;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates( )
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( CreateCalculatedLevels() );

	return Templates;
}

//---------------------------------------------------------------------------------------
static function X2ChallengeAlertForce CreateCalculatedLevels()
{
	local X2ChallengeAlertForce	Template;

	`CREATE_X2TEMPLATE(class'X2ChallengeAlertForce', Template, 'ChallengeCalculatedLevels');

	Template.SelectAlertForceFn = CalculatedLevelsSelection;

	return Template;
}

//---------------------------------------------------------------------------------------
static function CalculatedLevelsSelection(X2ChallengeAlertForce Selector, XComGameState StartState, XComGameState_HeadquartersXCom HeadquartersStateObject, out int AlertLevel, out int ForceLevel)
{
	AlertLevel = DetermineAlertLevel(HeadquartersStateObject);
	ForceLevel = DetermineForceLevel(StartState, HeadquartersStateObject);
}

//---------------------------------------------------------------------------------------
private static function int DetermineAlertLevel(XComGameState_HeadquartersXCom HeadquartersStateObject)
{
	local StateObjectReference SquadRef;
	local int UnitCount;

	UnitCount = 0;

	foreach HeadquartersStateObject.Squad(SquadRef)
	{
		if(SquadRef.ObjectID > 0)
		{
			UnitCount++;
		}
	}

	if(UnitCount < 0)
	{
		return default.SquadAlertMapping[0];
	}
	else if(UnitCount >= default.SquadAlertMapping.Length)
	{
		return default.SquadAlertMapping[default.SquadAlertMapping.Length - 1];
	}

	return default.SquadAlertMapping[UnitCount];
}

//---------------------------------------------------------------------------------------
private static function int DetermineForceLevel(XComGameState StartState, XComGameState_HeadquartersXCom HeadquartersStateObject)
{
	local float SquadPowerLevel;
	local int idx;

	SquadPowerLevel = GetSquadPowerLevel(StartState, HeadquartersStateObject);

	for(idx = (default.SquadForceMapping.Length - 1); idx >= 0; idx--)
	{
		if(SquadPowerLevel >= default.SquadForceMapping[idx])
		{
			return idx;
		}
	}

	return 3;
}

//---------------------------------------------------------------------------------------
private static function float GetSquadPowerLevel(XComGameState StartState, XComGameState_HeadquartersXCom HeadquartersStateObject)
{
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;
	local float SquadPowerLevel;

	SquadPowerLevel = 0.0f;

	foreach HeadquartersStateObject.Squad(UnitRef)
	{
		UnitState = XComGameState_Unit(StartState.GetGameStateForObjectID(UnitRef.ObjectID));

		if(UnitState != none)
		{
			SquadPowerLevel += GetUnitPowerLevel(StartState, UnitState);
		}
	}

	return SquadPowerLevel;
}

//---------------------------------------------------------------------------------------
private static function float GetUnitPowerLevel(XComGameState StartState, XComGameState_Unit UnitState)
{
	if(UnitState.IsSoldier())
	{
		return (default.RankScalars[UnitState.GetRank()] * GetGearPowerLevel(StartState, UnitState));
	}
	else
	{
		return UnitState.GetMyTemplate().ChallengePowerLevel;
	}
}

//---------------------------------------------------------------------------------------
private static function float GetGearPowerLevel(XComGameState StartState, XComGameState_Unit UnitState)
{
	local XComGameState_Item ItemState;
	local StateObjectReference ItemRef;
	local float GearPowerLevel;

	GearPowerLevel = 0.0f;

	foreach UnitState.InventoryItems(ItemRef)
	{
		ItemState = XComGameState_Item(StartState.GetGameStateForObjectID(ItemRef.ObjectID));

		if(ItemState != none)
		{
			GearPowerLevel += GetItemPowerLevel(ItemState);
		}
	}

	return GearPowerLevel;
}

//---------------------------------------------------------------------------------------
private static function float GetItemPowerLevel(XComGameState_Item ItemState)
{
	local X2WeaponTemplate WeaponTemplate;
	local X2ArmorTemplate ArmorTemplate;

	if(ItemState.GetMyTemplateName() == 'XPad')
	{
		return 0.0f;
	}

	WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());

	if(WeaponTemplate != none)
	{
		switch(WeaponTemplate.InventorySlot)
		{
		case eInvSlot_PrimaryWeapon:
			switch(WeaponTemplate.WeaponTech)
			{
			case 'conventional':
				return default.PrimaryWeaponPower[0];
			case 'magnetic':
				return default.PrimaryWeaponPower[1];
			case 'beam':
				return default.PrimaryWeaponPower[2];
			}
		case eInvSlot_SecondaryWeapon:
			switch(WeaponTemplate.WeaponTech)
			{
			case 'conventional':
				return default.SecondaryWeaponPower[0];
			case 'magnetic':
				return default.SecondaryWeaponPower[1];
			case 'beam':
				return default.SecondaryWeaponPower[2];
			}
		case eInvSlot_HeavyWeapon:
			return default.HeavyWeaponPower;
		}
	}

	ArmorTemplate = X2ArmorTemplate(ItemState.GetMyTemplate());

	if(ArmorTemplate != none)
	{
		switch(ArmorTemplate.ArmorTechCat)
		{
		case 'conventional':
			return default.ArmorPower[0];
		case 'plated':
			return default.ArmorPower[1];
		case 'powered':
			return default.ArmorPower[2];
		}
	}

	return default.DefaultItemPower;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = false

	SquadAlertMapping[0] = 1
	SquadAlertMapping[1] = 1
	SquadAlertMapping[2] = 1
	SquadAlertMapping[3] = 2
	SquadAlertMapping[4] = 3
	SquadAlertMapping[5] = 4
	SquadAlertMapping[6] = 4
	SquadAlertMapping[7] = 5
	SquadAlertMapping[8] = 6
	SquadAlertMapping[9] = 6

	SquadForceMapping[0] = 0
	SquadForceMapping[1] = 0
	SquadForceMapping[2] = 0
	SquadForceMapping[3] = 0.0f
	SquadForceMapping[4] = 55.0f
	SquadForceMapping[5] = 70.0f
	SquadForceMapping[6] = 85.0f
	SquadForceMapping[7] = 100.0f
	SquadForceMapping[8] = 115.0f
	SquadForceMapping[9] = 130.0f
	SquadForceMapping[10] = 145.0f
	SquadForceMapping[11] = 160.0f
	SquadForceMapping[12] = 175.0f
	SquadForceMapping[13] = 190.0f
	SquadForceMapping[14] = 205.0f
	SquadForceMapping[15] = 220.0f
	SquadForceMapping[16] = 235.0f
	SquadForceMapping[17] = 250.0f
	SquadForceMapping[18] = 265.0f
	SquadForceMapping[19] = 280.0f
	SquadForceMapping[20] = 295.0f

	RankScalars[0] = 1.4f
	RankScalars[1] = 1.6f
	RankScalars[2] = 1.8f
	RankScalars[3] = 2.0f
	RankScalars[4] = 2.2f
	RankScalars[5] = 2.4f
	RankScalars[6] = 2.6f
	RankScalars[7] = 2.8f

	PrimaryWeaponPower[0] = 2.0f
	PrimaryWeaponPower[1] = 5.0f
	PrimaryWeaponPower[2] = 7.0f

	SecondaryWeaponPower[0] = 2.0f
	SecondaryWeaponPower[1] = 4.0f
	SecondaryWeaponPower[2] = 6.0f

	ArmorPower[0] = 2.0f
	ArmorPower[1] = 6.0f
	ArmorPower[2] = 9.0f

	HeavyWeaponPower = 4.0f
	DefaultItemPower = 2.0f
}