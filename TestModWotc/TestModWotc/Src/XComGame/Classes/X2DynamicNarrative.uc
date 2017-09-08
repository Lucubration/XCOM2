//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrative.uc
//  AUTHOR:  Joe Weinhoffer
//    
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2DynamicNarrative extends X2DataSet;

static event array<X2DataTemplate> CreateDynamicNarrativeTemplatesEvent()
{
	return CreateDynamicNarrativeTemplates();
}

static function array<X2DataTemplate> CreateDynamicNarrativeTemplates();