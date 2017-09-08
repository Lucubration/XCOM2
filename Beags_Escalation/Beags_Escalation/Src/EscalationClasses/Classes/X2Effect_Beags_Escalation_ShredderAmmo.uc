class X2Effect_Beags_Escalation_ShredderAmmo extends X2Effect_Beags_Escalation_TransientWeaponUpgrade;

simulated function X2WeaponUpgradeTemplate GetWeaponUpgradeTemplate(XComGameState_Item WeaponState)
{
	local name UpgradeName;
	local X2WeaponUpgradeTemplate UpgradeTemplate;

	UpgradeName = class'X2Ability_Beags_Escalation_GunnerAbilitySet'.default.ShredderAmmoUpgradeName[WeaponState.GetMyTemplate().Tier];
	UpgradeTemplate = X2WeaponUpgradeTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(UpgradeName));

	return UpgradeTemplate;
}