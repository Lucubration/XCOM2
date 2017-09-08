//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor.
//-----------------------------------------------------------
class X2Action_HideUIUnitFlag extends X2Action;

var bool bHideUIUnitFlag;

//------------------------------------------------------------------------------------------------

simulated state Executing
{
Begin:
	Unit.m_bHideUIUnitFlag = bHideUIUnitFlag;

	CompleteAction();
}