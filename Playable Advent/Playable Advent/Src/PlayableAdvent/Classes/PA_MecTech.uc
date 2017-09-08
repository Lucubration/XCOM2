class PA_MecTech extends Object config(PlayableAdvent);

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

	`log("davea debug mec-template-enter proving " @ PROVING_ALIEN @ " free " @ FREE_ALIEN @ " squaddie " @ SQUADDIE_ALIEN);
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'PA_MecTechTemplate');
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.strImage = "img:///PlayMEC.Tech_MEC";
	Template.SortingTier = 1;
	if (! FREE_ALIEN) { Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC'); }
	Template.ResearchCompletedFn = ResearchCompleted;
	Template.PointsToComplete = FREE_ALIEN ? 0 : RESEARCH_TIME;
	if (! FREE_ALIEN) {
		Supplies.ItemTemplateName = 'Supplies';
		Supplies.Quantity = SUPPLY_COST;
		if (SUPPLY_COST > 0) Template.Cost.ResourceCosts.AddItem(Supplies);
		Elerium.ItemTemplateName = 'EleriumDust';
		Elerium.Quantity = ELERIUM_COST;
		if (ELERIUM_COST > 0) Template.Cost.ResourceCosts.AddItem(Elerium);
		Artifacts.ItemTemplateName = 'CorpseAdventMEC';
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
	local name GunName, MissileName;
	local int maxRank;

	History = `XCOMHISTORY;
	`log("davea debug mec-research-enter");
	CharTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	// Generate unit
	CharTemplate = CharTemplateManager.FindCharacterTemplate('PA_Mec');
	UnitState = CharTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(UnitState);
	// Define one or both guns, one or both missiles
	GunName = 'PA_MecGun';
	ItemTemplate = ItemTemplateManager.FindItemTemplate(GunName);
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(ItemState);
	if (XComHQ.GetNumItemInInventory(GunName) == 0)
		XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	MissileName = 'PA_MecMissile';
	ItemTemplate = ItemTemplateManager.FindItemTemplate(MissileName);
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(ItemState);
	if (XComHQ.GetNumItemInInventory(MissileName) == 0)
		XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	if (XComHq.IsTechResearched('GaussWeapons')) {
		GunName = 'PA_MecGunBeam';
		ItemTemplate = ItemTemplateManager.FindItemTemplate(GunName);
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(ItemState);
		if (XComHQ.GetNumItemInInventory(GunName) == 0)
			XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	}
	if (XComHq.IsTechResearched('PlasmaRifle')) {
		MissileName = 'PA_MecMissilePlasma';
		ItemTemplate = ItemTemplateManager.FindItemTemplate(MissileName);
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(ItemState);
		if (XComHQ.GetNumItemInInventory(MissileName) == 0)
			XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	}
	// Give gun and missile
	`log("davea debug mec adding secweap " @ MissileName);
	ItemTemplate = ItemTemplateManager.FindItemTemplate(MissileName);
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_SecondaryWeapon, NewGameState);
	NewGameState.AddStateObject(ItemState);
	ItemTemplate = ItemTemplateManager.FindItemTemplate(GunName);
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_PrimaryWeapon, NewGameState);
	NewGameState.AddStateObject(ItemState);
	// Give armor
	ItemTemplate = ItemTemplateManager.FindItemTemplate('PA_MecArmor');
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	UnitState.AddItemToInventory(ItemState, eInvSlot_Armor, NewGameState);
	NewGameState.AddStateObject(ItemState);
	if (XComHQ.GetNumItemInInventory('PA_MecArmor') == 0)
		XComHQ.AddItemToHQInventory(ItemState); // show in armory locker list
	// Generate name from MEC country
	CharGen = `XCOMGAME.spawn( class 'XGCharacterGenerator' );
	CharGen.GenerateName(0, 'Country_Mec', strFirst, strLast);
	UnitState.SetCharacterName(strFirst, strLast, "");
	`log("davea debug set-mec-name " @ strFirst @ " " @ strLast);
	UnitState.SetCountry('Country_Mec');
	// Set to MEC class
	NewGameState.AddStateObject(UnitState);
	UnitState.SetSkillLevel(7);
	UnitState.SetSoldierClassTemplate('MecClass');
	// Set as squaddie, or advance to one less than highest soldier
	maxRank = SQUADDIE_ALIEN ? 1 : (class'PA_Characters'.static.HighestSoldierRank() - 1);
	if (maxRank == 0) maxRank = 1;
	class'PA_Characters'.static.RankUpAlien(maxRank, UnitState, NewGameState);
	// Set appearance
	UnitState.kAppearance.iGender = 1; // male
	UnitState.kAppearance.iAttitude = 0; // Personality MUST be zero for animations
	UnitState.kAppearance.iArmorTint = 0;
	UnitState.kAppearance.iArmorTintSecondary = 50;
	UnitState.kAppearance.nmTorso = 'PA_ARMOR_MEC_M1A';
	UnitState.kAppearance.nmVoice = 'MaleVoice1_Silent';
	class'PA_Characters'.static.SetAlienVoice(AUTOMATIC_VOICE, UnitState);
	UnitState.StoreAppearance();
	// Add to crew
	XComHQ.AddToCrew(NewGameState, UnitState);
	UnitState.SetHQLocation(eSoldierLoc_Barracks);
	XcomHQ.HandlePowerOrStaffingChange(NewGameState);
	`log("davea debug mec-research-return");
}
