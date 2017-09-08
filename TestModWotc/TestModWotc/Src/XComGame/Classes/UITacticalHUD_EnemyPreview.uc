//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UITacticalHUD_EnemyPreview.uc
//  AUTHOR:  Brit Steiner 
//  PURPOSE: HUD component to show currently visible aliens to the active soldier. 
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UITacticalHUD_EnemyPreview extends UITacticalHUD_Enemies;

var X2AbilityTarget_Single StandardAbilityTarget;
var array<X2Condition> LivingHostileGameplayVisibleFilter;
var localized string Label; 
var array<StateObjectReference> FlankedTargets;

simulated function UITacticalHUD_Enemies InitEnemyTargets()
{
	super.InitEnemyTargets();
	SetLabel(Label);
	return self; 
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;    // Has input been 'consumed'?

	switch( cmd )
	{

	case (class'UIUtilities_Input'.const.FXS_KEY_LEFT_ALT):
		

		if( (arg & class'UIUtilities_Input'.const.FXS_ACTION_PRESS) == 0 )
		{
			Show();
			SetTimer(0.5, true, 'CheckForHide');
		}


		if( (arg & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) == 0 )
		{
			CheckForHide();
			ClearTimer('CheckForHide');
		}

		bHandled = true;
		break;

	}
	return bHandled;
}

// ------------------------------------------------------------------------------------------
//Refactored so you can set total number of enemies after setting the icon types first. 
simulated function SetVisibleEnemies(int iVisibleAliens)
{
	if( iVisibleAliens != m_iVisibleEnemies )
	{
		m_iVisibleEnemies = iVisibleAliens;
		MC.FunctionNum("SetVisibleEnemies", iVisibleAliens);

		CheckForHide();
	}
}

function CheckForHide()
{
	if( XComInputBase(XComPlayerController(Movie.Pres.Owner).PlayerInput).IsTracking(class'UIUtilities_Input'.const.FXS_KEY_LEFT_ALT) || `XPROFILESETTINGS.data.m_bTargetPreviewAlwaysOn)
	{
		Show();
	}
	else
	{
		Hide();
		ClearTimer('CheckForHide');
	}
}

simulated function Show()
{
	if( XComInputBase(XComPlayerController(Movie.Pres.Owner).PlayerInput).IsTracking(class'UIUtilities_Input'.const.FXS_KEY_LEFT_ALT) || `XPROFILESETTINGS.data.m_bTargetPreviewAlwaysOn)
	{
		super.Show();
	}
	else
	{
		Hide();
	}
}

simulated function InitNavHelp()
{
}

simulated function UpdatePreviewTargets(GameplayTileData MoveToTileData, const out array<StateObjectReference> ObjectsVisibleToPlayer, int HistoryIndex = -1)
{
	local StateObjectReference CurrentObjRef;
	local GameRulesCache_VisibilityInfo CurrentVisibilityInfo, EmptyInfo;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local XComGameState_BaseObject CurrentTarget;
	local XComGameState_Unit EnemyUnit;

	History = `XCOMHISTORY;
	VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	// start with the enemies visible from current location
	m_arrTargets = XComPresentationLayer(Movie.Pres).m_kTacticalHUD.m_kEnemyTargets.m_arrTargets;
	m_arrCurrentlyAffectable.Length = 0;
	m_arrSSEnemies.Length = 0;
	FlankedTargets.Length = 0;

	// generate the new list of targets
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(MoveToTileData.SourceObjectID, , HistoryIndex));
	foreach ObjectsVisibleToPlayer(CurrentObjRef)
	{
		CurrentVisibilityInfo = EmptyInfo;
		CurrentVisibilityInfo.SourceID = MoveToTileData.SourceObjectID;
		CurrentVisibilityInfo.TargetID = CurrentObjRef.ObjectID;

		if( VisibilityMgr.GetVisibilityInfoFromRemoteLocation(
			MoveToTileData.SourceObjectID,
			MoveToTileData.EventTile,
			CurrentObjRef.ObjectID,
			CurrentVisibilityInfo) )
		{
			if( CurrentVisibilityInfo.bClearLOS )
			{
				if( VisibilityMgr.EvaluateConditions(
					   CurrentVisibilityInfo,
					   HistoryIndex,
					   default.LivingHostileGameplayVisibleFilter) )
				{
					CurrentTarget = History.GetGameStateForObjectID(CurrentObjRef.ObjectID);
					EnemyUnit = XComGameState_Unit(CurrentTarget);

					if( (EnemyUnit == none || !EnemyUnit.GetMyTemplate().bIsCosmetic) &&
					   StandardAbilityTarget.ValidatePrimaryTargetOptionFromRemoteLocation(UnitState, MoveToTileData.EventTile, CurrentTarget) )
					{
						m_arrCurrentlyAffectable.AddItem(CurrentObjRef);

						if( m_arrTargets.Find('ObjectID', CurrentObjRef.ObjectID) == INDEX_NONE )
						{
							m_arrTargets.AddItem(CurrentObjRef);
						}

						if( !CurrentVisibilityInfo.bVisibleBasic  )
						{
							m_arrSSEnemies.AddItem(CurrentObjRef);
						}

						if (EnemyUnit != none && EnemyUnit.CanTakeCover() && CurrentVisibilityInfo.TargetCover == CT_None)
						{
							if (FlankedTargets.Find('ObjectID', CurrentObjRef.ObjectID) == INDEX_NONE)
								FlankedTargets.AddItem(CurrentObjRef);
						}
					}
				}
			}
		}
	}

	iNumVisibleEnemies = m_arrTargets.Length;

	UpdateVisuals(HistoryIndex);
	CheckForHide();
}

public function UpdateVisuals(int HistoryIndex)
{
	local XGUnit kActiveUnit;
	local XComGameState_BaseObject TargetedObject;
	local XComGameState_Unit EnemyUnit;
	local X2VisualizerInterface Visualizer;
	local XComGameStateHistory History;
	local int i;

	// DATA: -----------------------------------------------------------
	History = `XCOMHISTORY;
	kActiveUnit = XComTacticalController(PC).GetActiveUnit();
	if (kActiveUnit == none) return;


	// VISUALS: -----------------------------------------------------------
	// Now that the array is tidy, we can set the visuals from it.



	SetVisibleEnemies(iNumVisibleEnemies); //Do this before setting data 

	for (i = 0; i < m_arrTargets.Length; i++)
	{
		TargetedObject = History.GetGameStateForObjectID(m_arrTargets[i].ObjectID, , HistoryIndex);
		Visualizer = X2VisualizerInterface(TargetedObject.GetVisualizer());
		EnemyUnit = XComGameState_Unit(TargetedObject);

		SetIcon(i, Visualizer.GetMyHUDIcon());

		if (m_arrCurrentlyAffectable.Find('ObjectID', TargetedObject.ObjectID) > -1)
		{
			SetBGColor(i, Visualizer.GetMyHUDIconColor());
			SetDisabled(i, false);
		}
		else
		{
			SetBGColor(i, eUIState_Disabled);
			SetDisabled(i, true);
		}

		if (m_arrSSEnemies.Find('ObjectID', TargetedObject.ObjectID) > -1)
			SetSquadSight(i, true);
		else
			SetSquadSight(i, false);

		if (EnemyUnit != none && FlankedTargets.Find('ObjectID', EnemyUnit.ObjectID) != INDEX_NONE)
			SetFlanked(i, true);
		else
			SetFlanked(i, false);  // Flanking was leaking inappropriately! 

	}

	RefreshShine();

	Movie.Pres.m_kTooltipMgr.ForceUpdateByPartialPath(string(MCPath));

	// force set selected index, since updating the visible enemies resets the state of the selected target
	//if (CurrentTargetIndex != -1)
	//	SetTargettedEnemy(CurrentTargetIndex, true);
}

function PlayEnemySightedSound()
{

}

simulated function UpdateVisibleEnemies(int HistoryIndex)
{

}

simulated function OnMouseEvent(int cmd, array<string> args)
{

}


defaultproperties
{
	MCName = "EnemyTargetsPreviewMC";

	Begin Object Class=X2AbilityTarget_Single Name=DefaultStandardAbilityTarget
		bAllowDestructibleObjects = TRUE
	End Object
	StandardAbilityTarget = DefaultStandardAbilityTarget

	Begin Object Class=X2Condition_Visibility Name=DefaultGameplayVisibilityCondition
		bRequireLOS=TRUE
		bRequireGameplayVisible=TRUE
		bAllowSquadsight=TRUE
	End Object	

	Begin Object Class=X2Condition_UnitProperty Name=DefaultAliveUnitPropertyCondition
		ExcludeDead=TRUE;
		ExcludeFriendlyToSource=TRUE;
	End Object

	LivingHostileGameplayVisibleFilter(0) = DefaultGameplayVisibilityCondition
	LivingHostileGameplayVisibleFilter(1) = DefaultAliveUnitPropertyCondition
}