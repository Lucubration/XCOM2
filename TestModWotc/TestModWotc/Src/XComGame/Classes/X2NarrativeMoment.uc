//---------------------------------------------------------------------------------------
//  FILE:    X2NarrativeMoment.uc
//  AUTHOR:  Dan Kaplan  --  4/10/2015
//  PURPOSE: A Narrative Moment that supports a UI-Only modal
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2NarrativeMoment extends XComNarrativeMoment
	PerObjectConfig;


// The UI screen class to create
var() class<UIScreen>				UIScreenClass;

// The Text that will fill out the header of the UIScreen when eType == eNarrMoment_UIOnly.
var() localized string				UIHeaderText;

// The Text that will fill out the body of the UIScreen when eType == eNarrMoment_UIOnly.
var() localized string				UIBodyText;

// The path to the image that will fill out the UIScreen when eType == eNarrMoment_UIOnly.
var() string						UIImagePath;

// The Text that will fill out the array of additional strings of the UIScreen when eType == eNarrMoment_UIOnly.
var() localized array<string>		UIArrayText;

function PopulateUIData(delegate<X2StrategyGameRulesetDataStructures.AlertCallback> CallbackFunction)
{
	local DynamicPropertySet PropertySet;
	local array<DynamicProperty> ArrayProperty;
	local int Index;

	class'XComHQPresentationLayer'.static.BuildUIAlert(PropertySet, 'eAlert_Objective', CallbackFunction, '', "GeoscapeAlerts_NewObjective");
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(PropertySet, 'UIHeaderText', UIHeaderText);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(PropertySet, 'UIBodyText', UIBodyText);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(PropertySet, 'UIImagePath', UIImagePath);
	
	for( Index = 0; Index < UIArrayText.Length; ++Index )
	{
		class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringPropertyToArray(ArrayProperty, '', UIArrayText[Index]);
	}
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicArrayProperty(PropertySet, 'UIArrayText', ArrayProperty);

	class'XComHQPresentationLayer'.static.QueueDynamicPopup(PropertySet);
}

defaultproperties
{
}



