//---------------------------------------------------------------------------------------
//  FILE:    X2DynamicNarrativeTemplate.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DynamicNarrativeTemplate extends X2DataTemplate
	native(core);

function X2DynamicNarrativeTemplateManager GetMyTemplateManager()
{
	return class'X2DynamicNarrativeTemplateManager'.static.GetDynamicNarrativeTemplateManager();
}

DefaultProperties
{
}