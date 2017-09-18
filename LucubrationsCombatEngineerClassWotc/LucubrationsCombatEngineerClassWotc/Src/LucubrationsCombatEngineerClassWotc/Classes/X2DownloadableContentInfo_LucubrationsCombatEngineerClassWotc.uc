//---------------------------------------------------------------------------------------
//  FILE:   X2DownloadableContentInfo_LucubrationsCombatEngineerClassWotc.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LucubrationsCombatEngineerClassWotc extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	// Update the conventional bullpup template to make it starting equipment
    MakeStartingItemTemplate('Bullpup_CV');

    // Update all standard aim abilities except Detonate to prevent shooting directly at det packs
    PreventTargetingDetPacks();
}

static function MakeStartingItemTemplate(name TemplateName)
{
    local X2ItemTemplate ItemTemplate;
    
    ItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(TemplateName);

    if (ItemTemplate != none)
    {
        if (!ItemTemplate.StartingItem)
        {
            ItemTemplate.StartingItem = true;
        
            `Log("Lucubration Combat Engineer Class: Item template [" @ TemplateName @ "] set to starting equipment.");
        }
    }
}

static function PreventTargetingDetPacks()
{
    local X2DataTemplate DataTemplate;
    local X2AbilityTemplate AbilityTemplate;
    local X2AbilityToHitCalc_StandardAim StandardAim;
    local X2Condition_Lucu_CombatEngineer_IsActiveDetPack IsDetPackCondition;

	foreach class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().IterateTemplates(DataTemplate, none)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if (AbilityTemplate != none &&
            AbilityTemplate.DataName != class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.DetonateAbilityTemplateName)
		{
			StandardAim = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
			if (StandardAim != none)
            {
                IsDetPackCondition = new class'X2Condition_Lucu_CombatEngineer_IsActiveDetPack';
                IsDetPackCondition.IsDetPack = false;
                AbilityTemplate.AbilityTargetConditions.AddItem(IsDetPackCondition);
    			
                `LOG("Lucubration Combat Engineer Class: Applied Det Pack protection to ability template " @ string(AbilityTemplate.DataName) @ ".");
            }
		}
	}
}
