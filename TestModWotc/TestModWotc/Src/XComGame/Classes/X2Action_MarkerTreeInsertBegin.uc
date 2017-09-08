//-----------------------------------------------------------
// Marker nodes are used to help guide placement for other nodes in the visualization tree
//-----------------------------------------------------------
class X2Action_MarkerTreeInsertBegin extends X2Action native(Core);

event bool BlocksAbilityActivation()
{
	return false;
}

event int ScoreNodeForTreePlacement(X2Action PossibleParent)
{
	local int Score;
	local X2Action_MarkerInterruptEnd InterruptEnd;
	local X2Action_MarkerInterruptBegin InterruptBegin;
	local XComGameState InterruptionStart;	
	local XComGameState InterruptChainEnd;
	local XComGameState PossibleParentInterruptChainStart;
	local XComGameState PossibleParentAssociatedState;
	local XComGameStateContext_Ability PossibleParentAbilityContext;
	local XComGameStateContext_Ability ThisAbilityContext;

	//If we are associated with an interrupt, see if we have an easy match where this subtree is the first interrupt in an interrupt block
	InterruptBegin = X2Action_MarkerInterruptBegin(PossibleParent);
	if (InterruptBegin != none)
	{		
		`assert(InterruptBegin.EndNode != none);

		//Fetch the start of the event chain that is associated with this interrupt. We do this because while vis sequences typically visualize the 
		//final state in an event chain, HistoryIndexInterruptedBySelf is tied to the actual history index of the interrupt. In most cases, this will
		//be the first state in the chain (PossibleParentEventChainStart), but for some sequences like movement based interrupts it will be something 
		//in between ( PossibleParentAssociatedState)
		PossibleParentInterruptChainStart = PossibleParent.StateChangeContext.GetFirstStateInInterruptChain();
		PossibleParentAssociatedState = PossibleParent.StateChangeContext.AssociatedState;

		if ( PossibleParentAssociatedState == StateChangeContext.AssociatedState.ParentGameState )
		{
			//If the history frame we interrupted matches the one associated with this interrupt begin marker, simple match
			Score += 200;
		}	
		else if (PossibleParent.ChildActions.Length > 0 && X2Action_MarkerInterruptEnd(PossibleParent.ChildActions[0]) != none)
		{
			//If this is an empty interrupt subtree, it is possible that the first interrupt which defines HistoryIndexInterruptedBySelf doesn't have any visualization. See if we fit in here.
			InterruptionStart = StateChangeContext.GetInterruptedState();
			InterruptChainEnd = InterruptionStart != none ? (InterruptionStart.GetContext().GetLastStateInInterruptChain()) : none;
			if (InterruptionStart != none && //There is an interruption in our event chain
				(PossibleParentInterruptChainStart == InterruptionStart || PossibleParentAssociatedState == InterruptionStart)  && //The interrupt begin we're evaluating matches our event chain
				(InterruptChainEnd == none || InterruptionStart == InterruptChainEnd || InterruptChainEnd.HistoryIndex >= StateChangeContext.AssociatedState.HistoryIndex) ) //The interrupt chain was terminal, OR we really happened within the chain
			{
				//We are an interrupt in this interrupt chain, insert between the tree insert and the interrupt end
				Score += 100;
			}
		}
	}
	else if (X2Action_MarkerTreeInsertBegin(PossibleParent) != none)
	{
		if (StateChangeContext.VisualizationStartIndex > -1 &&
			PossibleParent.StateChangeContext.AssociatedState.HistoryIndex == StateChangeContext.VisualizationStartIndex)
		{
			//The  context says that it wants to visualize simultaneously with another. High score if we have a match.
			//Do a sanity check to make sure this isn't trying to ask two abilities on the same unit to visualize at the same time - as this would cause severe animation issues potentially.
			PossibleParentAbilityContext = XComGameStateContext_Ability(PossibleParent.StateChangeContext);
			ThisAbilityContext = XComGameStateContext_Ability(StateChangeContext);
			if (PossibleParentAbilityContext == none || ThisAbilityContext == none ||
				ThisAbilityContext.InputContext.SourceObject.ObjectID != PossibleParentAbilityContext.InputContext.SourceObject.ObjectID)
			{
				Score += 100;
			}
		}
	}
	else if(X2Action_MarkerTreeInsertEnd(PossibleParent) != none)
	{
		//See if the tree marker we're considering is part of a multiple-interrupt sequence ( will always terminate in InterruptEnd -> TreeInsertEnd pair as the tree is being built)
		InterruptEnd = PossibleParent.ChildActions.Length > 0 ? X2Action_MarkerInterruptEnd(PossibleParent.ChildActions[0]) : none;
		if (InterruptEnd != none)
		{
			InterruptionStart = StateChangeContext.GetInterruptedState();
			if (InterruptionStart != none && InterruptEnd.StateChangeContext.AssociatedState == InterruptionStart)
			{
				//We are an interrupt in this interrupt chain, insert between the tree insert and the interrupt end
				Score += 100;
			}
		}
		else
		{	
			//Score more for end nodes that are close in proximity to our associated history frame. The max score is chosen to prefer the interrupt pairings above in cases that are close
			Score += Max(80 - Abs(StateChangeContext.AssociatedState.HistoryIndex - PossibleParent.StateChangeContext.AssociatedState.HistoryIndex), 10);
		}
	}

	return Score;
}

function string SummaryString()
{
	return "SubTreeBegin Frame(" @  StateChangeContext.AssociatedState.HistoryIndex @ ")";
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{	
Begin:
	CompleteAction();
}

defaultproperties
{	
}

