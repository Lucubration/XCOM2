class PA_ChrysTech extends Object config(PlayableAdvent);

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

	`log("davea debug chrys-template-enter proving " @ PROVING_ALIEN @ " free " @ FREE_ALIEN @ " squaddie " @ SQUADDIE_ALIEN);
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'PA_ChrysTechTemplate');
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.strImage = "img:///PlayLid.Tech_Chryssalid";
	Template.SortingTier = 1;
	if (! FREE_ALIEN) { Template.Requirements.RequiredTechs.AddItem('AutopsyChryssalid'); }
	Template.ResearchCompletedFn = ResearchCompleted;
	Template.PointsToComplete = FREE_ALIEN ? 0 : RESEARCH_TIME;
	if (! FREE_ALIEN) {
		Supplies.ItemTemplateName = 'Supplies';
		Supplies.Quantity = SUPPLY_COST;
		if (SUPPLY_COST > 0) Template.Cost.ResourceCosts.AddItem(Supplies);
		Elerium.ItemTemplateName = 'EleriumDust';
		Elerium.Quantity = ELERIUM_COST;
		if (ELERIUM_COST > 0) Template.Cost.ResourceCosts.AddItem(Elerium);
		Artifacts.ItemTemplateName = 'CorpseChryssalid';
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
	local X2CharacterTemplateManager CharTemplateManager;
	local X2CharacterTemplate CharTemplate;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item ItemState;
	local XGCharacterGenerator CharGen;
	local string strFirst, strLast;
	local int maxRank;

	`log("davea debug chrys-research-enter");
	History = `XCOMHISTORY;
	CharTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	// Generate unit
	CharTemplate = CharTemplateManager.FindCharacterTemplate('PA_Chrys');
	UnitState = CharTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(UnitState);
	// Give armor
	ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_ChrysArmor');
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_Armor, NewGameState);
	NewGameState.AddStateObject(ItemState);
	if (XComHQ.GetNumItemInInventory('PA_ChrysArmor') == 0)
		XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	// Generate name from Chryssalid country
	CharGen = `XCOMGAME.spawn( class 'XGCharacterGenerator' );
	CharGen.GenerateName(0, 'Country_Chrys', strFirst, strLast);
	UnitState.SetCharacterName(strFirst, strLast, "");
	`log("davea debug set-chrys-name " @ strFirst @ " " @ strLast);
	UnitState.SetCountry('Country_Chrys');
	// Set to Chrys class
	NewGameState.AddStateObject(UnitState);
	UnitState.SetSkillLevel(7);
	UnitState.SetSoldierClassTemplate('ChrysClass');
	// Set as squaddie, or advance to one less than highest soldier
	maxRank = SQUADDIE_ALIEN ? 1 : (class'PA_Characters'.static.HighestSoldierRank() - 1);
	if (maxRank == 0) maxRank = 1;
	class'PA_Characters'.static.RankUpAlien(maxRank, UnitState, NewGameState);
	// Set appearance
	UnitState.kAppearance.iGender = 1; // male
	UnitState.kAppearance.iAttitude = 0; // Personality MUST be zero for animations
	UnitState.kAppearance.iArmorTint = 75;
	UnitState.kAppearance.iArmorTintSecondary = 5;
	UnitState.kAppearance.nmTorso = 'PA_ARMOR_Lid_M1A'; // Set armor style
	UnitState.kAppearance.nmVoice = 'MaleVoice1_Silent';
	class'PA_Characters'.static.SetAlienVoice(AUTOMATIC_VOICE, UnitState);
	UnitState.StoreAppearance();
	// Add to crew
	XComHQ.AddToCrew(NewGameState, UnitState);
	UnitState.SetHQLocation(eSoldierLoc_Barracks);
	XcomHQ.HandlePowerOrStaffingChange(NewGameState);
	`log("davea debug chrys-research-return");
}
