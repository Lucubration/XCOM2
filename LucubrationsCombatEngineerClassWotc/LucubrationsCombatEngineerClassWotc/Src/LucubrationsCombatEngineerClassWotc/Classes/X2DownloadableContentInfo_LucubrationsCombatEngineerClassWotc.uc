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
{
    Initialize();
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
    Initialize();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
    Initialize();
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
}

static function Initialize()
{
	// Try to add the Combat Engineer's GTS perk
	//AddSoldierUnlockTemplate('OfficerTrainingSchool', '');

    // Try to add the Combat Engineer's starting weapons to the XCom HQ inventory
    AddStartingItemToXComHQ(class'X2Item_Lucu_CombatEngineer_Weapons'.default.DetpackCVItemName);

    // Try to add the Combat Engineer's Plasma Pack tech to the game history
    AddTechToHistory(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.PlasmaPackTechTemplateName);
    AddTechToHistory(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.SIMONMKIITechTemplateName);
    AddTechToHistory(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.DeployableCoverMKIITechTemplateName);
}

static function AddSoldierUnlockTemplate(name FacilityName, name UnlockName)
{
	local X2FacilityTemplate FacilityTemplate;

	// Find the GTS facility template
	FacilityTemplate = X2FacilityTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(FacilityName));
	if (FacilityTemplate == none)
		return;

	if (FacilityTemplate.SoldierUnlockTemplates.Find(UnlockName) != INDEX_NONE)
		return;

	// Update the GTS template with the specified soldier unlock
	FacilityTemplate.SoldierUnlockTemplates.AddItem(UnlockName);

	`LOG("Lucubration Combat Engineer Class: Updated [" @ FacilityName @ "] template with [" @ UnlockName @ "].");
}

static function AddStartingItemToXComHQ(name TemplateName)
{
    local XComGameState_HeadquartersXCom XComHQ;
    local XComGameStateHistory History;
    local X2ItemTemplate ItemTemplate;
    local XComGameState NewGameState;
    local XComGameState_Item NewItemState;
    
    History = `XCOMHISTORY;
    
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    
    if (XComHQ.GetNumItemInInventory(TemplateName) == 0)
    {
        ItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(TemplateName);
    
        if (ItemTemplate != none)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add [" @ string(TemplateName) @ "].");
            XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
            NewGameState.AddStateObject(XComHQ);
        
            NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
            NewGameState.AddStateObject(NewItemState);
            XComHQ.AddItemToHQInventory(NewItemState);
        
		    `GAMERULES.SubmitGameState(NewGameState);
        
            `Log("Lucubration Combat Engineer Class: Item [" @ TemplateName @ "] added to HQ.");
        }
    }
}

static function AddTechToHistory(name TemplateName)
{
    local XComGameStateHistory History;
    local X2TechTemplate TechTemplate;
    local XComGameState NewGameState;
    local XComGameState_Tech TechState;
    
    History = `XCOMHISTORY;
    
	foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
    {
        if (TechState.GetMyTemplateName() == TemplateName)
        {
            return;
        }
    }
    
    TechTemplate = X2TechTemplate(class'XComGameState_Tech'.static.GetMyTemplateManager().FindStrategyElementTemplate(TemplateName));
    
    if (TechTemplate != none)
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding tech [" @ string(TemplateName) @ "] to history.");
        TechState = XComGameState_Tech(NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate));
        NewGameState.AddStateObject(TechState);
        
		`GAMERULES.SubmitGameState(NewGameState);
        
        `Log("Lucubration Combat Engineer Class: Tech [" @ TemplateName @ "] added to history.");
    }
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
