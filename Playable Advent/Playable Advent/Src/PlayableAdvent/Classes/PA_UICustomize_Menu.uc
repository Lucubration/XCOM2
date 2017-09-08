class PA_UICustomize_Menu extends UICustomize_Menu;

simulated function UpdateData()
{
	local int i;
	local bool bIsObstructed;
	local EUIState ColorState;
	local int currentSel;
	local X2CharacterTemplate CharacterTemplate;
	local bool bIsAlien;
	local string m_strAlienNoCustomize;

	m_strAlienNoCustomize = "This cannot be customized for alien troops";
	currentSel = List.SelectedIndex;
	CharacterTemplate = Unit.GetMyTemplate();
	bIsAlien = CharacterTemplate.bIsAlien;
	`log ("davea debug uicm alien " @ bIsAlien @ " veteran " @ bDisableVeteranOptions);

	super.UpdateData();

	// Hide all existing options since the number of options can change if player switches genders
	HideListItems();

	CustomizeManager.UpdateBodyPartFilterForNewUnit(CustomizeManager.Unit);

	// INFO
	//-----------------------------------------------------------------------------------------
	GetListItem(i++).UpdateDataDescription(class'UIUtilities_Text'.static.GetColoredText(m_strEditInfo, eUIState_Normal), OnCustomizeInfo);

	// PROPS
	//-----------------------------------------------------------------------------------------
	ColorState = bIsAlien ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++)
		.UpdateDataDescription(class'UIUtilities_Text'.static.GetColoredText(m_strEditProps, ColorState), OnCustomizeProps)
		.SetDisabled(bIsAlien, m_strAlienNoCustomize);

	// FACE
	//-----------------------------------------------------------------------------------------
	ColorState = (bIsSuperSoldier || bIsAlien) ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++)
		.UpdateDataValue(class'UIUtilities_Text'.static.GetColoredText(m_strFace, ColorState), CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Face, ColorState, FontSize), CustomizeFace)
		.SetDisabled(bIsSuperSoldier || bIsAlien, bIsSuperSoldier ? m_strIsSuperSoldier : m_strAlienNoCustomize);

	// HAIRSTYLE
	//-----------------------------------------------------------------------------------------
	bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).HelmetContent.FallbackHairIndex <= -1;
	ColorState = (bIsSuperSoldier || bIsObstructed || bIsAlien) ? eUIState_Disabled : eUIState_Normal;

	GetListItem(i++)
		.UpdateDataValue(class'UIUtilities_Text'.static.GetColoredText(m_strHair, ColorState), CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Hairstyle, ColorState, FontSize), CustomizeHair)
		.SetDisabled(bIsSuperSoldier || bIsObstructed || bIsAlien, bIsSuperSoldier ? m_strIsSuperSoldier : (bIsObstructed ? m_strRemoveHelmet : m_strAlienNoCustomize));

	// FACIAL HAIR
	//-----------------------------------------------------------------------------------------
	if(CustomizeManager.ShowMaleOnlyOptions())
	{
		bIsObstructed = CustomizeManager.IsFacialHairDisabled();
		ColorState = (bIsSuperSoldier || bIsObstructed || bIsAlien) ? eUIState_Disabled : eUIState_Normal;

		GetListItem(i++)
			.UpdateDataValue(class'UIUtilities_Text'.static.GetColoredText(m_strFacialHair, ColorState), CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_FacialHair, ColorState, FontSize), CustomizeFacialHair)
			.SetDisabled(bIsSuperSoldier || bIsObstructed || bIsAlien, bIsSuperSoldier ? m_strIsSuperSoldier : (bIsObstructed ? m_strRemoveHelmetOrLowerProp : m_strAlienNoCustomize));
	}

	// HAIR COLOR
	//----------------------------------------------------------------------------------------
	bIsObstructed = XComHumanPawn(CustomizeManager.ActorPawn).HelmetContent.FallbackHairIndex <= -1 && 
					(CustomizeManager.UpdatedUnitState.kAppearance.iGender == eGender_Female ||
					(CustomizeManager.HasBeard() && !XComHumanPawn(CustomizeManager.ActorPawn).HelmetContent.bHideFacialHair));
	ColorState = (bIsSuperSoldier || bIsObstructed || bIsAlien) ? eUIState_Disabled : eUIState_Normal;

	GetListItem(i++)
		.UpdateDataColorChip(class'UIUtilities_Text'.static.GetColoredText(m_strHairColor, ColorState), CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_HairColor), HairColorSelector)
		.SetDisabled(bIsSuperSoldier || bIsObstructed || bIsAlien, bIsSuperSoldier ? m_strIsSuperSoldier : (bIsObstructed ? m_strRemoveHelmet : m_strAlienNoCustomize));


	// EYE COLOR
	//-----------------------------------------------------------------------------------------
	ColorState = (bIsSuperSoldier || bIsAlien) ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++)
		.UpdateDataColorChip(class'UIUtilities_Text'.static.GetColoredText(m_strEyeColor, ColorState), CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_EyeColor), EyeColorSelector)
		.SetDisabled(bIsSuperSoldier || bIsAlien, bIsSuperSoldier ? m_strIsSuperSoldier : m_strAlienNoCustomize);

	// RACE
	//-----------------------------------------------------------------------------------------
	ColorState = bIsAlien ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++)
		.UpdateDataValue(class'UIUtilities_Text'.static.GetColoredText(m_strRace, ColorState), CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Race, ColorState, FontSize), CustomizeRace)
		.SetDisabled(bIsAlien, m_strAlienNoCustomize);

	// SKIN COLOR
	//-----------------------------------------------------------------------------------------
	ColorState = bIsAlien ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++)
		.UpdateDataColorChip(class'UIUtilities_Text'.static.GetColoredText(m_strSkinColor, ColorState), CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_Skin), SkinColorSelector)
		.SetDisabled(bIsAlien, m_strAlienNoCustomize);

	// ARMOR PRIMARY COLOR
	//-----------------------------------------------------------------------------------------
	ColorState = eUIState_Normal;
	GetListItem(i++).UpdateDataColorChip(class'UIUtilities_Text'.static.GetColoredText(m_strMainColor, ColorState),
		CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_PrimaryArmorColor), PrimaryArmorColorSelector);

	// ARMOR SECONDARY COLOR
	//-----------------------------------------------------------------------------------------
	ColorState = eUIState_Normal;
	GetListItem(i++).UpdateDataColorChip(class'UIUtilities_Text'.static.GetColoredText(m_strSecondaryColor, ColorState),
		CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_SecondaryArmorColor), SecondaryArmorColorSelector);

	// WEAPON PRIMARY COLOR
	//-----------------------------------------------------------------------------------------
	ColorState = bIsAlien ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++).UpdateDataColorChip(class'UIUtilities_Text'.static.GetColoredText(m_strWeaponColor, ColorState),
		CustomizeManager.GetCurrentDisplayColorHTML(eUICustomizeCat_WeaponColor), WeaponColorSelector)
		.SetDisabled(bIsAlien, m_strAlienNoCustomize);

	// VOICE
	//-----------------------------------------------------------------------------------------
	ColorState = eUIState_Normal;
	GetListItem(i++).UpdateDataValue(class'UIUtilities_Text'.static.GetColoredText(m_strVoice, ColorState), CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Voice, ColorState, FontSize), CustomizeVoice);

	// ATTITUDE (VETERAN)
	//-----------------------------------------------------------------------------------------
	ColorState = (bDisableVeteranOptions || bIsAlien) ? eUIState_Disabled : eUIState_Normal;
	GetListItem(i++, bDisableVeteranOptions || bIsAlien).UpdateDataValue(class'UIUtilities_Text'.static.GetColoredText(m_strAttitude, ColorState),
		CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Personality, ColorState, FontSize), CustomizePersonality);

	//  CHARACTER POOL OPTIONS
	//-----------------------------------------------------------------------------------------
	//If in the armory, allow exporting character to the pool
	if (bInArmory && !bIsAlien)
	{
		GetListItem(i++).UpdateDataDescription(class'UIUtilities_Text'.static.GetColoredText(m_strExportCharacter, eUIState_Normal), OnExportSoldier);
	}
	else if (!bIsAlien) //Otherwise, allow customizing their potential appearances
	{
		if(!bInMP)
		{
			if(Unit.IsSoldier())
				GetListItem(i++).UpdateDataValue(class'UIUtilities_Text'.static.GetColoredText(m_strCustomizeClass, eUIState_Normal),
					CustomizeManager.FormatCategoryDisplay(eUICustomizeCat_Class, eUIState_Normal, FontSize), CustomizeClass);

			GetListItem(i++).UpdateDataCheckbox(class'UIUtilities_Text'.static.GetColoredText(m_strAllowTypeSoldier, eUIState_Normal), m_strAllowed, CustomizeManager.UpdatedUnitState.bAllowedTypeSoldier, OnCheckbox_Type_Soldier);
			GetListItem(i++).UpdateDataCheckbox(class'UIUtilities_Text'.static.GetColoredText(m_strAllowTypeVIP, eUIState_Normal), m_strAllowed, CustomizeManager.UpdatedUnitState.bAllowedTypeVIP, OnCheckbox_Type_VIP);
			GetListItem(i++).UpdateDataCheckbox(class'UIUtilities_Text'.static.GetColoredText(m_strAllowTypeDarkVIP, eUIState_Normal), m_strAllowed, CustomizeManager.UpdatedUnitState.bAllowedTypeDarkVIP, OnCheckbox_Type_DarkVIP);

			GetListItem(i).UpdateDataDescription(class'UIUtilities_Text'.static.GetColoredText(m_strTimeAdded @ CustomizeManager.UpdatedUnitState.PoolTimestamp, eUIState_Disabled), None);
			GetListItem(i++).SetDisabled(true);
		}
	}

	if (currentSel > -1 && currentSel < List.ItemCount)
	{
		List.Navigator.SetSelected(GetListItem(currentSel));
	}
	else
	{
		List.Navigator.SetSelected(GetListItem(0));
	}
	//-----------------------------------------------------------------------------------------
}
