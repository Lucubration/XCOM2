class PA_BerserkerTech extends Object config(PlayableAdvent);

var config bool PROVING_ALIEN;
var config bool FREE_ALIEN;
var config bool SQUADDIE_ALIEN;
var config int CORPSE_COST;
var config int SUPPLY_COST;
var config int ELERIUM_COST;
var config int RESEARCH_TIME;

function X2TechTemplate CreateTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Supplies;
	local ArtifactCost Elerium;
	local ArtifactCost Artifacts;

	`log("davea debug berserker-template-enter proving " @ PROVING_ALIEN @ " free " @ FREE_ALIEN @ " squaddie " @ SQUADDIE_ALIEN);
	if (! PROVING_ALIEN)
		return Template; // not enabled
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'PA_BerserkerTechTemplate');
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.strImage = "img:///UILibrary_StrategyImages.CorpseIcons.Corpse_Berserker";
	Template.SortingTier = 1;
	if (! FREE_ALIEN) { Template.Requirements.RequiredTechs.AddItem('AutopsyBerserker'); }
	Template.ResearchCompletedFn = ResearchCompleted;
	Template.PointsToComplete = FREE_ALIEN ? 0 : RESEARCH_TIME;
	if (! FREE_ALIEN) {
		Supplies.ItemTemplateName = 'Supplies';
		Supplies.Quantity = SUPPLY_COST;
		if (SUPPLY_COST > 0) Template.Cost.ResourceCosts.AddItem(Supplies);
		Elerium.ItemTemplateName = 'EleriumDust';
		Elerium.Quantity = ELERIUM_COST;
		if (ELERIUM_COST > 0) Template.Cost.ResourceCosts.AddItem(Elerium);
		Artifacts.ItemTemplateName = 'CorpseBerserker';
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

	`log("davea debug berserker-research-enter");
	History = `XCOMHISTORY;
	CharTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	// Generate unit
	CharTemplate = CharTemplateManager.FindCharacterTemplate('PA_Berserker');
	UnitState = CharTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(UnitState);
	// Give armor
	ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_BerserkerArmor');
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_Armor, NewGameState);
	NewGameState.AddStateObject(ItemState);	
	if (XComHQ.GetNumItemInInventory('PA_BerserkerArmor') == 0)
		XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	// Generate name from Muton country
	CharGen = `XCOMGAME.spawn( class 'XGCharacterGenerator' );
	CharGen.GenerateName(0, 'Country_Muton', strFirst, strLast);
	UnitState.SetCharacterName(strFirst, strLast, "");
	`log("davea debug set-muton-name " @ strFirst @ " " @ strLast);
	UnitState.SetCountry('Country_Muton');
	// Set to Berserker class
	NewGameState.AddStateObject(UnitState);
	UnitState.SetSkillLevel(7);
	UnitState.SetSoldierClassTemplate('BerserkerClass');
	// Set as squaddie, or advance to one less than highest soldier
	maxRank = SQUADDIE_ALIEN ? 1 : (class'PA_Characters'.static.HighestSoldierRank() - 1);
	if (maxRank == 0) maxRank = 1;
	class'PA_Characters'.static.RankUpAlien(maxRank, UnitState, NewGameState);
	// Set gender and store
	UnitState.kAppearance.iGender = 1; // male
	UnitState.StoreAppearance();
	// Add to crew
	XComHQ.AddToCrew(NewGameState, UnitState);
	UnitState.SetHQLocation(eSoldierLoc_Barracks);
	XcomHQ.HandlePowerOrStaffingChange(NewGameState);
	`log("davea debug berserker-research-return");
}
