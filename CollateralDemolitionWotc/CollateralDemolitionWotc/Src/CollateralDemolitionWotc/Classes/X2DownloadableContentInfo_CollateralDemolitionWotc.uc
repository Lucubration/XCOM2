//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_CollateralDemolition.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_CollateralDemolitionWotc extends X2DownloadableContentInfo
	config(CollateralDemolitionWotc);
    
var config int CollateralDemolitionCooldown;
var config int CollateralDemolitionDamage;
var config int CollateralDemolitionRadius;

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
	// Any template edits go here
	UpdateDemolitionTemplate();
}

static function UpdateDemolitionTemplate()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_ApplyWeaponDamage		WorldDamage;

	// Trying the replacer method now

	// Find the Demolition ability template
	Template = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('Demolition');
	if (Template != none)
	{
		// Configurable cooldown helps me test it
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.CollateralDemolitionCooldown;
		Template.AbilityCooldown = Cooldown;
		
		CursorTarget = new class'X2AbilityTarget_Cursor';
		CursorTarget.bRestrictToWeaponRange = true;
		Template.AbilityTargetStyle = CursorTarget;

		// Slightly modified from Rocket Launcher template to let it get over blocking cover better
		Template.TargetingMethod = class'X2TargetingMethod_CollateralDemolition';
		
		// Give it a radius multi-target
		RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
		RadiusMultiTarget.fTargetRadius = `UNITSTOMETERS(default.CollateralDemolitionRadius);
		Template.AbilityMultiTargetStyle = RadiusMultiTarget;

		// I really wish I could REPLACE the existing effect, but since I can't I'm just adding a new effect. If any Firaxis
		// employees read this, that's a cumbersome and totally unjustifyable restriction. Please stop doing stuff like that
		WorldDamage = new class'X2Effect_ApplyWeaponDamage';
		WorldDamage.EnvironmentalDamageAmount = default.CollateralDemolitionDamage;
		WorldDamage.bApplyOnHit = false;
		WorldDamage.bApplyOnMiss = false;
		WorldDamage.bApplyToWorldOnHit = true;
		WorldDamage.bApplyToWorldOnMiss = true;
		Template.AddTargetEffect(WorldDamage);

		// And I'm neutering the existing effect
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).EnvironmentalDamageAmount = 0;
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).bHitAdjacentDestructibles = false;
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).bHitSourceTile = false;
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).bHitTargetTile = false;
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).bApplyOnHit = false;
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).bApplyOnMiss = false;
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).bApplyToWorldOnHit = false;
		X2Effect_ApplyDirectionalWorldDamage(Template.AbilityTargetEffects[0]).bApplyToWorldOnMiss = false;

		`LOG("Collateral Demolition: Updated " @ Template.DataName @ " template.");
	}
}