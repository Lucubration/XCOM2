class UIStrategyScreenListener_Lucu_CombatEngineer extends UIStrategyScreenListener;

event OnInit(UIScreen Screen)
{
	local UIScreen CurrentScreen;

    if (IsInStrategy())
    {
	    CurrentScreen = `SCREENSTACK.GetCurrentScreen();

		// Try to add the Combat Engineer's GTS perk
		//AddSoldierUnlockTemplate('OfficerTrainingSchool', '');

		if (CurrentScreen.IsA('UIArmory'))
        {
            // Try to add the Combat Engineer's starting weapons to the XCom HQ inventory
            AddStartingItemToXComHQ('Bullpup_CV');
            AddStartingItemToXComHQ(class'X2Item_Lucu_CombatEngineer_Weapons'.default.DetpackCVItemName);
        }

        if (CurrentScreen.IsA('UIFacility_ProvingGround'))
        {
            AddTechToHistory(class'X2StrategyElement_Lucu_CombatEngineer_Techs'.default.PlasmaPackTechTemplateName);
        }
	}
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