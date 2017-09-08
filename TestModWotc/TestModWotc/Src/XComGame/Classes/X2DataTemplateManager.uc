//---------------------------------------------------------------------------------------
//  FILE:    X2DataTemplateManager.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2DataTemplateManager extends Object
	abstract
	native(Core)
	config(GameCore);

var float RookieDfficultyThreshold;
var float VeteranDfficultyThreshold;
var float CommanderDfficultyThreshold;
var float LegendDfficultyThreshold;
var float ImpossibleDfficultyThreshold;

var bool bDifficultySelectionFromStrategy;

var const config array<string> TemplateOverridePackageNames;

var private bool bInitializingTemplates;

var private{private} native Map_Mirror   GameDataCacheRookie{TMap<FName, UX2DataTemplate*>};
var private{private} native Map_Mirror   GameDataCacheVeteran{TMap<FName, UX2DataTemplate*>};
var private{private} native Map_Mirror   GameDataCacheCommander{TMap<FName, UX2DataTemplate*>};
var private{private} native Map_Mirror   GameDataCacheLegend{TMap<FName, UX2DataTemplate*>};
var private{private} native Map_Mirror   GameDataCacheImpossible{TMap<FName, UX2DataTemplate*>};

var private{private} native Map_Mirror   GameDataCacheCurrent{TMap<FName, UX2DataTemplate*>};

var protected class<X2DataSet>  TemplateDefinitionClass;    // The class to extend from to create templates for the manager. See X2Ability / X2AbilityTemplateManager, etc.
var protected class<X2DataTemplate> ManagedTemplateClass;   // The base class of the templates we can accept 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// rebuilds the game data cache based on campaign difficulty settings.  Should be called any time difficulty settings change
static native function RebuildAllTemplateGameCaches();

delegate bool TemplateIteratorCompareDelegate(X2DataTemplate Template);
native iterator function IterateTemplates(out X2DataTemplate Template, delegate<TemplateIteratorCompareDelegate> CompareFunc = none);
native function GetTemplateNames(out array<name> TemplateNames) const;

/**
 *  Adds the template to the GameDataCache, if its DataName is not already mapped.
 *  @param Data is a new template you've created.
 *  @param ReplaceDuplicate allows the template to replace one already in the map with the same name.
 *  @return true if the template was added to the map, false if not (name already taken)
 *  
 *  Child classes should implement a public wrapper that accepts only templates of the appropriate class.
 */
protected native function bool AddDataTemplate(X2DataTemplate Data, bool ReplaceDuplicate = false);

/** 
 *  @return the template in the GameDataCache that matches the provided name. 
 *  Child classes should implement a public wrapper that returns the class appropriate to the manager.
 */
protected native function X2DataTemplate FindDataTemplate(name DataName) const;

/** 
 *  @param Templates is an array of templates in the all GameDataCaches that match the provided name. 
 *  Child classes should implement a public wrapper that returns the class appropriate to the manager.
 */
native function FindDataTemplateAllDifficulties(name DataName, out array<X2DataTemplate> Templates) const;

/** Called from native code XComEngine::Init(). */
native function InitTemplates();

/** Override able method for script-only managers access */
function LoadAllContent()
{
	
}

/** Called after all template managers have initialized, to verify references to other templates are valid. **/
protected event ValidateTemplatesEvent()
{
	local X2DataTemplate Template;
	local string strError;

	foreach IterateTemplates(Template, none)
	{
		if (!Template.ValidateTemplate(strError))
		{
			`RedScreen(string(Template.Class) @ Template.DataName @ "is invalid:" @ strError,,'XCom_Templates');
		}
	}
}

cpptext
{
	// helper function to access the game data cache appropriate to this template manager for the currently selected difficulty setting
	TMap<FName, UX2DataTemplate*>& GetGameDataCache();
	const TMap<FName, UX2DataTemplate*>& GetGameDataCache() const;
	void RemoveDataTemplate(const FName& TemplateName);

	// builds the current game cache based on the current difficulty
	void BuildCurrentGameDataCache();


private:
	// helper function to get the current difficulty setting that is applicable to this template manager
	FLOAT GetDifficultySetting() const;

	// Helper function to update the current data cache by scaling between threshold data
	void BuildCurrentGameDataCacheFromThresholds(
		const TMap<FName, UX2DataTemplate*>& LowThresholdData,
		const TMap<FName, UX2DataTemplate*>& HighThresholdData,
		FLOAT CurrentValue,
		FLOAT LowThresholdValue,
		FLOAT HighThresholdValue);
}

defaultproperties
{
	RookieDfficultyThreshold=0.0
	VeteranDfficultyThreshold=25.0
	CommanderDfficultyThreshold=50.0
	LegendDfficultyThreshold=75.0
	ImpossibleDfficultyThreshold=100.0
}