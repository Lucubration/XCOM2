class X2AmbientNarrativeCriteria_CollateralDemolition_TemplateModificator extends X2AmbientNarrativeCriteria
	config(CollateralDemolition);

var config int CollateralDemolitionCooldown;
var config int CollateralDemolitionDamage;
var config int CollateralDemolitionRadius;

static function array<X2DataTemplate> CreateTemplates()
{
	// This turns out to be a good hook for doing global template modification because subclasses of X2AmbientNarrativeCriteria
	// are the last ones loaded when the game is setting up. We'll just return an empty list of templates for template creation
	// (because we're not actually using this to create any templates) and put our template modifications in-between
	local array<X2DataTemplate> Templates;
	Templates.Length = 0;

	// Any template edits go here
	UpdateDemolitionTemplate();

	return Templates;
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

		`LOG("Collateral Demolition: Updated " @ Template.DataName @ " template visualization function.");
	}
}