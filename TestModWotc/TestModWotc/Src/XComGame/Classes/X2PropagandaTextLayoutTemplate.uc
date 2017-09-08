//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2PropagandaTextLayoutTemplate.uc
//  AUTHOR:  Joe Cortese  --  10/25/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2PropagandaTextLayoutTemplate extends X2DataTemplate
	native(Core);

enum TextBoxData
{
	TBD_FirstName,
	TBD_LastName,
	TBD_FullName,
	TBD_Class,
	TBD_ConfirmedKills,
	TBD_CountryOrigin,
	TBD_NONE,
};

enum TextLayoutType
{
	eTLT_None,
	eTLT_SingleLine,
	eTLT_DoubleLine,
	eTLT_TripleLine,
	eTLT_Promotion,
	eTLT_Captured,
};

var EGender Gender;
var ECharacterRace Race;

var int NumTextBoxes;
var int NumIcons;
var int LayoutIndex;

var int LayoutType;

var array<int> TextBoxDefaultData;
var array<int> TextBoxDefaultDataSoldierIndex;
var array<int> DefaultFontSize;

var array<int> MaxChars;

// Localized text displayed in customization screen
var localized string DisplayName;

// Indicates which mod / dlc this belongs to
var name DLCName;