//---------------------------------------------------------------------------------------
//  FILE:    X2Action_UpdateUI.uc
//  AUTHOR:  Dan Kaplan  --  3/22/2015
//  PURPOSE: Updates the UI as part of a visualizer Metadata.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_UpdateUI extends X2Action;

enum EUIUpdateType
{
	EUIUT_None,					// placeholder
	EUIUT_HUD_Concealed,		// update the Concealed markup on the hud for the active unit
	EUIUT_UnitFlag_Concealed,	// update the Concealed unit flag
	EUIUT_UnitFlag_Buffs,		// update the unit flag's buff/debuff status
	EUIUT_UnitFlag_Cover,		// update the unit flag's cover status
	EUIUT_UnitFlag_Moves,		// update the unit flag's moves remaining status
	EUIUT_BeginTurn,			// switch between XCom and Alien turn UI
	EUIUT_EndTurn,
	EUIUT_Pathing_Concealment,	// update concealment breaking markup on the pathing pawn
	EUIUT_UnitFlag_Health,		// update the unit flag's health
	EUIUT_GroupInitiative,		// update initiative status
	EUIUT_SuperConcealRoll,		// update reaper mode preview with animated roll
	EUIUT_ChosenHUD,			// Update chosen ui
	EUIUT_FocusLevel,			// Update the focus level of a unit
	EUIUT_SetHUDVisibility,		// sets the visibility of HUD components based on DesiredHUDVisibility
	EUIUT_RestoreHUDVisibility,	// resets the visibility of HUD components back to their previous value at the time of the last EUIUT_SetHUDVisibility
};

// The type of UI update to be performed
var EUIUpdateType UpdateType;

// The UnitID of a specific unit to perform the update; will be performed on all units if not specified.  In the case of EUIUT_BeginTurn, holds the Player ObjectID
var int SpecificID;

var HUDVisibilityFlags DesiredHUDVisibility;

event bool BlocksAbilityActivation()
{
	return false;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	simulated private function UpdateUI()
	{
		local XComPresentationLayer PresentationLayer;
		local XComTacticalController LocalPlayerController;
		local XComGameState_Unit CurrentUnit;
		local XComGameState_Player PlayerState;
		local XGPlayer PlayerStateVisualizer;
		local bool bIsOwnerLocalPlayer;
		local XComGameState_BattleData BattleData;
		local XComGameState_Effect_TemplarFocus FocusState;
		local String RevealString;

		PresentationLayer = `PRES;

		switch( UpdateType )
		{
		case EUIUT_Pathing_Concealment:
			LocalPlayerController = XComTacticalController(GetALocalPlayerController());
			LocalPlayerController.m_kPathingPawn.UpdateConcealmentTilesVisibility();
			break;
		case EUIUT_HUD_Concealed:
			// update the concealed state markup on the hud
			LocalPlayerController = XComTacticalController(GetALocalPlayerController());
			bIsOwnerLocalPlayer = Unit.GetPlayer() == LocalPlayerController.m_XGPlayer;

			if (SpecificID <= 0)
			{
				// use the active unit if none is specified
				SpecificID = LocalPlayerController.GetActiveUnitStateRef().ObjectID;
			}
			if( (SpecificID > 0) && bIsOwnerLocalPlayer )
			{
				PresentationLayer.GetTacticalHUD().RealizeConcealmentStatus(SpecificID, true, StateChangeContext.AssociatedState.HistoryIndex);

				// clear the PPEffect if concealment was broken
				CurrentUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SpecificID, , StateChangeContext.AssociatedState.HistoryIndex));
				if (CurrentUnit != None)
				{
					PresentationLayer.LastConcealmentShaderUpdate = StateChangeContext.AssociatedState.HistoryIndex;
					PresentationLayer.EnablePostProcessEffect('ConcealmentMode', CurrentUnit.IsConcealed() && !CurrentUnit.IsSuperConcealed(), true);
					PresentationLayer.EnablePostProcessEffect('ConcealmentModeOff', !CurrentUnit.IsConcealed(), true);
					PresentationLayer.EnablePostProcessEffect('ShadowModeOn', CurrentUnit.IsSuperConcealed(), true);
					PresentationLayer.EnablePostProcessEffect('ShadowModeOff', !CurrentUnit.IsSuperConcealed(), true);
				}
			}
			break;

		case EUIUT_UnitFlag_Concealed:
			// update the unit flag
			PresentationLayer.m_kUnitFlagManager.RealizeConcealment(SpecificID, StateChangeContext.AssociatedState.HistoryIndex);
			break;

		case EUIUT_UnitFlag_Buffs:
			// update the unit flag
			PresentationLayer.m_kUnitFlagManager.RealizeBuffs(SpecificID, StateChangeContext.AssociatedState.HistoryIndex);
			break;

		case EUIUT_UnitFlag_Cover:
			// update the unit flag
			PresentationLayer.m_kUnitFlagManager.RealizeCover(SpecificID, StateChangeContext.AssociatedState.HistoryIndex);
			break;

		case EUIUT_UnitFlag_Moves:
			// update the unit flag
			PresentationLayer.m_kUnitFlagManager.RealizeMoves(SpecificID, StateChangeContext.AssociatedState.HistoryIndex);
			break;

		case EUIUT_UnitFlag_Health:
			// update the unit flag
			PresentationLayer.m_kUnitFlagManager.RealizeHealth(SpecificID, StateChangeContext.AssociatedState.HistoryIndex);
			break;

		case EUIUT_BeginTurn:
			BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
			PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(SpecificID));
			PlayerStateVisualizer = XGPlayer(PlayerState.GetVisualizer());
			PlayerStateVisualizer.OnBeginTurnVisualized(BattleData.UnitActionInitiativeRef.ObjectID);

			LocalPlayerController = XComTacticalController(GetALocalPlayerController());
			LocalPlayerController.m_kPathingPawn.MarkAllConcealmentCachesDirty();
			LocalPlayerController.m_kPathingPawn.UpdateConcealmentTilesVisibility();

			PresentationLayer.m_kUnitFlagManager.RealizeMoves(-1, StateChangeContext.AssociatedState.HistoryIndex);
			break;

		case EUIUT_EndTurn:
			PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(SpecificID));
			PlayerStateVisualizer = XGPlayer(PlayerState.GetVisualizer());
			PlayerStateVisualizer.OnEndTurnVisualized();

			LocalPlayerController = XComTacticalController(GetALocalPlayerController());
			LocalPlayerController.m_kPathingPawn.UpdateConcealmentTilesVisibility();

			PresentationLayer.GetTacticalHUD().UpdateChosenHUDActivation();
			break;

		case EUIUT_GroupInitiative:
			PresentationLayer.m_kTurnOverlay.m_kInitiativeOrder.UpdateInitiativeOrder();
			break;

		case EUIUT_SuperConcealRoll:
			if (SpecificID > 0)
			{
				CurrentUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SpecificID, , StateChangeContext.AssociatedState.HistoryIndex));
				RevealString = CurrentUnit.LastSuperConcealmentResult ? class'XLocalizedData'.default.ShadowBannerRevealed : class'XLocalizedData'.default.ShadowBannerNotRevealed;
				PresentationLayer.GetTacticalHUD().UpdateReaperHUDPreview(CurrentUnit.LastSuperConcealmentRoll / 100.0f, CurrentUnit.LastSuperConcealmentValue / 100.0f, RevealString);
			}
			break;

		case EUIUT_ChosenHUD:
			PresentationLayer.GetTacticalHUD().UpdateChosenHUDActivation();
			`XTACTICALSOUNDMGR.EvaluateTacticalMusicState(); // In case Chosen is engaged
			break;

		case EUIUT_FocusLevel:
			FocusState = XComGameState_Effect_TemplarFocus(`XCOMHISTORY.GetGameStateForObjectID(SpecificID, , StateChangeContext.AssociatedState.HistoryIndex));
			if( FocusState != None )
			{
				CurrentUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(FocusState.ApplyEffectParameters.TargetStateObjectRef.ObjectID, , StateChangeContext.AssociatedState.HistoryIndex));
				if( CurrentUnit != None )
				{
					PresentationLayer.GetTacticalHUD().SetFocusLevel(FocusState, CurrentUnit);

					PresentationLayer.m_kUnitFlagManager.RealizeHealth(CurrentUnit.ObjectID, StateChangeContext.AssociatedState.HistoryIndex);
				}
			}
			break;

		case EUIUT_SetHUDVisibility:
			PresentationLayer.GetTacticalHUD().SetHUDVisibility(DesiredHUDVisibility);
			break;

		case EUIUT_RestoreHUDVisibility:
			PresentationLayer.GetTacticalHUD().RestoreHUDVisibility();
			break;

		default:
			`assert(false); // unhandled UpdateType
		}
	}

Begin:
	UpdateUI();
	switch (UpdateType)
	{
	case EUIUT_SuperConcealRoll:
		if (`REPLAY.bInReplay)
		{
			`PRES.GetTacticalHUD().VisualizerForceShow();
			`PRES.GetTacticalHUD().ReplayToggleReaperHUD(true);
			Sleep(3.0f);
			`PRES.GetTacticalHUD().ReplayToggleReaperHUD(false);
			`PRES.GetTacticalHUD().Hide();
		}
		break;
	default:
		break;
	}

	CompleteAction();
}

defaultproperties
{
	SpecificID=-1
}

