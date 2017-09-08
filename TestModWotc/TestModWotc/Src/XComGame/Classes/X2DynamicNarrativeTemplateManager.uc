//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2DynamicNarrativeTemplateManager.uc
//  AUTHOR:  Joe Weinhoffer  --  8/11/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2DynamicNarrativeTemplateManager extends X2DataTemplateManager
	native(Core);

native static function X2DynamicNarrativeTemplateManager GetDynamicNarrativeTemplateManager();

function bool AddDynamicNarrativeTemplate(X2DynamicNarrativeTemplate Template, bool ReplaceDuplicate = false)
{
	return AddDataTemplate(Template, ReplaceDuplicate);
}

function X2DynamicNarrativeTemplate FindDynamicNarrativeTemplate(name DataName)
{
	local X2DataTemplate kTemplate;

	kTemplate = FindDataTemplate(DataName);
	if (kTemplate != none)
	{
		return X2DynamicNarrativeTemplate(kTemplate);
	}
	return none;
}

function array<X2DynamicNarrativeTemplate> GetAllTemplatesOfClass(class<X2DynamicNarrativeTemplate> TemplateClass, optional int UseTemplateGameArea = -1)
{
	local array<X2DynamicNarrativeTemplate> arrTemplates;
	local X2DataTemplate Template;

	foreach IterateTemplates(Template, none)
	{
		if ((UseTemplateGameArea > -1) && !Template.IsTemplateAvailableToAllAreas(UseTemplateGameArea))
			continue;

		if (ClassIsChildOf(Template.Class, TemplateClass))
		{
			arrTemplates.AddItem(X2DynamicNarrativeTemplate(Template));
		}
	}

	return arrTemplates;
}

defaultproperties
{
	TemplateDefinitionClass = class'X2DynamicNarrative'
}