//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_AddLootToStateObject.uc
//  AUTHOR:  Russell Aasland  --  1/20/2017
//  PURPOSE: Gamestate and Visualizer changes to take loot from another gamestate object
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_AddLootToStateObject extends SequenceAction
	implements(X2KismetSeqOpVisualizer);

var() protected string ItemTemplate;
var() protected string LootTable;

function ModifyKismetGameState(out XComGameState GameState)
{
	local XComGameStateHistory History;
	local X2ItemTemplateManager ItemManager;
	local X2LootTableManager LootManager;
	local X2ItemTemplate ForcedItem, RolledItem;
	local name LootTableName;
	local SeqVar_GameStateList List;
	local StateObjectReference StateRef;
	local Lootable LootableState;
	local XComGameState_BaseObject StateObject;
	local XComGameState_Item ItemState;
	local array<XComGameState_Item> LootStates;
	local array<name> RolledLoot;
	local name RolledTemplate;

	History = `XCOMHISTORY;
	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	LootManager = class'X2LootTableManager'.static.GetLootTableManager();

	if (ItemTemplate != "")
	{
		ForcedItem = ItemManager.FindItemTemplate( name(ItemTemplate) );
		if (ForcedItem == none)
		{
			`Redscreen("SeqAct_AddLootToStateObject was unable to find specified item template" @ItemTemplate);
		}
	}

	LootTableName = name(LootTable);

	foreach LinkedVariables(class'SeqVar_GameStateList', List, "Game State List")
	{
		foreach List.GameStates( StateRef )
		{
			LootableState = Lootable( History.GetGameStateForObjectID( StateRef.ObjectID ) );
			if (LootableState == none)
			{
				StateObject = History.GetGameStateForObjectID( StateRef.ObjectID );
				`Redscreen("SeqAct_AddLootToStateObject was provided with an object state of type" @StateObject.Name@ "which is not lootable");

				continue;
			}

			if (ForcedItem != none)
			{
				ItemState = ForcedItem.CreateInstanceFromTemplate( GameState );
				LootableState.AddLoot( ItemState.GetReference(), GameState );
			}

			if (LootTableName != '')
			{
				RolledLoot.Length = 0;
				LootStates.Length = 0;

				LootManager.RollForLootTable( LootTableName, RolledLoot );
				foreach RolledLoot( RolledTemplate )
				{
					RolledItem = ItemManager.FindItemTemplate( RolledTemplate );
					if (RolledItem != none)
					{
						ItemState = FindState( LootStates, RolledTemplate );
						if (ItemState == none)
						{
							ItemState = RolledItem.CreateInstanceFromTemplate( GameState );
							LootableState.AddLoot( ItemState.GetReference(), GameState );
							LootStates.AddItem( ItemState );
						}
						else
						{
							++ItemState.Quantity;
						}
					}
					else
					{
						`Redscreen("SeqAct_AddLootToStateObject was unable to find rolled item template" @RolledTemplate@ "created from loot table" @LootTableName );
					}
				}
			}
		}
	}
}

static function XComGameState_Item FindState( const out array<XComGameState_Item> States, name TemplateName )
{
	local XComGameState_Item ItemState;

	foreach States(ItemState)
	{
		if (ItemState.GetMyTemplateName() == TemplateName)
			return ItemState;
	}

	return none;
}

function BuildVisualization(XComGameState GameState)
{
}

defaultproperties
{
	ObjCategory="Loot"
	ObjName="Add Loot"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List",MinVars=1,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String', LinkDesc="Item Template", PropertyName=ItemTemplate)
	VariableLinks(2)=(ExpectedType=class'SeqVar_String', LinkDesc="Loot Table", PropertyName=LootTable)
}