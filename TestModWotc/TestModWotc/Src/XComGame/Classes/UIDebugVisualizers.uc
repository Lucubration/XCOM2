//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIDebugVisualizers
//  AUTHOR:  Ryan McFall
//
//  PURPOSE: Provides a mechanism for visualizing the tree(s) used by the visualization mgr
//			 to organize and run the actions that visually depict changes to the game state.
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIDebugVisualizers extends UIScreen;

var UIPanel		m_kContainer;
var UIButton	m_kClearHangsButton;
var UICheckbox  m_HideEmptyInterruptsCheckBox;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen( InitController, InitMovie, InitName );
	
	m_kContainer = Spawn(class'UIPanel', self).InitPanel();
	m_kContainer.SetPosition(0, 0);

	// Send to Log Check Box
	//InitCheckbox(name InitName, optional string initText, optional bool bInitChecked, optional delegate<OnChangedCallback> statusChangedDelegate, optional bool bInitReadOnly)
	m_HideEmptyInterruptsCheckBox = Spawn(class'UICheckBox', self).InitCheckbox('', "Hide Empty Interrupt Markers", true, OnCheckboxChange);
	m_HideEmptyInterruptsCheckBox.SetPosition(600, 3);

	// Close Button
	m_kClearHangsButton = Spawn(class'UIButton', self);
	m_kClearHangsButton.InitButton('clearHangsButton', "Clear Hangs", OnClearButtonClicked, eUIButtonStyle_HOTLINK_BUTTON);
	m_kClearHangsButton.SetPosition(20, 3);

	AddHUDOverlayActor();
}

simulated function OnClearButtonClicked(UIButton button)
{
	`XCOMVISUALIZATIONMGR.DebugClearHangs();
}

simulated function OnCheckboxChange(UICheckbox checkboxControl)
{
	`XCOMVISUALIZATIONMGR.bHideEmptyInterruptMarkers = checkboxControl.bChecked;	
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_ARROW_UP :
			`XCOMVISUALIZATIONMGR.DebugTreeOffsetY = Min(`XCOMVISUALIZATIONMGR.DebugTreeOffsetY + 100, 0);
			return true;
		case class'UIUtilities_Input'.const.FXS_ARROW_DOWN :
			`XCOMVISUALIZATIONMGR.DebugTreeOffsetY -= 100;
			return true;
		case class'UIUtilities_Input'.const.FXS_ARROW_LEFT :			
			`XCOMVISUALIZATIONMGR.DebugTreeOffsetX = Min(`XCOMVISUALIZATIONMGR.DebugTreeOffsetX + 100, 0);
			return true;
		case class'UIUtilities_Input'.const.FXS_ARROW_RIGHT :
			`XCOMVISUALIZATIONMGR.DebugTreeOffsetX -= 100;
			return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}

simulated public function OnUCancel()
{

}

simulated public function OnLMouseDown()
{

}

simulated function OnRemoved()
{
	super.OnRemoved();
	RemoveHUDOverlayActor();
}

simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, vector vCameraPosition, vector vCameraDir)
{
	`XCOMVISUALIZATIONMGR.DrawDebugLabel(kCanvas);
}

//==============================================================================
//		DEFAULTS:
//==============================================================================

simulated function OnReceiveFocus()
{
	Show();
}

simulated function OnLoseFocus()
{
	Hide();
}

defaultproperties
{	
}
