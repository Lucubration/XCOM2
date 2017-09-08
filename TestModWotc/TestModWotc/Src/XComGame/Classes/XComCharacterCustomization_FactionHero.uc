//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XComCharacterCustomization_FactionHero.uc
//  AUTHOR:  Joe Weinhoffer 3/11/2017
//  PURPOSE: Container of static helper functions for customizing character screens 
//			 and visual updates for Faction Hero soldiers. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class XComCharacterCustomization_FactionHero extends XComCharacterCustomization;

//==============================================================================

// direction will either be -1 (left arrow), or 1 (right arrow)xcom
simulated function OnCategoryValueChange(int categoryIndex, int direction, optional int specificIndex = -1)
{
	//Set the body part filter with latest data so that the filters can operate	
	BodyPartFilter.Set(EGender(UpdatedUnitState.kAppearance.iGender), ECharacterRace(UpdatedUnitState.kAppearance.iRace), UpdatedUnitState.kAppearance.nmTorso, !UpdatedUnitState.IsSoldier(), UpdatedUnitState.IsVeteran() || InShell());
	switch (categoryIndex)
	{
	case eUICustomizeCat_Voice:
		UpdateCategorySimple("Voice", direction, BodyPartFilter.FilterByGenderAndCharacterExclusive, UpdatedUnitState.kAppearance.nmVoice, specificIndex);
		XComHumanPawn(ActorPawn).SetVoice(UpdatedUnitState.kAppearance.nmVoice);
		UpdatedUnitState.StoreAppearance();
		break;
	default:
		super.OnCategoryValueChange(categoryIndex, direction, specificIndex);
		break;
	}

	// Only update the camera when editing a unit, not when customizing weapons
	if (`SCREENSTACK.HasInstanceOf(class'UICustomize'))
		UpdateCamera(categoryIndex);
}

simulated function string GetCategoryDisplay(int catType)
{
	local string Result;

	switch (catType)
	{
	case eUICustomizeCat_Voice:
		Result = GetCategoryDisplayName("Voice", UpdatedUnitState.kAppearance.nmVoice, BodyPartFilter.FilterByGenderAndCharacterExclusive);
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
	case eUICustomizeCat_Voice:
		GetGenericCategoryList(Items, "Voice", BodyPartFilter.FilterByGenderAndCharacterExclusive, class'UICustomize_Info'.default.m_strVoice);
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
	case eUICustomizeCat_Voice:
		Result = GetCategoryValue("Voice", UpdatedUnitState.kAppearance.nmVoice, BodyPartFilter.FilterByGenderAndCharacterExclusive);
		break;
	default:
		Result = super.GetCategoryIndex(catType);
		break;
	}

	return Result;
}