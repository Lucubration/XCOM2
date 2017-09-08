///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetNextGatherSuppliesChest.uc
//  AUTHOR:  David Burchanowski  --  11/05/2014
//  PURPOSE: Chooses and returns a list of 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_GetGatherSuppliesChests extends SequenceAction
	config(GameData);

// Defines a "rare chest". Rare chests are rolled on before pulling
// the rest of the chests from the shuffle bag in the ChestDistribution
struct RareChestEntry
{
	var name Type;
	var float Chance;
};

// Defines a complete "Chest Distribution".
struct ChestDistribution
{
	var int MinForceLevel;
	var int MaxForceLevel;

	var array<string> ChestTypeShuffleBag;
	var array<RareChestEntry> RareChests;
};

// Associates a type of chest with it's loot table and archetype
struct ChestDefinition
{
	var name Type;
	var string ArchetypePath;
	var name LootTable;
};

// ini defined data
var const config array<ChestDistribution> ChestDistributions;
var const config array<ChestDefinition> ChestDefinitions;

// Number of chests the user wants to generate
var protected int ChestCount;

event Activated()
{
	local XComGameStateHistory History; 
	local XComGameState_BattleData BattleData;
	local SeqVar_StringList List;
	local int ForceLevel;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	ForceLevel = BattleData.GetForceLevel();

	foreach LinkedVariables(class'SeqVar_StringList', List, "Out Chest Types")
	{
		List.arrStrings.Length = 0;
		SelectChests(ForceLevel, ChestCount, List.arrStrings);
	}
}

// Most of the logic lives here so that it can be tested from the cheat console without any kismet needed
static function SelectChests(int ForceLevel, int InChestCount, out array<string> OutChestTypes)
{
	local RareChestEntry RareChestChance;
	local array<string> ShuffledChests;
	local int Index;

	// find the correct bucket for our supplies
	for (Index = 0; Index < default.ChestDistributions.Length; Index++)
	{
		if (ForceLevel >= default.ChestDistributions[Index].MinForceLevel && ForceLevel <= default.ChestDistributions[Index].MaxForceLevel)
		{
			break;
		}
	}

	// validate that we found a distribution
	if (Index > default.ChestDistributions.Length)
	{
		// no distribution matches this force level!
		`Redscreen("No valid Chest Distribution found for Force Level " $ ForceLevel);
		
		if(default.ChestDistributions.Length == 0)
		{
			return; // no distributions at all, so we need to bail
		}

		Index = 0; // use the first definition as a fallback
	}

	// validate that our distribution has chests in it
	if (default.ChestDistributions[Index].ChestTypeShuffleBag.Length == 0)
	{
		`Redscreen("ChestDistributions[" $ Index $ "] contains no chests!");
		return;
	}

	// first roll on "rare crates". These come up very infrequently, and are meant to be
	// exciting for the player when they do. We select them first, and then fill out the rest of the
	// list from the normal crate shuffle bag
	foreach default.ChestDistributions[Index].RareChests(RareChestChance)
	{
		if(OutChestTypes.Length < InChestCount && class'Engine'.static.SyncFRand("SeqAct_GetGatherSuppliesChests") < RareChestChance.Chance)
		{
			OutChestTypes.AddItem(string(RareChestChance.Type));
		}
	}

	// select crates from the shuffle bag until we have enough of them
	ShuffledChests = default.ChestDistributions[Index].ChestTypeShuffleBag;
	while (OutChestTypes.Length < InChestCount)
	{
		ShuffledChests.RandomizeOrder();

		for (Index = 0; Index < ShuffledChests.Length && OutChestTypes.Length < InChestCount; Index++)
		{
			OutChestTypes.AddItem(ShuffledChests[Index]);
		}
	}

	// and do one final shuffle so that the rare chests are also randomly located
	OutChestTypes.RandomizeOrder();
}

static function bool GetChestDefinition(name ChestType, out ChestDefinition ChestDef)
{
	local int Index;

	for (Index = 0; Index < default.ChestDefinitions.Length; Index++)
	{
		if(default.ChestDefinitions[Index].Type == ChestType)
		{
			ChestDef = default.ChestDefinitions[Index];
			return true;
		}
	}

	return false;
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Procedural Missions"
	ObjName="Get Gather Supplies Chests"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Count",PropertyName=ChestCount)
	VariableLinks(1)=(ExpectedType=class'SeqVar_StringList',LinkDesc="Out Chest Types",bWriteable=true)
}
