///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_AddLootToEndMissionRewards.uc
//  AUTHOR:  James Brawley - 1/25/2017
//  PURPOSE: Takes a loot table name, rolls the loot, and adds it to the mission's autoloot table
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_AddLootToEndMissionRewards extends SequenceAction
	config(GameData);

// Add loot from this table name
var() string LootTableToAdd;

event Activated()
{
	local XComGameStateHistory History; 
	local XComGameState_BattleData BattleData;
	local XComGameState NewGameState;
	local X2LootTableManager LootTableManager;
	local array<name> RolledLootTemplates;
	local name LootTemplate;
	local name LootTableToRoll;
	local X2ItemTemplate ItemTemplate;
	local X2ItemTemplateManager ItemTemplateManager;
	local SeqVar_StringList ListOfItems;

	if(LootTableToAdd == "")
	{
		// No loot table name was specified
		`Redscreen("SeqAct_AddLootToEndMissionRewards: This node was called with field LootTableToAdd blank.");
		return;
	}

	// Get reference to item template manager
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	// Get reference to history and loot table manager
	History = `XCOMHISTORY;
	LootTableManager = class'X2LootTableManager'.static.GetLootTableManager();

	// Get reference to the battledata
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Loot to Mission Autoloot");
	BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	
	// Flush the loot list
	RolledLootTemplates.Length = 0;

	// Generate the loot table
	LootTableToRoll = name(LootTableToAdd);
	LootTableManager.RollForLootTable(LootTableToRoll, RolledLootTemplates);

	// Add all generated loot items to the Autoloot bucket
	foreach RolledLootTemplates(LootTemplate)
	{
		BattleData.AutoLootBucket.AddItem(LootTemplate);
		`Log("SeqAct_AddLootToEndMissionRewards: Added loot template "@ LootTemplate @" to mission autoloot");

		ItemTemplate = ItemTemplateManager.FindItemTemplate(LootTemplate);

		foreach LinkedVariables(class'SeqVar_StringList', ListOfItems, "ItemsGranted")
		{
			ListOfItems.arrStrings.AddItem(ItemTemplate.GetItemFriendlyName());
		}
	}

	NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

	`TACTICALRULES.SubmitGameState(NewGameState);
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjCategory="Loot"
	ObjName="Add Loot to End Mission Rewards"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="LootTableToAdd",PropertyName=LootTableToAdd)
	VariableLinks(1)=(ExpectedType=class'SeqVar_StringList',LinkDesc="ItemsGranted")
}


