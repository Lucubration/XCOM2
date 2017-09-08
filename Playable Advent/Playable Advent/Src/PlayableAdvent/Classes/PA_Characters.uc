class PA_Characters extends X2Character config(GameData_CharacterStats);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(CreateTemplate_Chrys());
	Templates.AddItem(CreateTemplate_Mec());
	Templates.AddItem(CreateTemplate_Muton());
	Templates.AddItem(CreateTemplate_Viper());
	Templates.AddItem(CreateTemplate_Berserker());
	return Templates;
}

static function int HighestSoldierRank()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local int idx, maxRank, thisRank;

	maxRank = 0;
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	for(idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
		thisRank = UnitState.GetRank();
		if (thisRank > maxRank) maxRank = thisRank;
	}
	return maxRank;
}

// LevelUpBarracks is wrong, taken from here instead:
// X2StrategyElement_DefaultRewards::GeneratePersonnelReward
static function RankUpAlien(int maxRank, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local int i, j;
	local X2SoldierClassTemplate SoldierTemplate;
	local name AbilityName;

	`log ("davea debug rankup " @ maxRank @ " for " @ UnitState.GetLastName());
	SoldierTemplate = UnitState.GetSoldierClassTemplate();
	UnitState.SetXPForRank(maxRank);
	UnitState.StartingRank = maxRank;
	for (i=0; i<maxRank; i++)
	{
		if (i == 0)
		{
			// Rank up to squaddie
			`log ("davea debug squaddie rankup start");
			UnitState.RankUpSoldier(NewGameState, SoldierTemplate.DataName);
			UnitState.ApplySquaddieLoadout(NewGameState);
			for (j=0; j<SoldierTemplate.GetAbilityTree(0).Length; ++j)
			{
				AbilityName = SoldierTemplate.GetAbilityName(0, j);
				`log ("davea debug squaddie rankup " @ j @ " ability " @ AbilityName);
				UnitState.BuySoldierProgressionAbility(NewGameState, 0, j);
			}
		}
		else
		{
			`log ("davea debug advanced rankup");
			UnitState.RankUpSoldier(NewGameState, UnitState.GetSoldierClassTemplate().DataName);
		}
	}
	`log ("davea debug rankup finished");
}

static function SetAlienVoice(string GoalVoice, XComGameState_Unit UnitState)
{
	local X2BodyPartTemplateManager PartTemplateManager;
	local array<X2BodyPartTemplate> AllVoiceTemplates;
	local X2BodyPartTemplate VoiceTemplate;
	local string VoiceName;
	local int posn;

	if (GoalVoice != "") {
		`log("davea debug auto-voice " @ GoalVoice);
		PartTemplateManager = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();
		PartTemplateManager.GetUberTemplates("Voice", AllVoiceTemplates);
		foreach AllVoiceTemplates(VoiceTemplate) {
			VoiceName = VoiceTemplate.ArchetypeName;
			// Find if the ini value is a substring of the name, any case
			posn = InStr(Caps(VoiceName), Caps(GoalVoice));
			`log ("davea debug voice avail " @ posn @ " name " @ VoiceName);
			if (posn != -1) {
				`log("davea debug voice-set " @ VoiceName);
				UnitState.SetVoice(name(GoalVoice));
			}
		}
	}
}

static function X2CharacterTemplate CreateTemplate_Chrys()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PA_Chrys');
	CharTemplate.CharacterGroupName = 'Chrys';
	CharTemplate.DefaultLoadout='PA_ChrysLoadout';
	CharTemplate.RequiredLoadout = 'PA_ChrysLoadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("PlayLid.ARC_Chryssalid_Base");
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.strMatineePackages.AddItem("CIN_Chryssalid");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true; // required for customization screen
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeCarried = false;	
	CharTemplate.bCanBeRevived = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('ChryssalidSlash');
	CharTemplate.Abilities.AddItem('ChryssalidBurrow');
	CharTemplate.Abilities.AddItem('ChyssalidPoison');
	CharTemplate.Abilities.AddItem('ChryssalidImmunities');

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('LiftOffAvenger');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Mec()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PA_Mec');
	CharTemplate.CharacterGroupName = 'AdventMEC';
	CharTemplate.DefaultLoadout='PA_Mec_Loadout';
	CharTemplate.RequiredLoadout = 'PA_Mec_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("PlayMEC.ARC_MEC_Base");
	CharTemplate.bAppearanceDefinesPawn = true;    
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true; // required for customization screen
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

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Muton()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PA_Muton');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonLoadout';
	CharTemplate.RequiredLoadout = 'MutonLoadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Muton.ARC_GameUnit_Muton");
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";
	
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true; // required for customization screen 
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;

	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeCarried = true;	
	CharTemplate.bCanBeRevived = true;
	CharTemplate.bIsAfraidOfFire = true;

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

static function X2CharacterTemplate CreateTemplate_Viper()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PA_Viper');
	CharTemplate.CharacterGroupName = 'Viper';
	CharTemplate.DefaultLoadout='PA_ViperLoadout';
	CharTemplate.RequiredLoadout = 'PA_ViperLoadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("PlayViper.ARC_Viper_Base");
	CharTemplate.bAppearanceDefinesPawn = true;    
	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strTargetingMatineePrefix = "CIN_Viper_FF_StartPos";
	
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true; // required for customization screen 
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;

	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeCarried = true;	
	CharTemplate.bCanBeRevived = true;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.Abilities.AddItem('Bind');

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

static function X2CharacterTemplate CreateTemplate_Berserker()
{
	local X2CharacterTemplate CharTemplate;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'PA_Berserker');
	CharTemplate.CharacterGroupName = 'Berserker';
	CharTemplate.DefaultLoadout='PA_Berserker_Loadout';
	CharTemplate.RequiredLoadout = 'PA_Berserker_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Berserker.ARC_GameUnit_Berserker");
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.strMatineePackages.AddItem("CIN_Berserker");
	CharTemplate.strTargetingMatineePrefix = "CIN_Berserker_FF_StartPos";

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = true;
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true; // required for customization screen
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;

	CharTemplate.bCanBeCriticallyWounded = true;
	CharTemplate.bCanBeCarried = true;	
	CharTemplate.bCanBeRevived = true;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.Abilities.AddItem('DevastatingBlow');
	CharTemplate.Abilities.AddItem('DevastatingBlowWhileMoving');

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
