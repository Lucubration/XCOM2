//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DLC_Day60DefaultFacilities.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2StrategyElement_DLC_Day60DefaultFacilities extends X2StrategyElement_DefaultFacilities;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Facilities;

	// Core Facilities
	Facilities.AddItem(CreateHangarTemplate());

	return Facilities;
}

static function UpdateFacilityProps(StateObjectReference FacilityRef, XGBase Base)
{
	local array<XComLevelActor> TrophyActors;
	local XComLevelActor Trophy;
	local XComGameState_HuntersLodgeManager LodgeMgr;
	local float NumKills;
	local bool bShowTrophy;

	LodgeMgr = XComGameState_HuntersLodgeManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HuntersLodgeManager'));

	LodgeMgr.CalcKillCount();
	
	TrophyActors = Base.GetLevelActorsWithLayer('Trophies');
	foreach TrophyActors(Trophy)
	{
		NumKills = 0.0;
		bShowTrophy = false; // For non-kill count related props

		switch( Trophy.Tag )
		{
		case 'Trophy_Trooper':
			NumKills = LodgeMgr.TrooperKills;
			break;
		case 'Trophy_Captain':
			NumKills = LodgeMgr.CaptainKills;
			break;
		case 'Trophy_StunLancer':
			NumKills = LodgeMgr.StunLancerKills;
			break;
		case 'Trophy_ShieldBearer':
			NumKills = LodgeMgr.ShieldBearerKills;
			break;
		case 'Trophy_PsiWitch':
			NumKills = LodgeMgr.PsiWitchKills;
			break;
		case 'Trophy_AdvMec_M1':
			NumKills = LodgeMgr.AdventMEC1Kills;
			break;
		case 'Trophy_AdvMec_M2':
			NumKills = LodgeMgr.AdventMEC2Kills;
			break;
		case 'Trophy_Turret':
			NumKills = LodgeMgr.AdventTurretKills;
			break;
		case 'Trophy_Sectopod':
			NumKills = LodgeMgr.SectopodKills;
			break;
		case 'Trophy_Sectoid':
			NumKills = LodgeMgr.SectoidKills;
			break;
		case 'Trophy_Archon':
			NumKills = LodgeMgr.ArchonKills;
			break;
		case 'Trophy_Viper':
			NumKills = LodgeMgr.ViperKills;
			break;
		case 'Trophy_Muton':
			NumKills = LodgeMgr.MutonKills;
			break;
		case 'Trophy_Berserker':
			NumKills = LodgeMgr.BerserkerKills;
			break;
		case 'Trophy_Cyberus':
			NumKills = LodgeMgr.CyberusKills;
			break;
		case 'Trophy_Gatekeeper':
			NumKills = LodgeMgr.GatekeeperKills;
			break;
		case 'Trophy_Chryssalid':
			NumKills = LodgeMgr.ChryssalidKills;
			break;
		case 'Trophy_Andromedon':
			NumKills = LodgeMgr.AndromedonKills;
			break;
		case 'Trophy_Faceless':
			NumKills = LodgeMgr.FacelessKills;
			break;
		case 'Trophy_Priest':
			NumKills = LodgeMgr.PriestKills;
			break;
		case 'Trophy_Purifier':
			NumKills = LodgeMgr.PurifierKills;
			break;
		case 'Trophy_Spectre':
			NumKills = LodgeMgr.SpectreKills;
			break;
		case 'Trophy_Lost':
			NumKills = LodgeMgr.LostKills;
			break;
		case 'Trophy_BoltcasterA':
			bShowTrophy = LodgeMgr.bShowBoltcasterA;
			break;
		case 'Trophy_BoltcasterB':
			bShowTrophy = LodgeMgr.bShowBoltcasterB;
			break;
		case 'Trophy_BoltcasterC':
			bShowTrophy = LodgeMgr.bShowBoltcasterC;
			break;
		case 'Trophy_PistolA':
			bShowTrophy = LodgeMgr.bShowPistolA;
			break;
		case 'Trophy_PistolB':
			bShowTrophy = LodgeMgr.bShowPistolB;
			break;
		case 'Trophy_PistolC':
			bShowTrophy = LodgeMgr.bShowPistolC;
			break;
		case 'Trophy_AxeA':
			bShowTrophy = LodgeMgr.bShowAxeA;
			break;
		case 'Trophy_AxeB':
			bShowTrophy = LodgeMgr.bShowAxeB;
			break;
		case 'Trophy_AxeC':
			bShowTrophy = LodgeMgr.bShowAxeC;
			break;
		case 'Trophy_ViperArmor':
			bShowTrophy = LodgeMgr.bShowViperArmor;
			break;
		case 'Trophy_BerserkerArmor':
			bShowTrophy = LodgeMgr.bShowBerserkerArmor;
			break;
		case 'Trophy_ArchonArmor':
			bShowTrophy = LodgeMgr.bShowArchonArmor;
			break;
		case 'Trophy_ChosenAssassin':
			bShowTrophy = LodgeMgr.bShowChosenAssassin;
			break;
		case 'Trophy_ChosenHunter':
			bShowTrophy = LodgeMgr.bShowChosenHunter;
			break;
		case 'Trophy_ChosenWarlock':
			bShowTrophy = LodgeMgr.bShowChosenWarlock;
			break;
		}

		Trophy.StaticMeshComponent.SetHidden(NumKills == 0.0 && !bShowTrophy);
	}
}

static function X2DataTemplate CreateHangarTemplate()
{
	local X2FacilityTemplate Template;
	local AuxMapInfo MapInfo;

	Template = X2FacilityTemplate(Super.CreateHangarTemplate());
	Template.MapName = "DLC_60_AVG_HuntersLodge_A";
	Template.AnimMapName = "DLC_60_AVG_HuntersLodge_A_Anim";
	Template.UpdateFacilityPropsFn = UpdateFacilityProps;
	Template.UIFacilityClass = class'UIFacility_HuntersLodge';
	
	MapInfo.MapName = "CIN_SoldierIntros_DLC2";
	MapInfo.InitiallyVisible = true;
	Template.AuxMaps.AddItem(MapInfo);

	return Template;
}