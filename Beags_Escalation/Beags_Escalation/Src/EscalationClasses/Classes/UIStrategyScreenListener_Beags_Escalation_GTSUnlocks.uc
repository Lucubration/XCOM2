class UIStrategyScreenListener_Beags_Escalation_GTSUnlocks extends UIStrategyScreenListener;

event OnInit(UIScreen Screen)
{
    if (IsInStrategy())
    {
		// This stuff really needs to move out of UIScreenListener, but I can't do it until they give us
		// an OnLoadGame function that is called for *every* game load, not just new ones

		// Try to add the GTS perks
		AddTrainingUnlockTemplate('OfficerTrainingSchool', 'Beags_Escalation_Recon_Unlock');
		AddTrainingUnlockTemplate('OfficerTrainingSchool', 'Beags_Escalation_LowProfile_Unlock');
		AddTrainingUnlockTemplate('OfficerTrainingSchool', 'Beags_Escalation_RocketSnapshot_Unlock');
		AddTrainingUnlockTemplate('OfficerTrainingSchool', 'Beags_Escalation_WeaponsTeam_Unlock');
		AddTrainingUnlockTemplate('OfficerTrainingSchool', 'Beags_Escalation_SuppressingFire_Unlock');
		AddTrainingUnlockTemplate('OfficerTrainingSchool', 'Beags_Escalation_Brace_Unlock');

		// Try adding HQ items to storage
		UpdateHQStorage();
	}
}

static function AddTrainingUnlockTemplate(name facilityName, name unlockName)
{
	local X2FacilityTemplate FacilityTemplate;

	// Find the GTS facility template
	FacilityTemplate = X2FacilityTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(facilityName));
	if (FacilityTemplate == none)
		return;

	if (FacilityTemplate.SoldierUnlockTemplates.Find(unlockName) == INDEX_NONE)
	{
		// Update the GTS template with the specified training unlock
		FacilityTemplate.SoldierUnlockTemplates.AddItem(unlockName);

		`LOG("Beags Escalation: Updated " @ facilityName @ " template with " @ unlockName @ ".");
	}
}

static function UpdateHQStorage()
{
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ;
	local XComGameState						NewGameState;
	local bool								Updated;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add Beags Escalation Items");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	Updated = false;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_RocketLauncher_CV') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_Rocket_HighExplosive') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_Rocket_Shredder') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_Rocket_HighExplosive_Mk2') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_Rocket_Shredder_Mk2') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_HMG_CV') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_HMG_MG') || Updated;
	Updated = UpdateHQStorageItem(XComHQ, NewGameState, 'Beags_Escalation_HMG_BM') || Updated;

	if (Updated)
	{
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function bool UpdateHQStorageItem(XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState, name TemplateName)
{
	local X2ItemTemplateManager				ItemTemplateMgr;
	local X2ItemTemplate					ItemTemplate;
	local XComGameState_Item				NewItemState;
	local bool								IsTechResearched, HQHasItem;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateMgr.FindItemTemplate(TemplateName);
	if (ItemTemplate != none)
	{
		IsTechResearched = ItemTemplate.StartingItem || (ItemTemplate.CreatorTemplateName != '' && XComHQ.IsTechResearched(ItemTemplate.CreatorTemplateName));
		HQHasItem = XComHQ.HasItem(ItemTemplate);

		if (IsTechResearched && !XComHQ.HasItem(ItemTemplate))
		{
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);

			`Log("Beags Escalation: Item " @ TemplateName @ " added to HQ.");

			return true;
		}
		else if (!IsTechResearched && HQHasItem)
		{
			NewItemState = XComHQ.GetItemByName(TemplateName);
			XComHQ.RemoveItemFromInventory(NewGameState, NewItemState.GetReference(), NewItemState.Quantity);

			`Log("Beags Escalation: Item " @ TemplateName @ " removed from HQ.");

			return true;
		}
	}

	return false;
}
