class PA_XComHeadquartersCheatManager
	extends  XComHeadquartersCheatManager 
	within XComHeadquartersController;

// Level up aliens only
exec function LevelUpAliens(optional int Ranks = 1)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local int idx, i, RankUps, NewRank;
	local name SoldierClassName;
	local X2CharacterTemplate CharacterTemplate;
	local bool bIsAlien;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Rankup Aliens Cheat");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	`log ("davea debug lua enter " @ XComHQ.Crew.Length @ " total crew");
	for(idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

		if(UnitState != none && UnitState.GetRank() < (class'X2ExperienceConfig'.static.GetMaxRank() - 1))
		{
			CharacterTemplate = UnitState.GetMyTemplate();
			bIsAlien = CharacterTemplate.bIsAlien;
			if (! bIsAlien) 
				continue;
			NewGameState.AddStateObject(UnitState);
			NewRank = UnitState.GetRank() + Ranks;

			if(NewRank >= class'X2ExperienceConfig'.static.GetMaxRank())
			{
				NewRank = (class'X2ExperienceConfig'.static.GetMaxRank());
			}

			RankUps = NewRank - UnitState.GetRank();

			for(i = 0; i < RankUps; i++)
			{
				SoldierClassName = '';
				if(UnitState.GetRank() == 0)
				{
					SoldierClassName = XComHQ.SelectNextSoldierClass();
				}
				`log ("davea debug lua " @ UnitState.SafeGetCharacterLastName() @ " template " @ UnitState.GetMyTemplateName() @ " isAlien " @ bIsAlien);
				UnitState.RankUpSoldier(NewGameState, SoldierClassName);

				if(UnitState.GetRank() == 1)
				{
					UnitState.ApplySquaddieLoadout(NewGameState, XComHQ);
					UnitState.ApplyBestGearLoadout(NewGameState); // Make sure the squaddie has the best gear available
				}
			}

			UnitState.StartingRank = NewRank;
			UnitState.SetXPForRank(NewRank);
		}
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}


// Sometimes alien armor is not available in the locker, re-grant all of it
exec function GiveAlienArmor()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState NewGameState;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item ItemState;

	`log ("davea debug gaa enter");
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Give Alien Armor Cheat");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	// For each armor, add item to HQ inventory so it is available in loadout locker choices
	if (XComHQ.GetNumItemInInventory('PA_BerserkerArmor') == 0) {
		ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_BerserkerArmor');
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		XComHQ.AddItemToHQInventory(ItemState);
		NewGameState.AddStateObject(ItemState);
		`log ("davea debug gaa grant berserker");
	}
	if (XComHQ.GetNumItemInInventory('PA_ChrysArmor') == 0) {
		ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_ChrysArmor');
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		XComHQ.AddItemToHQInventory(ItemState);
		NewGameState.AddStateObject(ItemState);
		`log ("davea debug gaa grant chrys");
	}
	if (XComHQ.GetNumItemInInventory('PA_MecArmor') == 0) {
		ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_MecArmor');
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		XComHQ.AddItemToHQInventory(ItemState);
		NewGameState.AddStateObject(ItemState);
		`log ("davea debug gaa grant mec");
	}
	if (XComHQ.GetNumItemInInventory('PA_MecHeavyArmor') == 0) {
		ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_MecHeavyArmor');
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		XComHQ.AddItemToHQInventory(ItemState);
		NewGameState.AddStateObject(ItemState);
		`log ("davea debug gaa grant mec");
	}
	if (XComHQ.GetNumItemInInventory('PA_MutonArmor') == 0) {
		ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_MutonArmor');
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		XComHQ.AddItemToHQInventory(ItemState);
		NewGameState.AddStateObject(ItemState);
		`log ("davea debug gaa grant muton");
	}
	if (XComHQ.GetNumItemInInventory('PA_ViperArmor') == 0) {
		ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_ViperArmor');
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		XComHQ.AddItemToHQInventory(ItemState);
		NewGameState.AddStateObject(ItemState);
		`log ("davea debug gaa grant viper");
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}
