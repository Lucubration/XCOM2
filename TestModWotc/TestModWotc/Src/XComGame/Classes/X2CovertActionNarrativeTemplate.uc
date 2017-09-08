//---------------------------------------------------------------------------------------
//  FILE:    X2CovertActionNarrativeTemplate.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2CovertActionNarrativeTemplate extends X2StrategyElementTemplate
	config(GameBoard);

// Data
var config name					AssociatedFaction;
var config String					ActionImage;

// Text
var localized String				ActionName;
var localized String				ActionPreNarrative;
var localized String				ActionPostNarrative;