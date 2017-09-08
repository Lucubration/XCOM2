//-----------------------------------------------------------
// Marker nodes are used to help guide placement for other nodes in the visualization tree
//-----------------------------------------------------------
class X2Action_MarkerInterruptEnd extends X2Action native(Core);

var X2Action_MarkerInterruptBegin BeginNode;
var int StackDepthWaitCount;

event bool BlocksAbilityActivation()
{
	return false;
}

//In some cases, interrupts may be caused by game mechanics that don't have a visualization. In these situations, just skip over the interrupt processing
function bool EmptyInterrupt()
{
	return ParentActions.Length == 1 && BeginNode == ParentActions[0];
}

function MarkEndInterrupted()
{
	local int Index;

	for (Index = 0; Index < BeginNode.ParentActions.Length; ++Index)
	{
		BeginNode.ParentActions[Index].ResumeFromInterrupt(CurrentHistoryIndex);
	}
}

function string SummaryString()
{
	local XComGameStateContext_Ability AbilityContext;

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
	if (AbilityContext != none)
	{
		return "InterruptEnd Step(" @  AbilityContext.ResultContext.InterruptionStep @ ")";
	}

	return "InterruptEnd Step( 0 )";
}

function CompleteAction()
{
	super.CompleteAction();

	VisualizationMgr.PopInterruptionStackElement();

	MarkEndInterrupted();
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{	
	function bool AtCorrectInterruptStackDepth()
	{
		return BeginNode.InterruptionStackDepth == VisualizationMgr.InterruptionStack.Length;		
	}

Begin:
	if (!AtCorrectInterruptStackDepth())
	{
		`RedScreen("X2Action_MarkerInterruptEnd tried to execute out of order! Trace\n" @ GetScriptTrace() @ "\n");
		while (!AtCorrectInterruptStackDepth() && StackDepthWaitCount < 100 ) //Limit the length of time we can be stuck in this state
		{
			Sleep(0.1f);
			++StackDepthWaitCount;
		}
	}

	CompleteAction();
}

defaultproperties
{	
}

