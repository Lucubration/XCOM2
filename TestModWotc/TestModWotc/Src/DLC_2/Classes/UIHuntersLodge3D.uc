//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIHuntersLodge3D.uc
//  AUTHOR:  Brit Steiner
//  PURPOSE: UI for viewing the 3D display in the Hunter's Lodge 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UIHuntersLodge3D extends UIScreen;

//----------------------------------------------------------------------------
// MEMBERS
// ------------------------------------------------------------

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	Show();
}


simulated function Show()
{
	UIMovie_3D(Movie).HideAllDisplays();
	RefreshData();
	UIMovie_3D(Movie).ShowDisplay('3DUIBP_ScoreBoard');
	super.Show();
}

function RefreshData()
{
	local XComGameState_HuntersLodgeManager LodgeMgr;

	LodgeMgr = XComGameState_HuntersLodgeManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HuntersLodgeManager'));

	AS_SetInfo(0,	LodgeMgr.GatekeeperKills);
	AS_SetInfo(1,	LodgeMgr.SectopodKills);
	AS_SetInfo(2,	LodgeMgr.ViperKills);
	AS_SetInfo(3,	LodgeMgr.ArchonKills);
	AS_SetInfo(4,	LodgeMgr.BerserkerKills);
	AS_SetInfo(5,	LodgeMgr.AndromedonKills);
	AS_SetInfo(6,	LodgeMgr.AdventMEC1Kills);
	AS_SetInfo(7,	LodgeMgr.AdventMEC2Kills);
	AS_SetInfo(8,	LodgeMgr.AdventTurretKills);
	AS_SetInfo(9,	LodgeMgr.SectoidKills);
	AS_SetInfo(10,	LodgeMgr.MutonKills);
	AS_SetInfo(11,	LodgeMgr.CyberusKills);
	AS_SetInfo(12,	LodgeMgr.FacelessKills);
	AS_SetInfo(13,	LodgeMgr.ChryssalidKills);
	AS_SetInfo(14,	LodgeMgr.PsiWitchKills);
	AS_SetInfo(15,	LodgeMgr.TrooperKills);
	AS_SetInfo(16,	LodgeMgr.CaptainKills);
	AS_SetInfo(17,	LodgeMgr.ShieldBearerKills);
	AS_SetInfo(18,	LodgeMgr.StunLancerKills);
					
	AS_SetInfo(19,	LodgeMgr.PriestKills);
	AS_SetInfo(20,	LodgeMgr.PurifierKills);
	AS_SetInfo(21,	LodgeMgr.SpectreKills);
	AS_SetInfo(22,	LodgeMgr.LostKills);
}				  


simulated function AS_SetInfo(int Index, int DisplayValue)
{
	MC.BeginFunctionOp("setInfo");
	MC.QueueNumber(Index);
	MC.QueueNumber(DisplayValue);
	MC.EndOp();
}

simulated function Hide()
{
	super.Hide();
}

defaultproperties
{
	Package = "/ package/gfxHuntersLodge/HuntersLodge";
}
