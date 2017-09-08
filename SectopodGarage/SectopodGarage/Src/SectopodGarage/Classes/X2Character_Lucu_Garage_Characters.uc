class X2Character_Lucu_Garage_Characters extends X2Character;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Xtopod());
	
	return Templates;
}

static function X2CharacterTemplate Xtopod()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'Lucu_Garage_Xtopod');
	CharTemplate.CharacterGroupName = 'Xtopod';
	CharTemplate.DefaultLoadout='Squaddie_Lucu_Garage_Xtopod';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_SectopodMini.ARC_GameUnit_SectopodMini");

	CharTemplate.strMatineePackages.AddItem("CIN_Sectopod");
	CharTemplate.strTargetingMatineePrefix = "CIN_Sectopod_FF_StartPos";

	CharTemplate.UnitSize = 1;
	CharTemplate.UnitHeight = 2;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = true;

	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeCarried = false;	
	CharTemplate.bCanBeRevived = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.Abilities.AddItem('RobotImmunities');

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('Lucu_Garage_DefaultPower');
	CharTemplate.Abilities.AddItem('Lucu_Garage_HighStance');
	CharTemplate.Abilities.AddItem('Lucu_Garage_LowStance');
	CharTemplate.Abilities.AddItem('Loot');
	CharTemplate.Abilities.AddItem('Interact_PlantBomb');
	CharTemplate.Abilities.AddItem('Interact_TakeVial');
	CharTemplate.Abilities.AddItem('Interact_StasisTube');
	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('CarryUnit');
	CharTemplate.Abilities.AddItem('PutDownUnit');
	CharTemplate.Abilities.AddItem('Hack');
	CharTemplate.Abilities.AddItem('Hack_Chest');
	CharTemplate.Abilities.AddItem('Hack_Workstation');
	CharTemplate.Abilities.AddItem('Hack_ObjectiveChest');
	CharTemplate.Abilities.AddItem('PlaceEvacZone');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}
