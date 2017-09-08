//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepEffectTemplateManager.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2SitRepEffectTemplateManager extends X2DataTemplateManager
	native(Core);

native static function X2SitRepEffectTemplateManager GetSitRepEffectTemplateManager() const;
native function X2SitRepEffectTemplate FindSitRepEffectTemplate(name DataName) const;

function bool AddSitRepEffectTemplate(X2SitRepEffectTemplate Template, bool ReplaceDuplicate = false)
{
	return AddDataTemplate(Template, ReplaceDuplicate);
}

DefaultProperties
{
	TemplateDefinitionClass = class'X2SitRepEffect'
	ManagedTemplateClass = class'X2SitRepEffectTemplate'
}