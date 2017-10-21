///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_NotifyRecoveredSupplyChests.uc
//  AUTHOR:  David Burchanowski  --  11/03/2016
//  PURPOSE: Chooses and returns a list of 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_NotifyRecoveredSupplyChests extends SequenceAction
	config(GameData);

// List of chest types the user recovered. Each chest will be rolled for loot and that loot added to the mission rewards
var protected array<string> RecoveredChestTypes;

event Activated()
{
	local SeqVar_StringList List;
		
	foreach LinkedVariables(class'SeqVar_StringList', List, "In Chest Types")
	{
		RecoverChests(List.arrStrings);
	}
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 1;
}

// This lives here instead of in Activated() so that it can be tested from the command line without kismet
static function RecoverChests(const out array<string> InRecoveredChestTypes)
{
	local XComGameStateHistory History; 
	local XComGameState_BattleData BattleData;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState NewGameState;
	local XComGameState_Item LootItemState;
	local X2LootTableManager LootTableManager;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local ChestDefinition RecoveredChestDef;
	local string RecoveredChestType;
	local array<name> RolledLootTemplates;
	local name LootTemplate;

	if(InRecoveredChestTypes.Length == 0)
	{
		// no chests were recovered, so there is nothing to add to the battle data state
		return;
	}

	History = `XCOMHISTORY;
	LootTableManager = class'X2LootTableManager'.static.GetLootTableManager();
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("NotifyRecoveredSupplyChests");
	
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	
	// loop through each created chest and add it's loot to the battle data state
	foreach InRecoveredChestTypes(RecoveredChestType)
	{
		// get the chest definition
		if(class'SeqAct_GetGatherSuppliesChests'.static.GetChestDefinition(name(RecoveredChestType), RecoveredChestDef))
		{
			// Roll for loot in this chest, and add it
			RolledLootTemplates.Length = 0;
			LootTableManager.RollForLootTable(RecoveredChestDef.LootTable, RolledLootTemplates);

			foreach RolledLootTemplates(LootTemplate)
			{
				ItemTemplate = ItemTemplateManager.FindItemTemplate(LootTemplate);
				if (ItemTemplate != none)
				{
					// Create the item state for the recovered loot
					LootItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
					LootItemState.OwnerStateObject = XComHQ.GetReference();

					// Add it to the inventory as loot, so it will be processed when the mission ends
					XComHQ.PutItemInInventory(NewGameState, LootItemState, true);

					// Add it to the carry out bucket so it displays on the Loot Recovered screen
					BattleData.CarriedOutLootBucket.AddItem(LootTemplate);
				}
			}
		}
	}

	NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);
	
	`TACTICALRULES.SubmitGameState(NewGameState);
}

defaultproperties
{
	ObjCategory="Procedural Missions"
	ObjName="Notify Recovered Supply Chests"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_StringList',LinkDesc="In Chest Types",PropertyName=RecoveredChestTypes)
}
