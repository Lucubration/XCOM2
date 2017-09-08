// reference:
// http://forums.nexusmods.com/index.php?/topic/3839560-template-modification-without-screenlisteners/

class PA_X2AmbientNarrativeCriteria extends X2AmbientNarrativeCriteria;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local XComGameStateHistory History;
	local XComGameStateContext_StrategyGameRule StrategyStartContext;
	local XComGameState StartState;
	local XComGameState_CampaignSettings Settings;
	local X2AbilityTemplateManager Abilities;
	local X2AbilityTemplate AbilityTemplate;
	local int DifficultyIndex;

	// Setup to access template managers
	`log("davea debug ambient narrative enter");
	History = `XCOMHISTORY;
	StrategyStartContext = XComGameStateContext_StrategyGameRule(class'XComGameStateContext_StrategyGameRule'.static.CreateXComGameStateContext());
	StrategyStartContext.GameRuleType = eStrategyGameRule_StrategyGameStart;
	StartState = History.CreateNewGameState(false, StrategyStartContext);
	History.AddGameStateToHistory(StartState);
	Settings = new class'XComGameState_CampaignSettings';
	StartState.AddStateObject(Settings);

	// Print information about council ops and rewards
	// local X2StrategyElementTemplateManager StratElemMgr;
	// local array<X2StrategyElementTemplate> StratTpls;
	// local X2MissionSourceTemplate SourceTpl;
	// local int tplLen, deckLen, i, j;
	// DifficultyIndex = `MIN_DIFFICULTY_INDEX;
	// Settings.SetDifficulty(DifficultyIndex);
	// StratElemMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	// StratTpls = StratElemMgr.GetAllTemplatesOfClass(class'X2MissionSourceTemplate');
	// tplLen = StratTpls.Length;
	// `log ("davea debug ambient setm tplLength " @ tplLen);
	// for (i=0; i<tplLen; i++) {
	// 	SourceTpl = X2MissionSourceTemplate(StratTpls[i]);
	// 	deckLen = SourceTpl.RewardDeck.Length;
	// 	`log ("davea debug ambient set " @ SourceTpl.DataName @ " reward len " @ deckLen);
	// 	for (j=0; j<deckLen; j++) {
	// 		`log ("davea debug ambient    name " @ SourceTpl.RewardDeck[j].RewardName @ " quantity " @ SourceTpl.RewardDeck[j].Quantity);
	// 	}
	// }

	// Make chryssalid burrow and unburrow neutral instead of hostile
	// Cannot copy/paste my own templates due to use of local functions
	Abilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	for( DifficultyIndex = `MIN_DIFFICULTY_INDEX; DifficultyIndex <= `MAX_DIFFICULTY_INDEX; ++DifficultyIndex )
	{
		`log ("davea debug changing burrow for difficulty: " @ string(class'XComGameState_CampaignSettings'.static.GetDifficultyFromSettings()));
		Settings.SetDifficulty(DifficultyIndex);
		AbilityTemplate = Abilities.FindAbilityTemplate('ChryssalidBurrow');
		AbilityTemplate.Hostility = eHostility_Neutral;
		AbilityTemplate = Abilities.FindAbilityTemplate('ChryssalidUnburrow');
		AbilityTemplate.Hostility = eHostility_Neutral;
	}

	// Remove the history; this doesn't need to persist
	History.ResetHistory();
	`log ("davea debug ambient narrative done");
	return Templates;
}
