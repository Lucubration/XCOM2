//-----------------------------------------------------------
// Marker nodes are used to help guide placement for other nodes in the visualization tree
//-----------------------------------------------------------
class X2Action_MarkerInterruptBegin extends X2Action native(Core);

var X2Action_MarkerInterruptEnd EndNode;
var int InterruptionStackDepth;

event bool BlocksAbilityActivation()
{
	return false;
}

//In some cases, interrupts may be caused by game mechanics that don't have a visualization. In these situations, just skip over the interrupt processing
function bool EmptyInterrupt()
{
	return ChildActions.Length == 1 && EndNode == ChildActions[0];
}

//Important note here - AllowEvent in some cases will be used to start up an action. In this situation Init() will not have run, so cached values
//from Init cannot be used.
function bool AllowEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
		
	AbilityContext = XComGameStateContext_Ability(EventData);
	if (AbilityContext != none && EventID == 'Visualizer_Interrupt')
	{		
		return AbilityContext == StateChangeContext; //Verify that the interrupt step matches
	}

	return super.AllowEvent(EventData, EventSource, GameState, EventID, CallbackData);
}

function MarkBeginInterrupted()
{
	local int Index;

	for (Index = 0; Index < ParentActions.Length; ++Index)
	{
		ParentActions[Index].BeginInterruption();
	}
}

function string SummaryString()
{
	local XComGameStateContext_Ability AbilityContext;

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
	if (AbilityContext != none)
	{
		return "InterruptBegin Step(" @  AbilityContext.ResultContext.InterruptionStep @ ")";
	}

	return "InterruptBegin Step( 0 )";
}

function CompleteAction()
{	
	super.CompleteAction();

	VisualizationMgr.PushInterruptionStackElement(StateChangeContext);
	InterruptionStackDepth = VisualizationMgr.InterruptionStack.Length;

	//Set interrupted flag on the actions being interrupted
	MarkBeginInterrupted();
}


//------------------------------------------------------------------------------------------------
simulated state Executing
{	
Begin:
	CompleteAction();
}

defaultproperties
{	
	InputEventIDs.Add( "Visualizer_Interrupt" )
}

