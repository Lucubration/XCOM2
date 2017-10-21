//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XComCharacterCustomization_Spark.uc
//  AUTHOR:  Joe Weinhoffer 2/19/2016
//  PURPOSE: Container of static helper functions for customizing character screens 
//			 and visual updates for SPARK soldiers. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class XComCharacterCustomization_Spark extends XComCharacterCustomization;

//==============================================================================

// direction will either be -1 (left arrow), or 1 (right arrow)xcom
simulated function OnCategoryValueChange(int categoryIndex, int direction, optional int specificIndex = -1)
{
	//Set the body part filter with latest data so that the filters can operate	
	BodyPartFilter.Set(EGender(UpdatedUnitState.kAppearance.iGender), ECharacterRace(UpdatedUnitState.kAppearance.iRace), UpdatedUnitState.kAppearance.nmTorso, !UpdatedUnitState.IsSoldier(), UpdatedUnitState.IsVeteran() || InShell());
	switch (categoryIndex)
	{
	case eUICustomizeCat_Face:
		UpdateCategorySimple("Head", direction, BodyPartFilter.FilterByGenderAndRaceAndCharacterAndTech, UpdatedUnitState.kAppearance.nmHead, specificIndex);
		break;
	default:
		super.OnCategoryValueChange(categoryIndex, direction, specificIndex);
		break;
	}
}

simulated function string GetCategoryDisplay(int catType)
{
	local string Result;

	switch (catType)
	{
	case eUICustomizeCat_Face:
		Result = GetCategoryDisplayName("Head", UpdatedUnitState.kAppearance.nmHead, BodyPartFilter.FilterByGenderAndRaceAndCharacterAndTech);
		break;
	default:
		Result = super.GetCategoryDisplay(catType);
		break;
	}

	return Result;
}

//==============================================================================

reliable client function array<string> GetCategoryList(int categoryIndex)
{
	local array<string> Items;
	
	switch (categoryIndex)
	{
	case eUICustomizeCat_Face:
		GetGenericCategoryList(Items, "Head", BodyPartFilter.FilterByGenderAndRaceAndCharacterAndTech, class'UICustomize_SparkMenu'.default.m_strHead);
		return Items;
	default:
		return super.GetCategoryList(categoryIndex);
	}
}

simulated function int GetCategoryIndex(int catType)
{
	local int Result;

	Result = -1;

	switch (catType)
	{
	case eUICustomizeCat_Face:
		Result = GetCategoryValue("Head", UpdatedUnitState.kAppearance.nmHead, BodyPartFilter.FilterByGenderAndRaceAndCharacterAndTech);
		break;
	default:
		Result = super.GetCategoryIndex(catType);
		break;
	}

	return Result;
}

//==============================================================================

function CommitChanges()
{
	local XComGameState NewGameState;
	local name SparkVoice;
	
	super.CommitChanges();

	// Trigger events for selecting specific voice packs so appropriate VO plays
	if (Unit != none)
	{
		SparkVoice = Unit.kAppearance.nmVoice;

		if (SparkVoice == 'SparkWarriorVoice1_English' ||
			SparkVoice == 'SparkWarriorVoice1_German' ||
			SparkVoice == 'SparkWarriorVoice1_Spanish' ||
			SparkVoice == 'SparkWarriorVoice1_French' ||
			SparkVoice == 'SparkWarriorVoice1_Italian')
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Warrior Spark Voice Event");
			`XEVENTMGR.TriggerEvent('WarriorSparkVoiceSelected', , , NewGameState);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
		else if (SparkVoice == 'SparkJulianVoice1_English' ||
			SparkVoice == 'SparkJulianVoice1_German' ||
			SparkVoice == 'SparkJulianVoice1_Spanish' ||
			SparkVoice == 'SparkJulianVoice1_French' ||
			SparkVoice == 'SparkJulianVoice1_Italian')
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Julian Spark Voice Event");
			`XEVENTMGR.TriggerEvent('JulianSparkVoiceSelected', , , NewGameState);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}
}