class UIStrategyScreenListener_Lucu_Sniper_GTSUnlocks extends UIStrategyScreenListener;

event OnInit(UIScreen Screen)
{
    if (IsInStrategy())
    {
		// Try to add the Sniper's GTS perk
		AddSoldierUnlockTemplate('OfficerTrainingSchool', 'Lucu_Sniper_BallisticsExpertUnlock');
	}
}

static function AddSoldierUnlockTemplate(name facilityName, name unlockName)
{
	local X2FacilityTemplate FacilityTemplate;

	// Find the GTS facility template
	FacilityTemplate = X2FacilityTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(facilityName));
	if (FacilityTemplate == none)
		return;

	if (FacilityTemplate.SoldierUnlockTemplates.Find(unlockName) != INDEX_NONE)
		return;

	// Update the GTS template with the specified soldier unlock
	FacilityTemplate.SoldierUnlockTemplates.AddItem(unlockName);

	`LOG("Lucubration Sniper Class: Updated " @ facilityName @ " template with " @ unlockName @ ".");
}
