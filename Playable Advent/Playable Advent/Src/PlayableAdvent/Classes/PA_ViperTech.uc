class PA_ViperTech extends Object config(PlayableAdvent);

var config bool PROVING_ALIEN;
var config bool FREE_ALIEN;
var config bool SQUADDIE_ALIEN;
var config int CORPSE_COST;
var config int SUPPLY_COST;
var config int ELERIUM_COST;
var config int RESEARCH_TIME;
var config string AUTOMATIC_VOICE;

function X2TechTemplate CreateTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Supplies;
	local ArtifactCost Elerium;
	local ArtifactCost Artifacts;

	`log("davea debug viper-template-enter proving " @ PROVING_ALIEN @ " free " @ FREE_ALIEN @ " squaddie " @ SQUADDIE_ALIEN);
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'PA_ViperTechTemplate');
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.strImage = "img:///PlayViper.Tech_Viper";
	Template.SortingTier = 1;
	if (! FREE_ALIEN) { Template.Requirements.RequiredTechs.AddItem('AutopsyViper'); }
	Template.ResearchCompletedFn = ResearchCompleted;
	Template.ItemRewards.AddItem('Elerium');
	Template.PointsToComplete = FREE_ALIEN ? 0 : RESEARCH_TIME;
	if (! FREE_ALIEN) {
		Supplies.ItemTemplateName = 'Supplies';
		Supplies.Quantity = SUPPLY_COST;
		if (SUPPLY_COST > 0) Template.Cost.ResourceCosts.AddItem(Supplies);
		Elerium.ItemTemplateName = 'EleriumDust';
		Elerium.Quantity = ELERIUM_COST;
		if (ELERIUM_COST > 0) Template.Cost.ResourceCosts.AddItem(Elerium);
		Artifacts.ItemTemplateName = 'CorpseViper';
		Artifacts.Quantity = CORPSE_COST;
		if (CORPSE_COST > 0) Template.Cost.ArtifactCosts.AddItem(Artifacts);
	}
	return Template;
}

function ResearchCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local X2CharacterTemplateManager CharTemplateManager;
	local X2CharacterTemplate CharTemplate;
	local XGCharacterGenerator CharGen;
	local string strFirst, strLast;
	local int maxRank;
	local array<X2WeaponTemplate> BestTemplates;
	local XComGameState_Item Grenade;

	History = `XCOMHISTORY;
	`log("davea debug viper-research-enter");
	CharTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	// Generate unit
	CharTemplate = CharTemplateManager.FindCharacterTemplate('PA_Viper');
	UnitState = CharTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(UnitState);
	// Give best human primary weapon and grenade
	BestTemplates = UnitState.GetBestPrimaryWeaponTemplates();
 	UnitState.UpgradeEquipment(NewGameState, none, BestTemplates, eInvSlot_PrimaryWeapon);
	Grenade = UnitState.GetBestGrenade(NewGameState);
	UnitState.AddItemToInventory(Grenade, eInvSlot_GrenadePocket, NewGameState);
	// Give tongue weapon
	ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_ViperTongue');
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_SecondaryWeapon, NewGameState);
	NewGameState.AddStateObject(ItemState);
	if (XComHQ.GetNumItemInInventory('PA_ViperTongue') == 0)
		XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	// Give poison spit weapon, uses hidden inventory slot
	ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_PoisonSpitGlob');
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_Unknown, NewGameState);
	NewGameState.AddStateObject(ItemState);	
	// Give armor
	ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_ViperArmor');
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_Armor, NewGameState);
	NewGameState.AddStateObject(ItemState);	
	if (XComHQ.GetNumItemInInventory('PA_ViperArmor') == 0)
		XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	// Generate name from viper country
	CharGen = `XCOMGAME.spawn( class 'XGCharacterGenerator' );
	CharGen.GenerateName(0, 'Country_Viper', strFirst, strLast);
	UnitState.SetCharacterName(strFirst, strLast, "");
	`log("davea debug set-viper-name " @ strFirst @ " " @ strLast);
	UnitState.SetCountry('Country_Viper');
	// Set to viper class
	NewGameState.AddStateObject(UnitState);
	UnitState.SetSkillLevel(7);
	UnitState.SetSoldierClassTemplate('ViperClass');
	// Set as squaddie, or advance to one less than highest soldier
	maxRank = SQUADDIE_ALIEN ? 1 : (class'PA_Characters'.static.HighestSoldierRank() - 1);
	if (maxRank == 0) maxRank = 1;
	class'PA_Characters'.static.RankUpAlien(maxRank, UnitState, NewGameState);
	// Set appearance
	UnitState.kAppearance.iGender = 2; // female
	UnitState.kAppearance.iAttitude = 0; // Personality MUST be zero for animations
	UnitState.kAppearance.nmTorso = 'PA_ARMOR_Viper_M1A';
	UnitState.kAppearance.iArmorTint = 25; 
	UnitState.kAppearance.iArmorTintSecondary = 0;
	UnitState.kAppearance.nmVoice = 'FemaleVoice1_Silent';
	class'PA_Characters'.static.SetAlienVoice(AUTOMATIC_VOICE, UnitState);
	UnitState.StoreAppearance();
	// Add to crew
	XComHQ.AddToCrew(NewGameState, UnitState);
	UnitState.SetHQLocation(eSoldierLoc_Barracks);
	XcomHQ.HandlePowerOrStaffingChange(NewGameState);
	`log("davea debug viper-research-return");
}
