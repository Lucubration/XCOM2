//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day90DefaultFacilities.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day90DefaultFacilities extends X2StrategyElement_DefaultFacilities;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Facilities;

	// Core Facilities
	Facilities.AddItem(CreateStorageTemplate());

	return Facilities;
}

static function X2DataTemplate CreateStorageTemplate()
{
	local X2FacilityTemplate Template;
	local StaffSlotDefinition StaffSlotDef;

	Template = X2FacilityTemplate(Super.CreateStorageTemplate());

	StaffSlotDef.StaffSlotTemplateName = 'SparkStaffSlot';
	StaffSlotDef.bStartsLocked = true;
	Template.StaffSlotDefs.AddItem(StaffSlotDef);
	
	return Template;
}