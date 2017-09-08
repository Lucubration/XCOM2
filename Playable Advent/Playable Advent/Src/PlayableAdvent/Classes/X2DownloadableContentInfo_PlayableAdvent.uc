class X2DownloadableContentInfo_PlayableAdvent extends X2DownloadableContentInfo;

static event OnLoadedSavedGame()
{
	doAllInit(none);
}

static event InstallNewCampaign(XComGameState StartState)
{
	doAllInit(StartState);
}

static function doAllInit(XComGameState stateGame)
{
	local X2StrategyElementTemplateManager stratMan;
	local PA_MecTech classMec;
	local PA_ViperTech classViper;
	local PA_ChrysTech classChrys;
	local PA_MutonTech classMuton;
	local PA_BerserkerTech classBerserker;
	local X2TechTemplate techMec, techViper, techChrys, techMuton, techBerserker;
	local XComGameState_Tech stateTech;
	local XComGameStateHistory History;
	local bool fromLoad, alreadyExists;
	fromLoad = (stateGame == none);

	`log ("davea debug ar start allinit fromLoad " @ fromLoad);

	// Set up tech templates
	// CaveRat says this is not needed
	classMec = new class'PA_MecTech';
	classViper = new class'PA_ViperTech';
	classChrys = new class'PA_ChrysTech';
	classMuton = new class'PA_MutonTech';
	classBerserker = new class 'PA_BerserkerTech';
	techMec = classMec.CreateTemplate();
	techViper = classViper.CreateTemplate();
	techChrys = classChrys.CreateTemplate();
	techMuton = classMuton.CreateTemplate();
	techBerserker = classBerserker.CreateTemplate();
	stratMan = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	stratMan.AddStrategyElementTemplate(techMec, true);
	stratMan.AddStrategyElementTemplate(techViper, true);
	stratMan.AddStrategyElementTemplate(techChrys, true);
	stratMan.AddStrategyElementTemplate(techMuton, true);
	stratMan.AddStrategyElementTemplate(techBerserker, true);

	// Even when loading a game where the mod was already active, OnLoadedSaveGame
	// is called (apparently a bug).  So check if the history objects are already there.
	alreadyExists = false;
	if (fromLoad) {
		History = `XCOMHISTORY;
		foreach History.IterateByClassType(class'XComGameState_Tech', stateTech)
		{
			if (stateTech.GetMyTemplateName() == 'PA_MecTechTemplate')
			{
				alreadyExists = true;
				break;
			}
		}
		`log ("davea debug ar mid alreadyExists " @ alreadyExists);
	}

	// Add objects if needed
	if (! alreadyExists) {
		`log ("davea debug ar adding classes and history");
		if (fromLoad) { stateGame = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("PA_tech_init"); }
		stateTech = XComGameState_Tech(stateGame.CreateStateObject(class'XComGameState_Tech'));
		stateTech.OnCreation(techMec);
		stateGame.AddStateObject(stateTech);
		stateTech = XComGameState_Tech(stateGame.CreateStateObject(class'XComGameState_Tech'));
		stateTech.OnCreation(techViper);
		stateGame.AddStateObject(stateTech);
		stateTech = XComGameState_Tech(stateGame.CreateStateObject(class'XComGameState_Tech'));
		stateTech.OnCreation(techChrys);
		stateGame.AddStateObject(stateTech);
		 stateTech = XComGameState_Tech(stateGame.CreateStateObject(class'XComGameState_Tech'));
		stateTech.OnCreation(techBerserker);
		stateGame.AddStateObject(stateTech);
		stateTech = XComGameState_Tech(stateGame.CreateStateObject(class'XComGameState_Tech'));
		stateTech.OnCreation(techMuton);
		stateGame.AddStateObject(stateTech);
		if (fromLoad) { `XCOMHISTORY.AddGameStateToHistory(stateGame); }
	}

	`log ("davea debug ar finish allinit");
}
