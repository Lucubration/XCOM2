//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_XpackResistanceActions.uc
//  AUTHOR:  Mark Nauta  --  09/21/2016
//  PURPOSE: Create templates for resistance actions for the player to choose from in
//			 the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_XpackResistanceActions extends X2StrategyElement config(GameData);

// Reaper card config vars
var config array<int>			PopularSupportIBonus;
var config array<int>			PopularSupportIIBonus;
var config array<int>			RecruitingCentersCost;
var config array<int>			BallisticsModelingBonus;
var config array<int>			HeavyEquipmentBonus;

// Skirmisher card config vars
var config array<int>			InsideJobIBonus;
var config array<int>			InsideJobIIBonus;
var config array<int>			UnderTheTableIBonus;
var config array<int>			UnderTheTableIIBonus;
var config array<int>			QuidProQuoBonus;
var config array<int>			DecoysAndDeceptionsReduction;
var config array<int>			WeakPointsShred;
var config array<int>			ImpactModelingBonus;
var config array<int>			ModularConstructionBonus;
var config array<int>			InformationWarReduction;
var config array<int>			PrivateChannelTurns;

// Templar card config vars
var config array<int>			NobleCauseBonus;
var config array<int>			DeeperLearningIBonus;
var config array<int>			DeeperLearningIIBonus;
var config array<int>			ArtOfWarBonus;
var config array<int>			BondsOfWarBonus;
var config array<int>			TitheBonus;
var config array<int>			PursuitOfKnowledgeBonus;
var config array<int>			HiddenReservesIBonus;
var config array<int>			HiddenReservesIIBonus;

var config name					VolunteerArmyCharacterTemplate;
var config name					VolunteerArmyCharacterTemplateM2;
var config name					VolunteerArmyCharacterTemplateM3;
var config int					VolunteerArmyChance;

struct DoubleAgentData
{
	var name TemplateName;
	var int MinForceLevel;
	var int MaxForceLevel;
};

var config array<DoubleAgentData>	DoubleAgentCharacterTemplates;
var config int						DoubleAgentChance;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Cards;

	// REAPER CARDS
	Cards.AddItem(CreateLightningStrikeTemplate());
	Cards.AddItem(CreateRunSilentRunDeepTemplate());
	Cards.AddItem(CreatePopularSupportITemplate());
	Cards.AddItem(CreatePopularSupportIITemplate());
	Cards.AddItem(CreateRecruitingCentersTemplate());
	Cards.AddItem(CreateMunitionsExpertsTemplate());
	Cards.AddItem(CreateScavengersTemplate());
	Cards.AddItem(CreateLiveFireTrainingTemplate());
	Cards.AddItem(CreateGuardianAngelsTemplate());
	Cards.AddItem(CreateResistanceRisingITemplate());
	Cards.AddItem(CreateResistanceRisingIITemplate());
	Cards.AddItem(CreateVolunteerArmyTemplate());
	Cards.AddItem(CreateRapidCollectionTemplate());
	Cards.AddItem(CreateBetweenTheEyesTemplate());
	Cards.AddItem(CreateBallisticsModelingTemplate());
	Cards.AddItem(CreateHeavyEquipmentTemplate());
	Cards.AddItem(CreateResistanceNetworkTemplate());

	// SKIRMISHER CARDS
	Cards.AddItem(CreateVultureTemplate());
	Cards.AddItem(CreateInsideJobITemplate());
	Cards.AddItem(CreateInsideJobIITemplate());
	Cards.AddItem(CreateUnderTheTableITemplate());
	Cards.AddItem(CreateUnderTheTableIITemplate());
	Cards.AddItem(CreateQuidProQuoTemplate());
	Cards.AddItem(CreateBombSquadTemplate());
	Cards.AddItem(CreateSabotageTemplate());
	Cards.AddItem(CreateDecoysAndDeceptionsTemplate());
	Cards.AddItem(CreatePrivateChannelTemplate());
	Cards.AddItem(CreateIntegratedWarfareTemplate());
	Cards.AddItem(CreateWeakPointsTemplate());
	Cards.AddItem(CreateInsideKnowledgeTemplate());
	Cards.AddItem(CreateDoubleAgentTemplate());
	Cards.AddItem(CreateImpactModelingTemplate());
	Cards.AddItem(CreateModularConstructionTemplate());
	Cards.AddItem(CreateInformationWarTemplate());
	Cards.AddItem(CreateTacticalAnalysisTemplate());

	// TEMPLAR CARDS
	Cards.AddItem(CreateNobleCauseTemplate());
	Cards.AddItem(CreateSuitUpTemplate());
	Cards.AddItem(CreateTrialByFireTemplate());
	Cards.AddItem(CreateDeeperLearningITemplate());
	Cards.AddItem(CreateDeeperLearningIITemplate());
	Cards.AddItem(CreateVengeanceTemplate());
	Cards.AddItem(CreateStayWithMeTemplate());
	Cards.AddItem(CreateArtOfWarTemplate());
	Cards.AddItem(CreateBondsOfWarTemplate());
	Cards.AddItem(CreateTitheTemplate());
	Cards.AddItem(CreateGreaterResolveTemplate());
	Cards.AddItem(CreateMentalFortitudeTemplate());
	Cards.AddItem(CreateFeedbackTemplate());
	Cards.AddItem(CreatePursuitOfKnowledgeTemplate());
	Cards.AddItem(CreateHiddenReservesITemplate());
	Cards.AddItem(CreateHiddenReservesIITemplate());
	Cards.AddItem(CreateMachineLearningTemplate());

	return Cards;
}

//#############################################################################################
//----------------   REAPER CARDS  ------------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateLightningStrikeTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_LightningStrike');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateLightningStrike;
	Template.OnDeactivatedFn = DeactivateLightningStrike;
	Template.GetSummaryTextFn = GetLightningStrikeSummaryText;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateLightningStrike(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	AddSoldierUnlock(NewGameState, 'LightningStrikeUnlock');
}
//---------------------------------------------------------------------------------------
static function DeactivateLightningStrike(XComGameState NewGameState, StateObjectReference InRef)
{
	RemoveSoldierUnlock(NewGameState, 'LightningStrikeUnlock');
}
//---------------------------------------------------------------------------------------
static function string GetLightningStrikeSummaryText(StateObjectReference InRef)
{
	local XComGameState_StrategyCard CardState;
	local X2StrategyCardTemplate CardTemplate;

	CardState = GetCardState(InRef);

	if(CardState == none)
	{
		return "Error in GetSummaryText function";
	}

	CardTemplate = CardState.GetMyTemplate();

	return `XEXPAND.ExpandString(CardTemplate.SummaryText);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRunSilentRunDeepTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_RunSilentRunDeep');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = RunSilentRunDeepTacticalStartModifier;

	return Template;
}
//---------------------------------------------------------------------------------------
static function RunSilentRunDeepTacticalStartModifier( XComGameState StartState )
{
	local X2EventManager EventManager;
	local XComGameState_Player Player;
	local Object PlayerObject;

	EventManager = `XEVENTMGR;

	foreach StartState.IterateByClassType( class'XComGameState_Player', Player )
	{
		if (Player.GetTeam() == eTeam_XCom)
			break;
	}
	`assert( Player != none );

	PlayerObject = Player;

	EventManager.RegisterForEvent(PlayerObject, 'SquadConcealmentBroken', Player.RunSilentConcealmentChanged, ELD_OnStateSubmitted, , Player);
	EventManager.RegisterForEvent(PlayerObject, 'SquadConcealmentEntered', Player.RunSilentConcealmentChanged, ELD_OnStateSubmitted, , Player);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePopularSupportITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_PopularSupportI');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivatePopularSupportI;
	Template.OnDeactivatedFn = DeactivatePopularSupportI;
	Template.GetMutatorValueFn = GetValuePopularSupportI;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivatePopularSupportI(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;

	ResistanceHQ = GetNewResHQState(NewGameState);
	ResistanceHQ.SupplyDropPercentIncrease += GetValuePopularSupportI();
}
//---------------------------------------------------------------------------------------
static function DeactivatePopularSupportI(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;

	ResistanceHQ = GetNewResHQState(NewGameState);
	ResistanceHQ.SupplyDropPercentIncrease -= GetValuePopularSupportI();
}
//---------------------------------------------------------------------------------------
static function int GetValuePopularSupportI()
{
	return `ScaleStrategyArrayInt(default.PopularSupportIBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePopularSupportIITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_PopularSupportII');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivatePopularSupportII;
	Template.OnDeactivatedFn = DeactivatePopularSupportII;
	Template.GetMutatorValueFn = GetValuePopularSupportII;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivatePopularSupportII(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.SupplyDropPercentIncrease += GetValuePopularSupportII();
}
//---------------------------------------------------------------------------------------
static function DeactivatePopularSupportII(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.SupplyDropPercentIncrease -= GetValuePopularSupportII();
}
//---------------------------------------------------------------------------------------
static function int GetValuePopularSupportII()
{
	return `ScaleStrategyArrayInt(default.PopularSupportIIBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRecruitingCentersTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_RecruitingCenters');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateRecruitingCenters;
	Template.OnDeactivatedFn = DeactivateRecruitingCenters;
	Template.GetMutatorValueFn = GetValueRecruitingCenters;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateRecruitingCenters(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.RecruitCostModifier = (GetValueRecruitingCenters() - `ScaleStrategyArrayInt(ResHQ.RecruitSupplyCosts));
}
//---------------------------------------------------------------------------------------
static function DeactivateRecruitingCenters(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.RecruitCostModifier = 0;
}
//---------------------------------------------------------------------------------------
static function int GetValueRecruitingCenters()
{
	return `ScaleStrategyArrayInt(default.RecruitingCentersCost);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMunitionsExpertsTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_MunitionsExperts');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateMunitionsExperts;
	Template.OnDeactivatedFn = DeactivateMunitionsExperts;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateMunitionsExperts(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom ProvingGround;
	local XComGameState_Tech TechState;
	local XComGameState_HeadquartersProjectResearch ProvingGroundProject;
	local StateObjectReference ProjectRef;

	History = `XCOMHISTORY;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantRandomAmmo = true;

	// Check if there are any current ammo projects, and set it to complete immediately
	if(XComHQ.HasFacilityByName('ProvingGround'))
	{
		ProvingGround = XComHQ.GetFacilityByName('ProvingGround');
		foreach ProvingGround.BuildQueue(ProjectRef)
		{
			ProvingGroundProject = XComGameState_HeadquartersProjectProvingGround(History.GetGameStateForObjectID(ProjectRef.ObjectID));
			TechState = XComGameState_Tech(History.GetGameStateForObjectID(ProvingGroundProject.ProjectFocus.ObjectID));
			if(TechState.GetMyTemplate().bRandomAmmo)
			{
				ProvingGroundProject = XComGameState_HeadquartersProjectProvingGround(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersProjectProvingGround', ProvingGroundProject.ObjectID));
				ProvingGroundProject.CompletionDateTime = `STRATEGYRULES.GameTime;
				ProvingGroundProject.bInstant = true;
			}
		}
	}
}
//---------------------------------------------------------------------------------------
static function DeactivateMunitionsExperts(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantRandomAmmo = false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateScavengersTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_Scavengers');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateScavengers;
	Template.OnDeactivatedFn = DeactivateScavengers;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateScavengers(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);

	if(XComHQ.BonusPOIScalar == 0)
	{
		XComHQ.BonusPOIScalar = 1.0f;
	}

	XComHQ.BonusPOIScalar *= 2.0f;
}
//---------------------------------------------------------------------------------------
static function DeactivateScavengers(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusPOIScalar /= 2.0f;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateLiveFireTrainingTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_LiveFireTraining');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateLiveFireTraining;
	Template.OnDeactivatedFn = DeactivateLiveFireTraining;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateLiveFireTraining(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusTrainingRanks = 2;
}
//---------------------------------------------------------------------------------------
static function DeactivateLiveFireTraining(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusTrainingRanks = 0;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGuardianAngelsTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_GuardianAngels');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateGuardianAngels;
	Template.OnDeactivatedFn = DeactivateGuardianAngels;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateGuardianAngels(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;
	
	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.bPreventCovertActionAmbush = true;
	ResHQ.UpdateCovertActionNegatedRisks(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateGuardianAngels(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	
	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.bPreventCovertActionAmbush = false;
	ResHQ.UpdateCovertActionNegatedRisks(NewGameState);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateResistanceRisingITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ResistanceRisingI');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateResistanceRisingI;
	Template.OnDeactivatedFn = DeactivateResistanceRisingI;
	Template.CanBeRemovedFn = CanResistanceRisingBeRemoved;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateResistanceRisingI(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusCommCapacity += 1;
}
//---------------------------------------------------------------------------------------
static function DeactivateResistanceRisingI(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusCommCapacity -= 1;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateResistanceRisingIITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ResistanceRisingII');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateResistanceRisingII;
	Template.OnDeactivatedFn = DeactivateResistanceRisingII;
	Template.CanBeRemovedFn = CanResistanceRisingBeRemoved;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateResistanceRisingII(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusCommCapacity += 2;
}
//---------------------------------------------------------------------------------------
static function DeactivateResistanceRisingII(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusCommCapacity -= 2;
}
//---------------------------------------------------------------------------------------
static function bool CanResistanceRisingBeRemoved(StateObjectReference InRef, optional StateObjectReference ReplacementRef)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_StrategyCard CardState, ReplacementCardState;
	local bool bCanBeRemoved;

	History = `XCOMHISTORY;
	CardState = GetCardState(InRef);
	ReplacementCardState = GetCardState(ReplacementRef);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("DON'T SUBMIT: CARD PREVIEW STATE");
	DeactivateAllCardsNotInPlay(NewGameState);
	CardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', CardState.ObjectID));

	if(WasCardInPlay(CardState))
	{
		CardState.DeactivateCard(NewGameState);
	}

	if(ReplacementCardState != none)
	{
		ReplacementCardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', ReplacementCardState.ObjectID));
		ReplacementCardState.ActivateCard(NewGameState);
	}

	XComHQ = GetNewXComHQState(NewGameState);
	bCanBeRemoved = (XComHQ.GetRemainingContactCapacity() >= 0);
	History.CleanupPendingGameState(NewGameState);

	return bCanBeRemoved;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateVolunteerArmyTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_VolunteerArmy');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = VolunteerArmyTacticalStartModifier;

	return Template;
}
//---------------------------------------------------------------------------------------
static function VolunteerArmyTacticalStartModifier(XComGameState StartState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local name VolunteerCharacterTemplate;

	if (IsSplitMission( StartState ))
		return;

	if (default.VolunteerArmyChance < `SYNC_RAND_STATIC(100))
		return;

	foreach StartState.IterateByClassType( class'XComGameState_HeadquartersXCom', XComHQ )
		break;
	`assert( XComHQ != none );

	if (XComHQ.TacticalGameplayTags.Find( 'NoVolunteerArmy' ) != INDEX_NONE)
		return;

	if (XComHQ.IsTechResearched('PlasmaRifle'))
	{
		VolunteerCharacterTemplate = default.VolunteerArmyCharacterTemplateM3;
	}
	else if (XComHQ.IsTechResearched('MagnetizedWeapons'))
	{
		VolunteerCharacterTemplate = default.VolunteerArmyCharacterTemplateM2;
	}
	else
	{
		VolunteerCharacterTemplate = default.VolunteerArmyCharacterTemplate;
	}

	XComTeamSoldierSpawnTacticalStartModifier( VolunteerCharacterTemplate, StartState );
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateRapidCollectionTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_RapidCollection');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateRapidCollection;
	Template.OnDeactivatedFn = DeactivateRapidCollection;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateRapidCollection(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_ResourceCache CacheState;

	History = `XCOMHISTORY;
	CacheState = XComGameState_ResourceCache(History.GetSingleGameStateObjectForClass(class'XComGameState_ResourceCache'));
	CacheState = XComGameState_ResourceCache(NewGameState.ModifyStateObject(class'XComGameState_ResourceCache', CacheState.ObjectID));
	CacheState.bInstantScan = true;
}
//---------------------------------------------------------------------------------------
static function DeactivateRapidCollection(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameStateHistory History;
	local XComGameState_ResourceCache CacheState;

	History = `XCOMHISTORY;
	CacheState = XComGameState_ResourceCache(History.GetSingleGameStateObjectForClass(class'XComGameState_ResourceCache'));
	CacheState = XComGameState_ResourceCache(NewGameState.ModifyStateObject(class'XComGameState_ResourceCache', CacheState.ObjectID));
	CacheState.bInstantScan = false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateBetweenTheEyesTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_BetweenTheEyes');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantBetweenTheEyes;

	return Template;
}
//---------------------------------------------------------------------------------------
static function GrantBetweenTheEyes(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{
	if (UnitState.GetTeam() == eTeam_XCom)
	{
		AbilitiesToGrant.AddItem( 'BetweenTheEyes' );
	}
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateBallisticsModelingTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_BallisticsModeling');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateBallisticsModeling;
	Template.OnDeactivatedFn = DeactivateBallisticsModeling;
	Template.GetMutatorValueFn = GetValueBallisticsModeling;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateBallisticsModeling(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.WeaponsResearchScalar = (1.0f + (float(GetValueBallisticsModeling()) / 100.0f));
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateBallisticsModeling(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.WeaponsResearchScalar = 0;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValueBallisticsModeling()
{
	return `ScaleStrategyArrayInt(default.BallisticsModelingBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateHeavyEquipmentTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_HeavyEquipment');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateHeavyEquipment;
	Template.OnDeactivatedFn = DeactivateHeavyEquipment;
	Template.GetMutatorValueFn = GetValueHeavyEquipment;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateHeavyEquipment(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.ExcavateScalar = (1.0f + (float(GetValueHeavyEquipment()) / 100.0f));
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateHeavyEquipment(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.ExcavateScalar = 0;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValueHeavyEquipment()
{
	return `ScaleStrategyArrayInt(default.HeavyEquipmentBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateResistanceNetworkTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ResistanceNetwork');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateResistanceNetwork;
	Template.OnDeactivatedFn = DeactivateResistanceNetwork;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateResistanceNetwork(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_WorldRegion RegionState;

	History = `XCOMHISTORY;
	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantContacts = true;

	// Make contact with any regions which are currently being scanned
	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if (RegionState.bCanScanForContact)
		{
			RegionState = XComGameState_WorldRegion(NewGameState.ModifyStateObject(class'XComGameState_WorldRegion', RegionState.ObjectID));
			RegionState.MakeContact(NewGameState);
		}
	}
}
//---------------------------------------------------------------------------------------
static function DeactivateResistanceNetwork(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantContacts = false;
}

//#############################################################################################
//----------------   SKIRMISHER CARDS  --------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateVultureTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_Vulture');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateVulture;
	Template.OnDeactivatedFn = DeactivateVulture;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateVulture(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	AddSoldierUnlock(NewGameState, 'VultureUnlock');
}
//---------------------------------------------------------------------------------------
static function DeactivateVulture(XComGameState NewGameState, StateObjectReference InRef)
{
	RemoveSoldierUnlock(NewGameState, 'VultureUnlock');
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInsideJobITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_InsideJobI');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateInsideJobI;
	Template.OnDeactivatedFn = DeactivateInsideJobI;
	Template.GetMutatorValueFn = GetValueInsideJobI;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateInsideJobI(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.IntelRewardPercentIncrease += GetValueInsideJobI();
}
//---------------------------------------------------------------------------------------
static function DeactivateInsideJobI(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.IntelRewardPercentIncrease -= GetValueInsideJobI();
}
//---------------------------------------------------------------------------------------
static function int GetValueInsideJobI()
{
	return `ScaleStrategyArrayInt(default.InsideJobIBonus);
}


//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInsideJobIITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_InsideJobII');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateInsideJobII;
	Template.OnDeactivatedFn = DeactivateInsideJobII;
	Template.GetMutatorValueFn = GetValueInsideJobII;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateInsideJobII(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.IntelRewardPercentIncrease += GetValueInsideJobII();
}
//---------------------------------------------------------------------------------------
static function DeactivateInsideJobII(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.IntelRewardPercentIncrease -= GetValueInsideJobII();
}
//---------------------------------------------------------------------------------------
static function int GetValueInsideJobII()
{
	return `ScaleStrategyArrayInt(default.InsideJobIIBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateUnderTheTableITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_UnderTheTableI');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateUnderTheTableI;
	Template.OnDeactivatedFn = DeactivateUnderTheTableI;
	Template.GetMutatorValueFn = GetValueUnderTheTableI;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;
	Template.CanBePlayedFn = BlackMarketCardsCanBePlayed;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateUnderTheTableI(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_BlackMarket BlackMarket;

	BlackMarket = GetNewBlackMarketState(NewGameState);
	BlackMarket.BuyPricePercentIncrease += GetValueUnderTheTableI();
}
//---------------------------------------------------------------------------------------
static function DeactivateUnderTheTableI(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_BlackMarket BlackMarket;

	BlackMarket = GetNewBlackMarketState(NewGameState);
	BlackMarket.BuyPricePercentIncrease -= GetValueUnderTheTableI();
}
//---------------------------------------------------------------------------------------
static function int GetValueUnderTheTableI()
{
	return `ScaleStrategyArrayInt(default.UnderTheTableIBonus);
}

//---------------------------------------------------------------------------------------
static function bool BlackMarketCardsCanBePlayed(StateObjectReference InRef, optional XComGameState NewGameState = none)
{
	local XComGameState_BlackMarket BlackMarketState;

	BlackMarketState = XComGameState_BlackMarket(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));
	if (BlackMarketState != none && BlackMarketState.NumTimesAppeared > 0)
	{
		// Card is available if the Black Market has appeared at least once in the game
		return true;
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateUnderTheTableIITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_UnderTheTableII');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateUnderTheTableII;
	Template.OnDeactivatedFn = DeactivateUnderTheTableII;
	Template.GetMutatorValueFn = GetValueUnderTheTableII;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;
	Template.CanBePlayedFn = BlackMarketCardsCanBePlayed;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateUnderTheTableII(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_BlackMarket BlackMarket;

	BlackMarket = GetNewBlackMarketState(NewGameState);
	BlackMarket.BuyPricePercentIncrease += GetValueUnderTheTableII();
}
//---------------------------------------------------------------------------------------
static function DeactivateUnderTheTableII(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_BlackMarket BlackMarket;

	BlackMarket = GetNewBlackMarketState(NewGameState);
	BlackMarket.BuyPricePercentIncrease -= GetValueUnderTheTableII();
}
//---------------------------------------------------------------------------------------
static function int GetValueUnderTheTableII()
{
	return `ScaleStrategyArrayInt(default.UnderTheTableIIBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateQuidProQuoTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_QuidProQuo');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateQuidProQuo;
	Template.OnDeactivatedFn = DeactivateQuidProQuo;
	Template.GetMutatorValueFn = GetValueQuidProQuo;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;
	Template.CanBePlayedFn = BlackMarketCardsCanBePlayed;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateQuidProQuo(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_BlackMarket BlackMarket;

	BlackMarket = GetNewBlackMarketState(NewGameState);
	BlackMarket.GoodsCostPercentDiscount += GetValueQuidProQuo();
	BlackMarket.UpdateForSaleItemDiscount();
}
//---------------------------------------------------------------------------------------
static function DeactivateQuidProQuo(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_BlackMarket BlackMarket;

	BlackMarket = GetNewBlackMarketState(NewGameState);
	BlackMarket.GoodsCostPercentDiscount -= GetValueQuidProQuo();
	BlackMarket.UpdateForSaleItemDiscount();
}
//---------------------------------------------------------------------------------------
static function int GetValueQuidProQuo()
{
	return `ScaleStrategyArrayInt(default.QuidProQuoBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateBombSquadTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_BombSquad');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateBombSquad;
	Template.OnDeactivatedFn = DeactivateBombSquad;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateBombSquad(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom ProvingGround;
	local XComGameState_Tech TechState;
	local XComGameState_HeadquartersProjectResearch ProvingGroundProject;
	local StateObjectReference ProjectRef;

	History = `XCOMHISTORY;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantRandomGrenades = true;
	XComHQ.bInstantRandomHeavyWeapons = true;

	// Check if there are any current weapon projects, and set it to complete immediately
	if(XComHQ.HasFacilityByName('ProvingGround'))
	{
		ProvingGround = XComHQ.GetFacilityByName('ProvingGround');
		foreach ProvingGround.BuildQueue(ProjectRef)
		{
			ProvingGroundProject = XComGameState_HeadquartersProjectProvingGround(History.GetGameStateForObjectID(ProjectRef.ObjectID));
			TechState = XComGameState_Tech(History.GetGameStateForObjectID(ProvingGroundProject.ProjectFocus.ObjectID));
			if(TechState.GetMyTemplate().bRandomGrenade || TechState.GetMyTemplate().bRandomHeavyWeapon)
			{
				ProvingGroundProject = XComGameState_HeadquartersProjectProvingGround(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersProjectProvingGround', ProvingGroundProject.ObjectID));
				ProvingGroundProject.CompletionDateTime = `STRATEGYRULES.GameTime;
				ProvingGroundProject.bInstant = true;
			}
		}
	}
}
//---------------------------------------------------------------------------------------
static function DeactivateBombSquad(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantRandomGrenades = false;
	XComHQ.bInstantRandomHeavyWeapons = false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateSabotageTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_Sabotage');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateSabotage;
	Template.OnDeactivatedFn = DeactivateSabotage;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateSabotage(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = GetNewAlienHQState(NewGameState);
	AlienHQ.bSabotaged = true;
}
//---------------------------------------------------------------------------------------
static function DeactivateSabotage(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = GetNewAlienHQState(NewGameState);
	AlienHQ.bSabotaged = false;
}
//---------------------------------------------------------------------------------------
static function EndOfMonthSabotage(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_MissionSite MissionState;
	local array<XComGameState_MissionSite> DoomMissions;
	local PendingDoom DoomPending;

	AlienHQ = GetNewAlienHQState(NewGameState);
	MissionState = AlienHQ.GetFortressMission();

	if(MissionState.Doom > 0)
	{
		AlienHQ.RemoveDoomFromFortress(NewGameState, 1, class'X2StrategyElement_XPackRewards'.default.RewardDoomRemovedSabotage, true);
	}
	else
	{
		History = `XCOMHISTORY;

		foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
		{
			if(MissionState.Available && MissionState.Doom > 0)
			{
				DoomMissions.AddItem(MissionState);
			}
		}

		if(DoomMissions.Length > 0)
		{
			MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', DoomMissions[`SYNC_RAND_STATIC(DoomMissions.Length)].ObjectID));
			MissionState.Doom--;
			DoomPending.Doom = -1;
			DoomPending.DoomMessage = class'X2StrategyElement_XPackRewards'.default.RewardDoomRemovedSabotage;
			AlienHQ.PendingDoomData.AddItem(DoomPending);
			AlienHQ.PendingDoomEntity = MissionState.GetReference();
		}
	}
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateDecoysAndDeceptionsTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_DecoysAndDeceptions');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateDecoysAndDeceptions;
	Template.OnDeactivatedFn = DeactivateDecoysAndDeceptions;
	Template.GetMutatorValueFn = GetValueDecoysAndDeceptions;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateDecoysAndDeceptions(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.KnowledgeGainScalar = float(100 - GetValueDecoysAndDeceptions()) / 100.0f;
	}
}
//---------------------------------------------------------------------------------------
static function DeactivateDecoysAndDeceptions(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.KnowledgeGainScalar = 0;
	}
}
//---------------------------------------------------------------------------------------
static function int GetValueDecoysAndDeceptions()
{
	return `ScaleStrategyArrayInt(default.DecoysAndDeceptionsReduction);
}


//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePrivateChannelTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_PrivateChannel');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = PrivateChannelsTacticalStartModifier;
	Template.GetMutatorValueFn = GetValuePrivateChannel;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function PrivateChannelsTacticalStartModifier(XComGameState StartState)
{
	local XComGameState_BattleData BattleData;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
	{
		break;
	}
	`assert( BattleData != none );

	BattleData.ActiveSitReps.AddItem( 'PrivateChannelsSitRep' );
}
//---------------------------------------------------------------------------------------
static function int GetValuePrivateChannel()
{
	return `ScaleStrategyArrayInt(default.PrivateChannelTurns);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateIntegratedWarfareTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_IntegratedWarfare');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateIntegratedWarfare;
	Template.OnDeactivatedFn = DeactivateIntegratedWarfare;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateIntegratedWarfare(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	AddSoldierUnlock(NewGameState, 'IntegratedWarfareUnlock');
}
//---------------------------------------------------------------------------------------
static function DeactivateIntegratedWarfare(XComGameState NewGameState, StateObjectReference InRef)
{
	RemoveSoldierUnlock(NewGameState, 'IntegratedWarfareUnlock');
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateWeakPointsTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_WeakPoints');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantWeakPoints;
	Template.GetMutatorValueFn = GetValueWeakPoints;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function GrantWeakPoints(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{
	if (UnitState.GetTeam() == eTeam_XCom)
	{
		AbilitiesToGrant.AddItem( 'WeakPoints' );
	}
}

//---------------------------------------------------------------------------------------
static function int GetValueWeakPoints()
{
	return `ScaleStrategyArrayInt(default.WeakPointsShred);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInsideKnowledgeTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_InsideKnowledge');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateInsideKnowledge;
	Template.OnDeactivatedFn = DeactivateInsideKnowledge;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateInsideKnowledge(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bEmpoweredUpgrades = true;
}
//---------------------------------------------------------------------------------------
static function DeactivateInsideKnowledge(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bEmpoweredUpgrades = false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateDoubleAgentTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_DoubleAgent');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = DoubleAgentTacticalStartModifier;
	Template.GetAbilitiesToGrantFn = GrantDoubleAgentEvac;

	return Template;
}
//---------------------------------------------------------------------------------------
static function DoubleAgentTacticalStartModifier(XComGameState StartState)
{
	local XComGameState_BattleData BattleData;
	local XComGameState_HeadquartersXCom XComHQ;
	local DoubleAgentData DoubleAgent;
	local int CurrentForceLevel, Rand;
	local array<name> PossibleTemplates;

	if (IsSplitMission( StartState ))
		return;

	if (default.DoubleAgentChance < `SYNC_RAND_STATIC(100))
		return;

	foreach StartState.IterateByClassType( class'XComGameState_HeadquartersXCom', XComHQ )
		break;
	`assert( XComHQ != none );

	if (XComHQ.TacticalGameplayTags.Find( 'NoDoubleAgent' ) != INDEX_NONE)
		return;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
	{
		break;
	}
	`assert( BattleData != none );

	CurrentForceLevel = BattleData.GetForceLevel( );
	foreach default.DoubleAgentCharacterTemplates( DoubleAgent )
	{
		if ((CurrentForceLevel < DoubleAgent.MinForceLevel) ||
			(CurrentForceLevel > DoubleAgent.MaxForceLevel))
		{
			continue;
		}

		PossibleTemplates.AddItem( DoubleAgent.TemplateName );
	}


	if (PossibleTemplates.Length > 0)
	{
		Rand = `SYNC_RAND_STATIC( PossibleTemplates.Length );
		XComTeamSoldierSpawnTacticalStartModifier( PossibleTemplates[ Rand ], StartState );
	}
	else
	{
		`redscreen("Double Agent Policy unable to find any potential templates for Force Level " @ CurrentForceLevel );
	}
}
//---------------------------------------------------------------------------------------
static function GrantDoubleAgentEvac(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{
	if ((UnitState.GetTeam() == eTeam_XCom) && !UnitState.IsSoldier())
	{
		AbilitiesToGrant.AddItem( 'Evac' );
		AbilitiesToGrant.AddItem('PlaceEvacZone');
		AbilitiesToGrant.AddItem('LiftOffAvenger');

		AbilitiesToGrant.AddItem('Loot');
		AbilitiesToGrant.AddItem('CarryUnit');
		AbilitiesToGrant.AddItem('PutDownUnit');

		AbilitiesToGrant.AddItem('Interact_PlantBomb');
		AbilitiesToGrant.AddItem('Interact_TakeVial');
		AbilitiesToGrant.AddItem('Interact_StasisTube');
		AbilitiesToGrant.AddItem('Interact_MarkSupplyCrate');
		AbilitiesToGrant.AddItem('Interact_ActivateAscensionGate');

		AbilitiesToGrant.AddItem('DisableConsumeAllPoints');

		AbilitiesToGrant.AddItem('Revive');
		AbilitiesToGrant.AddItem('Panicked');
		AbilitiesToGrant.AddItem('Berserk');
		AbilitiesToGrant.AddItem('Obsessed');
		AbilitiesToGrant.AddItem('Shattered');
	}
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateImpactModelingTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ImpactModeling');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateImpactModeling;
	Template.OnDeactivatedFn = DeactivateImpactModeling;
	Template.GetMutatorValueFn = GetValueImpactModeling;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateImpactModeling(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.ArmorResearchScalar = (1.0f + (float(GetValueImpactModeling()) / 100.0f));
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateImpactModeling(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.ArmorResearchScalar = 0;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValueImpactModeling()
{
	return `ScaleStrategyArrayInt(default.ImpactModelingBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateModularConstructionTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ModularConstruction');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateModularConstruction;
	Template.OnDeactivatedFn = DeactivateModularConstruction;
	Template.GetMutatorValueFn = GetValueModularConstruction;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateModularConstruction(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.FacilityBuildScalar = (1.0f + (float(GetValueModularConstruction()) / 100.0f));
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateModularConstruction(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.FacilityBuildScalar = 0;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValueModularConstruction()
{
	return `ScaleStrategyArrayInt(default.ModularConstructionBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateInformationWarTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_InformationWar');
	Template.Category = "ResistanceCard";
	Template.GetMutatorValueFn = GetValueInformationWar;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;
	Template.ModifyTacticalStartStateFn = InformationWarTacticalStartModifier;
	Template.GetAbilitiesToGrantFn = GrantInformationWarDebuff;

	return Template;
}
//---------------------------------------------------------------------------------------
static function int GetValueInformationWar()
{
	return `ScaleStrategyArrayInt(default.InformationWarReduction);
}
//---------------------------------------------------------------------------------------
static function InformationWarTacticalStartModifier(XComGameState StartState)
{
	local XComGameState_BattleData BattleData;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
	{
		break;
	}
	`assert( BattleData != none );

	BattleData.ActiveSitReps.AddItem( 'InformationWarSitRep' );
}
//---------------------------------------------------------------------------------------
static function GrantInformationWarDebuff(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{
	if ((UnitState.GetTeam() == eTeam_Alien) && UnitState.IsRobotic())
	{
		AbilitiesToGrant.AddItem( 'InformationWar' ); // this will apply a debuff to the robot
	}
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateTacticalAnalysisTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_TacticalAnalysis');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = TacticalAnalysisStartModifier;
	Template.GetAbilitiesToGrantFn = GrantTacticalAnalysisDebuff;

	return Template;
}
//---------------------------------------------------------------------------------------
static function TacticalAnalysisStartModifier(XComGameState StartState)
{
	local X2EventManager EventManager;
	local XComGameState_Player Player;
	local Object PlayerObject;

	EventManager = `XEVENTMGR;

		foreach StartState.IterateByClassType( class'XComGameState_Player', Player )
	{
		if (Player.GetTeam() == eTeam_XCom)
			break;
	}
	`assert( Player != none );

	PlayerObject = Player;

	EventManager.RegisterForEvent(PlayerObject, 'ScamperEnd', Player.TacticalAnalysisScamperResponse, ELD_OnStateSubmitted);
}
//---------------------------------------------------------------------------------------
static function GrantTacticalAnalysisDebuff(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{
	if ((UnitState.GetTeam() == eTeam_Alien) || (UnitState.GetTeam() == eTeam_TheLost))
	{
		AbilitiesToGrant.AddItem( 'TacticalAnalysis' );
	}
}

//#############################################################################################
//----------------   TEMPLAR CARDS  -----------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateNobleCauseTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_NobleCause');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateNobleCause;
	Template.OnDeactivatedFn = DeactivateNobleCause;
	Template.GetMutatorValueFn = GetValueNobleCause;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateNobleCause(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.WillRecoveryRateScalar = (1.0f + (float(GetValueNobleCause()) / 100.0f));
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateNobleCause(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	ResHQ = GetNewResHQState(NewGameState);
	XComHQ = GetNewXComHQState(NewGameState);

	ResHQ.WillRecoveryRateScalar = 0;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValueNobleCause()
{
	return `ScaleStrategyArrayInt(default.NobleCauseBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateSuitUpTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_SuitUp');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateSuitUp;
	Template.OnDeactivatedFn = DeactivateSuitUp;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateSuitUp(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom ProvingGround;
	local XComGameState_Tech TechState;
	local XComGameState_HeadquartersProjectResearch ProvingGroundProject;
	local StateObjectReference ProjectRef;

	History = `XCOMHISTORY;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantArmors = true;

	// Check if there are any current weapon projects, and set it to complete immediately
	if(XComHQ.HasFacilityByName('ProvingGround'))
	{
		ProvingGround = XComHQ.GetFacilityByName('ProvingGround');
		foreach ProvingGround.BuildQueue(ProjectRef)
		{
			ProvingGroundProject = XComGameState_HeadquartersProjectProvingGround(History.GetGameStateForObjectID(ProjectRef.ObjectID));
			TechState = XComGameState_Tech(History.GetGameStateForObjectID(ProvingGroundProject.ProjectFocus.ObjectID));
			if(TechState.GetMyTemplate().bArmor)
			{
				ProvingGroundProject = XComGameState_HeadquartersProjectProvingGround(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersProjectProvingGround', ProvingGroundProject.ObjectID));
				ProvingGroundProject.CompletionDateTime = `STRATEGYRULES.GameTime;
				ProvingGroundProject.bInstant = true;
			}
		}
	}
}
//---------------------------------------------------------------------------------------
static function DeactivateSuitUp(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bInstantArmors = false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateTrialByFireTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_TrialByFire');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateTrialByFire;
	Template.OnDeactivatedFn = DeactivateTrialByFire;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateTrialByFire(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);

	XComHQ.BonusAbilityPointScalar *= 2.0;
}
//---------------------------------------------------------------------------------------
static function DeactivateTrialByFire(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusAbilityPointScalar /= 2.0;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateDeeperLearningITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_DeeperLearningI');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateDeeperLearningI;
	Template.OnDeactivatedFn = DeactivateDeeperLearningI;
	Template.GetMutatorValueFn = GetValueDeeperLearningI;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateDeeperLearningI(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local float BonusKillFloat;

	XComHQ = GetNewXComHQState(NewGameState);
	BonusKillFloat = float(GetValueDeeperLearningI()) / 100.0f;
	XComHQ.BonusKillXP += BonusKillFloat;
}
//---------------------------------------------------------------------------------------
static function DeactivateDeeperLearningI(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local float BonusKillFloat;

	XComHQ = GetNewXComHQState(NewGameState);
	BonusKillFloat = float(GetValueDeeperLearningI()) / 100.0f;
	XComHQ.BonusKillXP -= BonusKillFloat;
}
//---------------------------------------------------------------------------------------
static function int GetValueDeeperLearningI()
{
	return `ScaleStrategyArrayInt(default.DeeperLearningIBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateDeeperLearningIITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_DeeperLearningII');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateDeeperLearningII;
	Template.OnDeactivatedFn = DeactivateDeeperLearningII;
	Template.GetMutatorValueFn = GetValueDeeperLearningII;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateDeeperLearningII(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local float BonusKillFloat;

	XComHQ = GetNewXComHQState(NewGameState);
	BonusKillFloat = float(GetValueDeeperLearningII()) / 100.0f;
	XComHQ.BonusKillXP += BonusKillFloat;
}
//---------------------------------------------------------------------------------------
static function DeactivateDeeperLearningII(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local float BonusKillFloat;

	XComHQ = GetNewXComHQState(NewGameState);
	BonusKillFloat = float(GetValueDeeperLearningII()) / 100.0f;
	XComHQ.BonusKillXP -= BonusKillFloat;
}
//---------------------------------------------------------------------------------------
static function int GetValueDeeperLearningII()
{
	return `ScaleStrategyArrayInt(default.DeeperLearningIIBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateVengeanceTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_Vengeance');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateVengeance;
	Template.OnDeactivatedFn = DeactivateVengeance;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateVengeance(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	AddSoldierUnlock(NewGameState, 'VengeanceUnlock');
}
//---------------------------------------------------------------------------------------
static function DeactivateVengeance(XComGameState NewGameState, StateObjectReference InRef)
{
	RemoveSoldierUnlock(NewGameState, 'VengeanceUnlock');
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateStayWithMeTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_StayWithMe');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateStayWithMe;
	Template.OnDeactivatedFn = DeactivateStayWithMe;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateStayWithMe(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	AddSoldierUnlock(NewGameState, 'StayWithMeUnlock');
}
//---------------------------------------------------------------------------------------
static function DeactivateStayWithMe(XComGameState NewGameState, StateObjectReference InRef)
{
	RemoveSoldierUnlock(NewGameState, 'StayWithMeUnlock');
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateArtOfWarTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ArtOfWar');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateArtOfWar;
	Template.OnDeactivatedFn = DeactivateArtOfWar;
	Template.GetMutatorValueFn = GetValueArtOfWar;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateArtOfWar(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.AbilityPointScalar = (1.0f + (float(GetValueArtOfWar()) / 100.0f));
}
//---------------------------------------------------------------------------------------
static function DeactivateArtOfWar(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.AbilityPointScalar = 0;
}
//---------------------------------------------------------------------------------------
static function int GetValueArtOfWar()
{
	return `ScaleStrategyArrayInt(default.ArtOfWarBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateBondsOfWarTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_BondsOfWar');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateBondsOfWar;
	Template.OnDeactivatedFn = DeactivateBondsOfWar;
	Template.GetMutatorValueFn = GetValueBondsOfWar;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateBondsOfWar(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.CohesionScalar = (1.0f + (float(GetValueBondsOfWar()) / 100.0f));
}
//---------------------------------------------------------------------------------------
static function DeactivateBondsOfWar(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.CohesionScalar = 0;
}
//---------------------------------------------------------------------------------------
static function int GetValueBondsOfWar()
{
	return `ScaleStrategyArrayInt(default.BondsOfWarBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateTitheTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_Tithe');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateTithe;
	Template.OnDeactivatedFn = DeactivateTithe;
	Template.GetMutatorValueFn = GetValueTithe;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateTithe(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_MissionSite MissionState;
	local XComGameState_Reward RewardState;
	local StateObjectReference RewardRef;

	History = `XCOMHISTORY;

	// Set Res HQ value for new missions to use
	ResHQ = GetNewResHQState(NewGameState);
	ResHQ.MissionResourceRewardScalar = (1.0f + (float(GetValueTithe()) / 100.0f));

	// Scale existing mission rewards
	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		foreach MissionState.Rewards(RewardRef)
		{
			RewardState = XComGameState_Reward(History.GetGameStateForObjectID(RewardRef.ObjectID));

			if(RewardState != none && RewardState.IsResourceReward())
			{
				RewardState = XComGameState_Reward(NewGameState.ModifyStateObject(class'XComGameState_Reward', RewardState.ObjectID));
				RewardState.ScaleRewardQuantity(ResHQ.MissionResourceRewardScalar);
			}
		}
	}
}
//---------------------------------------------------------------------------------------
static function DeactivateTithe(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_MissionSite MissionState;
	local XComGameState_Reward RewardState;
	local StateObjectReference RewardRef;
	local float ScaleFactor;

	History = `XCOMHISTORY;

	// Revert Res HQ value
	ResHQ = GetNewResHQState(NewGameState);
	ScaleFactor = (1.0f / ResHQ.MissionResourceRewardScalar);
	ResHQ.MissionResourceRewardScalar = 0;

	// Revert existing mission rewards
	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		foreach MissionState.Rewards(RewardRef)
		{
			RewardState = XComGameState_Reward(History.GetGameStateForObjectID(RewardRef.ObjectID));

			if(RewardState != none && RewardState.IsResourceReward())
			{
				RewardState = XComGameState_Reward(NewGameState.ModifyStateObject(class'XComGameState_Reward', RewardState.ObjectID));
				RewardState.ScaleRewardQuantity(ScaleFactor);
			}
		}
	}
}
//---------------------------------------------------------------------------------------
static function int GetValueTithe()
{
	return `ScaleStrategyArrayInt(default.TitheBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateGreaterResolveTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_GreaterResolve');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateGreaterResolve;
	Template.OnDeactivatedFn = DeactivateGreaterResolve;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateGreaterResolve(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bAllowLightlyWoundedOnMissions = true;
}
//---------------------------------------------------------------------------------------
static function DeactivateGreaterResolve(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.bAllowLightlyWoundedOnMissions = false;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMentalFortitudeTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_MentalFortitude');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = MentalFortitudeStartModifier;

	return Template;
}
//---------------------------------------------------------------------------------------
static function MentalFortitudeStartModifier(XComGameState StartState)
{
	local XComGameState_BattleData BattleData;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
	{
		break;
	}
	`assert( BattleData != none );

	BattleData.ActiveSitReps.AddItem( 'MentalFortitude' );
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateFeedbackTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_Feedback');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantFeedback;

	return Template;
}
//---------------------------------------------------------------------------------------
static function GrantFeedback(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{
	if (UnitState.GetTeam() == eTeam_XCom)
	{
		AbilitiesToGrant.AddItem( 'Feedback' );
	}
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreatePursuitOfKnowledgeTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_PursuitOfKnowledge');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivatePursuitOfKnowledge;
	Template.OnDeactivatedFn = DeactivatePursuitOfKnowledge;
	Template.GetMutatorValueFn = GetValuePursuitOfKnowledge;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivatePursuitOfKnowledge(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);

	// Add a research bonus for each lab already created, then set the flag so it will work for all future labs built
	XComHQ.ResearchEffectivenessPercentIncrease = GetValuePursuitOfKnowledge() * XComHQ.GetNumberOfFacilitiesOfType(XComHQ.GetFacilityTemplate('Laboratory'));
	XComHQ.bLabBonus = true;

	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivatePursuitOfKnowledge(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ResearchEffectivenessPercentIncrease = 0;
	XComHQ.bLabBonus = false;

	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValuePursuitOfKnowledge()
{
	return `ScaleStrategyArrayInt(default.PursuitOfKnowledgeBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateHiddenReservesITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_HiddenReservesI');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateHiddenReservesI;
	Template.OnDeactivatedFn = DeactivateHiddenReservesI;
	Template.GetMutatorValueFn = GetValueHiddenReservesI;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;
	Template.CanBeRemovedFn = CanHiddenReservesBeRemoved;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateHiddenReservesI(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.PowerOutputBonus += GetValueHiddenReservesI();
	XComHQ.DeterminePowerState();
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateHiddenReservesI(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.PowerOutputBonus -= GetValueHiddenReservesI();
	XComHQ.DeterminePowerState();
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValueHiddenReservesI()
{
	return `ScaleStrategyArrayInt(default.HiddenReservesIBonus);
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateHiddenReservesIITemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_HiddenReservesII');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateHiddenReservesII;
	Template.OnDeactivatedFn = DeactivateHiddenReservesII;
	Template.GetMutatorValueFn = GetValueHiddenReservesII;
	Template.GetSummaryTextFn = GetSummaryTextReplaceInt;
	Template.CanBeRemovedFn = CanHiddenReservesBeRemoved;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateHiddenReservesII(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.PowerOutputBonus += GetValueHiddenReservesII();
	XComHQ.DeterminePowerState();
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateHiddenReservesII(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.PowerOutputBonus -= GetValueHiddenReservesII();
	XComHQ.DeterminePowerState();
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function int GetValueHiddenReservesII()
{
	return `ScaleStrategyArrayInt(default.HiddenReservesIIBonus);
}
//---------------------------------------------------------------------------------------
static function bool CanHiddenReservesBeRemoved(StateObjectReference InRef, optional StateObjectReference ReplacementRef)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_StrategyCard CardState, ReplacementCardState;
	local bool bCanBeRemoved;

	History = `XCOMHISTORY;
	CardState = GetCardState(InRef);
	ReplacementCardState = GetCardState(ReplacementRef);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("DON'T SUBMIT: CARD PREVIEW STATE");
	DeactivateAllCardsNotInPlay(NewGameState);
	CardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', CardState.ObjectID));

	if(WasCardInPlay(CardState))
	{
		CardState.DeactivateCard(NewGameState);
	}

	if(ReplacementCardState != none)
	{
		ReplacementCardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', ReplacementCardState.ObjectID));
		ReplacementCardState.ActivateCard(NewGameState);
	}

	XComHQ = GetNewXComHQState(NewGameState);
	bCanBeRemoved = (XComHQ.GetPowerProduced() >= XComHQ.GetPowerConsumed());
	History.CleanupPendingGameState(NewGameState);

	return bCanBeRemoved;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMachineLearningTemplate()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_MachineLearning');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateMachineLearning;
	Template.OnDeactivatedFn = DeactivateMachineLearning;

	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateMachineLearning(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ModifyBreakthroughTechTimer(class'XComGameState_HeadquartersXCom'.default.BreakthroughResistanceOrderModifier);
}
//---------------------------------------------------------------------------------------
static function DeactivateMachineLearning(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ModifyBreakthroughTechTimer(1.0 / class'XComGameState_HeadquartersXCom'.default.BreakthroughResistanceOrderModifier);
}

//#############################################################################################
//----------------   HELPER FUNCTIONS  --------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
static function XComGameState_StrategyCard GetCardState(StateObjectReference CardRef)
{
	return XComGameState_StrategyCard(`XCOMHISTORY.GetGameStateForObjectID(CardRef.ObjectID));
}
//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersXCom GetNewXComHQState(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom NewXComHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', NewXComHQ)
	{
		break;
	}

	if(NewXComHQ == none)
	{
		NewXComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		NewXComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', NewXComHQ.ObjectID));
	}

	return NewXComHQ;
}
//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersResistance GetNewResHQState(XComGameState NewGameState)
{
	local XComGameState_HeadquartersResistance NewResHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersResistance', NewResHQ)
	{
		break;
	}

	if(NewResHQ == none)
	{
		NewResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
		NewResHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', NewResHQ.ObjectID));
	}

	return NewResHQ;
}
//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersAlien GetNewAlienHQState(XComGameState NewGameState)
{
	local XComGameState_HeadquartersAlien NewAlienHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersAlien', NewAlienHQ)
	{
		break;
	}

	if(NewAlienHQ == none)
	{
		NewAlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		NewAlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', NewAlienHQ.ObjectID));
	}

	return NewAlienHQ;
}
//---------------------------------------------------------------------------------------
static function XComGameState_BlackMarket GetNewBlackMarketState(XComGameState NewGameState)
{
	local XComGameState_BlackMarket NewBlackMarket;

	foreach NewGameState.IterateByClassType(class'XComGameState_BlackMarket', NewBlackMarket)
	{
		break;
	}

	if(NewBlackMarket == none)
	{
		NewBlackMarket = XComGameState_BlackMarket(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));
		NewBlackMarket = XComGameState_BlackMarket(NewGameState.ModifyStateObject(class'XComGameState_BlackMarket', NewBlackMarket.ObjectID));
	}

	return NewBlackMarket;
}
//---------------------------------------------------------------------------------------
static function string GetDisplayNameReplaceInt(StateObjectReference InRef)
{
	local XComGameState_StrategyCard CardState;
	local X2StrategyCardTemplate CardTemplate;
	local XGParamTag ParamTag;

	CardState = GetCardState(InRef);

	if(CardState == none)
	{
		return "Error in GetDisplayName function";
	}

	CardTemplate = CardState.GetMyTemplate();
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = CardTemplate.GetMutatorValueFn();
	return `XEXPAND.ExpandString(CardTemplate.DisplayName);
}
//---------------------------------------------------------------------------------------
static function string GetSummaryTextReplaceInt(StateObjectReference InRef)
{
	local XComGameState_StrategyCard CardState;
	local X2StrategyCardTemplate CardTemplate;
	local XGParamTag ParamTag;

	CardState = GetCardState(InRef);

	if(CardState == none)
	{
		return "Error in GetSummaryText function";
	}

	CardTemplate = CardState.GetMyTemplate();
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = CardTemplate.GetMutatorValueFn();
	return `XEXPAND.ExpandString(CardTemplate.SummaryText);
}
//---------------------------------------------------------------------------------------
static function AddSoldierUnlock(XComGameState NewGameState, name UnlockTemplateName)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local X2StrategyElementTemplateManager StratMgr;
	local X2SoldierUnlockTemplate UnlockTemplate;

	XComHQ = GetNewXComHQState(NewGameState);
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	UnlockTemplate = X2SoldierUnlockTemplate(StratMgr.FindStrategyElementTemplate(UnlockTemplateName));

	if(UnlockTemplate != none)
	{
		XComHQ.AddSoldierUnlockTemplate(NewGameState, UnlockTemplate, true);
	}
}
//---------------------------------------------------------------------------------------
static function RemoveSoldierUnlock(XComGameState NewGameState, name UnlockTemplateName)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.RemoveSoldierUnlockTemplate(UnlockTemplateName);
}

static function XComTeamSoldierSpawnTacticalStartModifier(name CharTemplateName, XComGameState StartState)
{
	local X2CharacterTemplate Template;
	local XComGameState_Unit SoldierState;
	local XGCharacterGenerator CharacterGenerator;
	local XComGameState_Player PlayerState;
	local TSoldier Soldier;
	local XComGameState_HeadquartersXCom XComHQ;

	// generate a basic resistance soldier unit
	Template = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate( CharTemplateName );
	`assert(Template != none);

	SoldierState = Template.CreateInstanceFromTemplate(StartState);
	SoldierState.bMissionProvided = true;

	if (Template.bAppearanceDefinesPawn)
	{
		CharacterGenerator = `XCOMGRI.Spawn(Template.CharacterGeneratorClass);
		`assert(CharacterGenerator != none);

		Soldier = CharacterGenerator.CreateTSoldier( );
		SoldierState.SetTAppearance( Soldier.kAppearance );
		SoldierState.SetCharacterName( Soldier.strFirstName, Soldier.strLastName, Soldier.strNickName );
		SoldierState.SetCountry( Soldier.nmCountry );
	}

	// assign the player to him
	foreach StartState.IterateByClassType(class'XComGameState_Player', PlayerState)
	{
		if(PlayerState.GetTeam() == eTeam_XCom)
		{
			SoldierState.SetControllingPlayer(PlayerState.GetReference());
			break;
		}
	}

	// give him a loadout
	SoldierState.ApplyInventoryLoadout(StartState);

	foreach StartState.IterateByClassType( class'XComGameState_HeadquartersXCom', XComHQ )
		break;

	XComHQ.Squad.AddItem( SoldierState.GetReference() );
	XComHQ.AllSquads[0].SquadMembers.AddItem( SoldierState.GetReference() );
}

static function bool IsSplitMission( XComGameState StartState )
{
	local XComGameState_BattleData BattleData;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
		break;

	return (BattleData != none) && BattleData.DirectTransferInfo.IsDirectMissionTransfer;
}

static function DeactivateAllCardsNotInPlay(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_StrategyCard CardState;
	local array<StateObjectReference> AllOldCards, AllNewCards;
	local StateObjectReference CardRef;
	local int idx;

	History = `XCOMHISTORY;
	AllOldCards.Length = 0;
	AllNewCards.Length = 0;
	ResHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	// Grab all old and new cards
	foreach ResHQ.OldWildCardSlots(CardRef)
	{
		if(CardRef.ObjectID != 0 && AllOldCards.Find('ObjectID', CardRef.ObjectID) == INDEX_NONE)
		{
			AllOldCards.AddItem(CardRef);
		}
	}

	foreach ResHQ.WildCardSlots(CardRef)
	{
		if(CardRef.ObjectID != 0 && AllNewCards.Find('ObjectID', CardRef.ObjectID) == INDEX_NONE)
		{
			AllNewCards.AddItem(CardRef);
		}
	}

	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		foreach FactionState.OldCardSlots(CardRef)
		{
			if(CardRef.ObjectID != 0 && AllOldCards.Find('ObjectID', CardRef.ObjectID) == INDEX_NONE)
			{
				AllOldCards.AddItem(CardRef);
			}
		}

		foreach FactionState.CardSlots(CardRef)
		{
			if(CardRef.ObjectID != 0 && AllNewCards.Find('ObjectID', CardRef.ObjectID) == INDEX_NONE)
			{
				AllNewCards.AddItem(CardRef);
			}
		}
	}

	// Find old cards that are not in the new list
	for(idx = 0; idx < AllOldCards.Length; idx++)
	{
		if(AllNewCards.Find('ObjectID', AllOldCards[idx].ObjectID) != INDEX_NONE)
		{
			AllOldCards.Remove(idx, 1);
			idx--;
		}
	}

	// Deactivate old cards
	foreach AllOldCards(CardRef)
	{
		CardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', CardRef.ObjectID));
		CardState.DeactivateCard(NewGameState);
	}
}

static function bool WasCardInPlay(XComGameState_StrategyCard CardState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_ResistanceFaction FactionState;

	History = `XCOMHISTORY;
	ResHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	if(ResHQ.OldWildCardSlots.Find('ObjectID', CardState.ObjectID) != INDEX_NONE)
	{
		return true;
	}

	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		if(FactionState.OldCardSlots.Find('ObjectID', CardState.ObjectID) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}