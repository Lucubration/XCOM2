///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetGatherSuppliesCrateInfo.uc
//  AUTHOR:  David Burchanowski  --  11/03/2016
//  PURPOSE: Chooses and returns a list of 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_GetGatherSuppliesCrateInfo extends SequenceAction
	config(GameData);

var protected string ChestType;
var protected string ChestArchetype;
var protected string ChestLootTable;

event Activated()
{
	local ChestDefinition ChestDef;

	if(class'SeqAct_GetGatherSuppliesChests'.static.GetChestDefinition(name(ChestType), ChestDef))
	{
		ChestArchetype = ChestDef.ArchetypePath;
		ChestLootTable = string(ChestDef.LootTable);
	}
	else
	{
		`Redscreen("SeqAct_GetGatherSuppliesCrateInfo: No chest type found for " $ ChestType);
		ChestArchetype = "";
		ChestLootTable = "";
	}
}

defaultproperties
{
	ObjCategory="Procedural Missions"
	ObjName="Get Gather Supplies Chest Info"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Chest Type",PropertyName=ChestType)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Archetype",PropertyName=ChestArchetype,bWriteable=true)
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Loot Table",PropertyName=ChestLootTable,bWriteable=true)
}


