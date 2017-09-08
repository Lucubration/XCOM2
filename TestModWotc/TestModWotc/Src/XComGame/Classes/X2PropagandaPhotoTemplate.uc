//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2PropagandaPhotoTemplate.uc
//  AUTHOR:  Joe Cortese  --  10/25/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2PropagandaPhotoTemplate extends X2DataTemplate
	native(Core);

var int NumSoldiers;

var EGender Gender;
var ECharacterRace Race;
var string LayoutBlueprint;
var string CameraFocus;
var array<String> LocationTags;

var array<String> DefaultPose;

var array<String> AllowedClasses;
var array<String> BlockedClasses;

// Localized text displayed in customization screen
var localized string DisplayName;

// Indicates which mod / dlc this belongs to
var name DLCName;

function bool IsUnitAllowed(int LocationIndex, XComGameState_Unit Unit)
{
	local String classTemplateName, kAllowedClasses, kBlockedClasses;

	if (Unit != none)
	{
		classTemplateName = String(Unit.GetSoldierClassTemplateName());
		if (LocationIndex < AllowedClasses.Length && AllowedClasses[LocationIndex] != "")
		{
			kAllowedClasses = AllowedClasses[LocationIndex];
			if (InStr(kAllowedClasses, classTemplateName) == -1)
				return false;
		}
		if (LocationIndex < BlockedClasses.Length && BlockedClasses[LocationIndex] != "")
		{
			kBlockedClasses = BlockedClasses[LocationIndex];
			if (InStr(kBlockedClasses, classTemplateName) != -1)
				return false;
		}
	}

	return true;
}