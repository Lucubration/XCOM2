//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2PropagandaTextLayoutTemplateManager.uc
//  AUTHOR:  Joe Cortese  --  10/25/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2013 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2PropagandaTextLayoutTemplateManager extends X2DataTemplateManager
    native(Core)
	config(Content);

var protected config array<X2TextLayoutInfo> TextLayoutTemplateConfig;
var private native Map_Mirror   PhotoboothInfoTemplateCache{ TMap<FName, TMap<FName, UX2PropagandaTextLayoutTemplate*> *> };

native static function X2PropagandaTextLayoutTemplateManager GetPropagandaTextLayoutTemplateManager();

native function bool AddUberTemplate(string TextLayoutType, X2PropagandaTextLayoutTemplate Template, bool ReplaceDuplicate = false);
native function X2PropagandaTextLayoutTemplate FindUberTemplate(string TextLayoutType, name PartName);
native function GetUberTemplates(string TextLayoutType, out array<X2PropagandaTextLayoutTemplate> Templates);
native function GetFilteredUberTemplates(string TextLayoutType, Object CallbackObject, delegate<X2BodyPartFilter.FilterCallback> CallbackFn, out array<X2PropagandaTextLayoutTemplate> Templates);
native function X2PropagandaTextLayoutTemplate GetRandomUberTemplate(string TextLayoutType, Object CallbackObject, delegate<X2BodyPartFilter.FilterCallback> CallbackFn);
native function array<name> GetPropagandaPackNames();

native function InitTemplates();

protected event InitTemplatesInternal()
{
	local int i;
	local X2TextLayoutInfo TextLayoutInfo;
	local X2PropagandaTextLayoutTemplate Template;

	//== General Parts
	for (i = 0; i < TextLayoutTemplateConfig.Length; ++i)
	{
		TextLayoutInfo = TextLayoutTemplateConfig[i];

		// This is the "new", proper way of instantiating a template (requires unique TemplateName)
		Template = new(None, string(TextLayoutInfo.TemplateName)) class'X2PropagandaTextLayoutTemplate';

		Template.NumTextBoxes = TextLayoutInfo.NumTextBoxes;

		Template.LayoutIndex = TextLayoutInfo.LayoutIndex;
		Template.LayoutType = TextLayoutInfo.LayoutType;
		Template.MaxChars = TextLayoutInfo.MaxChars;
		Template.TextBoxDefaultData = TextLayoutInfo.TextBoxDefaultData;
		Template.TextBoxDefaultDataSoldierIndex = TextLayoutInfo.TextBoxDefaultDataSoldierIndex;
		Template.DefaultFontSize = TextLayoutInfo.DefaultFontSize;

		Template.NumIcons = TextLayoutInfo.NumIcons;

		Template.DisplayName = TextLayoutInfo.DisplayName;

		// Which content pack this part belongs to, either DLC or Mod
		Template.DLCName = TextLayoutInfo.DLCName;

		Template.SetTemplateName(TextLayoutInfo.TemplateName);
		AddUberTemplate("Text", Template, true);
	}

}

cpptext
{
	TMap<FName, UX2PropagandaTextLayoutTemplate*> *GetTextLayoutMap(const TCHAR *TextLayoutType);

}