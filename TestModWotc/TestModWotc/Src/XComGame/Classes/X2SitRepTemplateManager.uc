//---------------------------------------------------------------------------------------
//  FILE:    X2SitRepTemplateManager.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2SitRepTemplateManager extends X2DataTemplateManager
	native(Core);

// template strings go here to prevent lots of per-object duplication
var const localized string NotEnoughSoldiers;

native static function X2SitRepTemplateManager GetSitRepTemplateManager() const;
native function X2SitRepTemplate FindSitRepTemplate(name DataName) const;

function bool AddSitRepTemplate(X2SitRepTemplate Template, bool ReplaceDuplicate = false)
{
	return AddDataTemplate(Template, ReplaceDuplicate);
}

// Check sit rep template if civilian hostility should be overridden with the Sit Rep.  (Override makes them XCom-friendly)
static function bool ShouldOverrideCivilianHostility(Name SitRepName)
{
	local X2SitRepTemplate SitRepTemplate;
	SitRepTemplate = GetSitRepTemplateManager().FindSitRepTemplate(SitRepName);
	return SitRepTemplate.bOverrideCivilianHostility;
}

// utility function to scan all templates in the given list and return all effects of the given class they contain.
// So for example, if you want to get all X2SitRepEffect_SquadSize objects that exist in the current sitrep list,
// you would call this function as GetAllEffectsOfClass(ActiveSitrepTemplateNames, class'X2SitRepEffect_SquadSize')
static native final iterator function IterateEffects(class<object> SitRepEffectClass, out object Effect, const out array<name> SitrepTemplateNames);

DefaultProperties
{
	TemplateDefinitionClass=class'X2SitRep'
	ManagedTemplateClass=class'X2SitRepTemplate'
}