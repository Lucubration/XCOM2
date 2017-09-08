//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_PlayAnimationOnMatineePawn extends X2Action_PlayAnimation;

var array<string> RequiredMatineeNames; // If set, the animation will only play if the matinee matches this name

function Init()
{
	super.Init();

	if (!IsRequiredMatineePlaying())
	{
		bSkipAnimation = true;
	}
	else
	{
		ReplaceUnitPawnWithMatineePawn();
	}
}

function bool IsRequiredMatineePlaying()
{
	local X2Action ParentAction;
	local X2Action_RevealAIBegin RevealAction;

	if (RequiredMatineeNames.Length > 0)
	{
		foreach ParentActions(ParentAction)
		{
			RevealAction = X2Action_RevealAIBegin(ParentAction);
			if (RevealAction == none || RevealAction.Matinees.Length == 0 || RequiredMatineeNames.Find(RevealAction.Matinees[0].ObjComment) == INDEX_NONE)
			{
				return false;
			}
		}
	}

	return true;
}

function ReplaceUnitPawnWithMatineePawn()
{
	local XComGameStateVisualizationMgr VisMgr;
	local array<X2Action> Nodes; //Node storage
	local X2Action ActionNode;
	local X2Action_PlayMatinee MatineeAction;
	local XComUnitPawn MatineePawn;

	VisMgr = `XCOMVISUALIZATIONMGR;
	VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_PlayMatinee', Nodes);
	foreach Nodes(ActionNode)
	{
		MatineeAction = X2Action_PlayMatinee(ActionNode);
		if (MatineeAction != none)
		{
			MatineePawn = MatineeAction.FindPawnForUnitInMatinee(Metadata.StateObjectRef);
			if (MatineePawn != None)
			{
				// Replace the game pawn with the matinee pawn for this animation
				UnitPawn = MatineePawn;
				break;
			}
		}
	}
}