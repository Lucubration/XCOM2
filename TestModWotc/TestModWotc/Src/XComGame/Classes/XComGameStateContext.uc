//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateContext.uc
//  AUTHOR:  Ryan McFall  --  11/20/2013
//  PURPOSE: This is the base class and interface for an XComGameStateContext related to an 
//           XComGameState. The context is responsible for containing the logic and domain
//           specific knowledge to convert game play requests into new game states, and game
//           states into visualization primitives for the visualization mgr.
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateContext extends object abstract native(Core) dependson(XComGameStateVisualizationMgr);

struct VisualizationActionMetadataInsertedInfo
{
	var XComGameStateContext_Ability InsertingAbiltyContext;
	var StateObjectReference TrackActorRef;
	var X2Action LastTrackActionInserted;
};

var privatewrite bool bReadOnly;                //TRUE indicates that this object is a read-only copy
var privatewrite bool bSendGameState;           //TRUE indicates that this game state should be sent to remote clients in MP
var privatewrite bool bNetworkAdded;            //TRUE indicates that this was sent from a remote client (i.e. do not "resend" this back)
var privatewrite bool bVisualizerUpdatesState;	//TRUE indicates that this game state will modify the game state system when it is visualized. This is very special case - ie. ragdolls moving units around
var privatewrite int  CurrentRandSeed;          //Seed is used for replay validation (later) and MP synchronization.
var privatewrite XComGameState AssociatedState; //Reference to the XComGameState we are a part of

//X-Com allows 'interrupts' to occur, which can alter the game state that the context generates. The below variables provide enough information to trace backwards through
//the game state history to find game states that were created from the same original context object.
//
// -1 is a sentinel value in the indices that indicate that a game state that is not interrupted/resuming from an interruption.
//
var privatewrite int HistoryIndexInterruptedBySelf;		//If this game state interrupted another one, this is the history index that triggered us as an interrupt.
var privatewrite EInterruptionStatus InterruptionStatus;//Provides information on whether the associated game state was an interrupted state or not
var privatewrite int InterruptionHistoryIndex;          //If this game state is resuming from an interruption, this index points back to the game state that are resuming from
var privatewrite int ResumeHistoryIndex;                //If this game state has been interrupted, this index points forward to the game state that will resume														

//This index provides information allowing the visualization mgr and other systems to identify "chains" of game states For instance, a move game state may be followed by a change in 
//concealment or the automatic activation of an ability. In that situation the states following the move (and resulting from it) would have a 'EventChainStartIndex' pointing to the move game state.
var privatewrite int EventChainStartIndex;		
var privatewrite bool bFirstEventInChain;	//Indicates that this game state is the first in its event chain
var privatewrite bool bLastEventInChain;	//Indicates that this game state is the last in its event chain

//Visualization sequencing controls
var privatewrite bool bVisualizationOrderIndependent; //If TRUE, marks this game state as able to start visualizing with no history index / sequencing restrictions. This is used for player
													  //directed movement and abilities where there are no side effects of the ability or interrupts, and thus the abilities should be visualized
													  //as quickly as the player can enter the commands.

var privatewrite bool bVisualizationFence;		  //Specifies that in order for this game state to be visualized all prior game states must have
												  //completed visualization
var privatewrite float VisualizationFenceTimeout; //This allows a timeout to be specified so that the fence will not block indefinitely if there is a 
												  //failure of some type. Ie. if a fence were accidentally inserted in between an interrupt state and its interrupter.

var privatewrite INT  VisualizationStartIndex;  //By default, game state visualization chains started when the game states immediately prior to them have finished visualization. This index lets
												//a game state manually control this sequencing. When the game state indicated by VisualizationOverrideIndex has been visualized, this game state will
												//be permitted to start its visualization. Using this index, for example, a set of game states could be set to visualize concurrently.

var privatewrite int DesiredVisualizationBlockIndex;    /// The desired history index the context should be visualized in. This will move it from its associated state's visualization
														/// to the DesiredVisualizationBlockIndex. Note: this is best used on states that are self contained - ie. are not interruptible.

enum SequencePlayTiming
{
	SPT_None,				// Play according to the standard scoring placement of this vis block
	SPT_AfterParallel,		// Play after the instigating event, in parallel with other visualizations following that event
	SPT_AfterSequential,	// Play after the instigating event, in sequence before other visualizations following that event
	SPT_BeforeParallel,		// Play at the same time as the instigating event, in parallel with that event
	SPT_BeforeSequential,	// Play before the instigating event, in sequence before that event begins
};

var privatewrite SequencePlayTiming AssociatedPlayTiming; // This will determine if the insertion is before the Begin (true) or after the End (false) of the vis block;
														  // and if the insertion will occur with reparenting (sequenced execution); else it will occur without reparenting (paralel execution)

var transient private bool bAddedFutureVisualizations; // Flag used during visualization building to determine whether 

var array< Delegate<BuildVisualizationDelegate> > PreBuildVisualizationFn; // Optional visualization functions, whose tracks precede the tracks added in ContextBuildVisualization
var array< Delegate<BuildVisualizationDelegate> > PostBuildVisualizationFn; // Optional visualization functions, whose tracks follow the tracks added in ContextBuildVisualization

var X2Action_MarkerTreeInsertBegin CachedBeginMarker;


delegate BuildVisualizationDelegate(XComGameState VisualizeGameState);

/// <summary>
/// Returns the index of the specified delegate by name in the PostBuildVisualizationFn array if it exists, returns -1 if it does not exist.
/// </summary>
native function int HasPostBuildVisualization(Delegate<BuildVisualizationDelegate> del);

//XComGameStateContext interface
//***************************************************
/// <summary>
/// Should return true if ContextBuildGameState can return a game state, false if not. Used internally and externally to determine whether a given context is
/// valid or not.
/// </summary>
function bool Validate(optional EInterruptionStatus InInterruptionStatus);

/// <summary>
/// Override in concrete classes to convert the InputContext into an XComGameState ( or XComGameStates). The method is responsible
/// for adding these game states to the history
/// </summary>
/// <param name="Depth">ContextBuildGameState can be called recursively ( for interrupts ). Depth is used to track the recursion depth</param>
function XComGameState ContextBuildGameState();

/// <summary>
/// Override in concrete classes to properly handle interruptions. The method should instantiate a new 'interrupted' context and return a game state that reflects 
/// being interrupted. 'Self' for this method is the context that is getting interrupted. 
///
/// Example:
/// A move action game state would set the location of the moving unit to be the interruption tile location.
///
/// NOTE: when the interruption completes, the system will try to resume the interrupted context. Building interruption game states should ensure that the
///       interruption state will not block / prevent resuming (ie. abilities should not apply their cost in an interrupted game state)
/// </summary>
function XComGameState ContextBuildInterruptedGameState(int InterruptStep, EInterruptionStatus InInterruptionStatus);

/// <summary>
/// Override in concrete classes to convert the ResultContext and AssociatedState into a set of visualization tracks
/// </summary>
protected function ContextBuildVisualization();


/// <summary>
/// Hook to build visualization for this entire frame
/// </summary>
function ContextBuildVisualizationFrame()
{
	local Delegate<BuildVisualizationDelegate> VisFunction;
	local XComGameStateContext ResumeContext;
	local XComGameState ResumeState;	
	local VisualizationActionMetadata InitData;	
	local XComGameStateVisualizationMgr VisualizationMgr;
	local X2Action_MarkerTreeInsertBegin BeginMarker;
	local X2Action_MarkerTreeInsertEnd EndMarker;
	local array<X2Action> Nodes;
	local X2Action ChildAction;
	local bool bAnyChildrenReparented;

	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	InitData.StateObjectRef.ObjectID = GetPrimaryObjectRef();

	//Create a tree insertion marker
//  	if( CachedBeginMarker != none )
//  	{
//  		BeginMarker = CachedBeginMarker;
//  		class'X2Action_MarkerTreeInsertBegin'.static.AddActionToVisualizationTree(BeginMarker, InitData, self);
//  		CachedBeginMarker = none;
//  	}
//  	else
//  	{
		BeginMarker = X2Action_MarkerTreeInsertBegin(class'X2Action_MarkerTreeInsertBegin'.static.AddToVisualizationTree(InitData, self));
//	}
	

	// only run Pre vis functions on contexts that arent resume contexts, since we run the pre vis functions on the interrupted context
	if (InterruptionHistoryIndex < 0)
	{
		// Run pre vis functions on this context and all its resume contexts
		ResumeContext = self;
		while (ResumeContext != none)
		{
			foreach ResumeContext.PreBuildVisualizationFn(VisFunction)
			{
				if (VisFunction != None)
				{
					VisFunction(ResumeContext.AssociatedState);
				}
			}
			ResumeState = ResumeContext.GetResumeState();
			ResumeContext = ResumeState == none ? none : ResumeState.GetContext();
		}
	}

	ContextBuildVisualization();

	// only run post vis functions on contexts that arent resume contexts, since we run the pre vis functions on the interrupted context
 	if (InterruptionHistoryIndex < 0)
 	{
		// Run post vis functions on this context and all its resume contexts
		ResumeContext = self;
		while (ResumeContext != none)
 		{
			foreach ResumeContext.PostBuildVisualizationFn(VisFunction)
			{
				if (VisFunction != None)
				{
					VisFunction(ResumeContext.AssociatedState);
				}
			}
			ResumeState = ResumeContext.GetResumeState();
			ResumeContext = ResumeState == none ? none : ResumeState.GetContext();
 		}
 	}

	//New visualization sub trees should always begin and end with the appropriate Tree Insert actions. The begin was created at the top of this method, if it has any 
	//children here then we know that the associated game state context added some visualization. Search to see if it added a custom end marker - leave it if so, and if not then
	//create an end marker here. If no visualization was created then destroy our begin action and NULL out the build tree.	
	if (BeginMarker.ChildActions.Length > 0)
	{
		//See if the context visualization build function already created an end node
		VisualizationMgr.GetNodesOfType(VisualizationMgr.BuildVisTree, class'X2Action_MarkerTreeInsertEnd', Nodes);
		if(Nodes.Length == 0)
		{
			VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, Nodes);
			class'X2Action_MarkerTreeInsertEnd'.static.AddToVisualizationTree(InitData, self, false, none, Nodes);
		}
		else
		{
			`assert(Nodes.Length == 1); // shouldn't ever have multiple End nodes in the build tree
			EndMarker = X2Action_MarkerTreeInsertEnd(Nodes[0]);

			// if the end node has any children, the children need to be re-parented to the end node's parents 
			// and the end node needs to be re-parented to all leaf nodes
			if( EndMarker.ChildActions.Length > 0 )
			{
				bAnyChildrenReparented = false;

				// re-parent the children
				foreach EndMarker.ChildActions(ChildAction)
				{
					// ... except the interrupt end marker should never be re-parented
					if( X2Action_MarkerInterruptEnd(ChildAction) == none )
					{
						VisualizationMgr.DisconnectAction(ChildAction);
						VisualizationMgr.ConnectAction(ChildAction, VisualizationMgr.BuildVisTree, false, none, EndMarker.ParentActions);
						bAnyChildrenReparented = true;
					}
				}

				// re-parent the End node
				if( bAnyChildrenReparented )
				{
					VisualizationMgr.DisconnectAction(EndMarker);
					VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, Nodes);
					VisualizationMgr.ConnectAction(EndMarker, VisualizationMgr.BuildVisTree, false, none, Nodes);
				}
			}
		}
	}
	else
	{
		VisualizationMgr.DestroyAction(BeginMarker);
		VisualizationMgr.BuildVisTree = none;		
		CachedBeginMarker = BeginMarker;
	}
}

function SetAssociatedPlayTiming(SequencePlayTiming InAssociatedPlayTiming)
{
	AssociatedPlayTiming = InAssociatedPlayTiming;
}

native function int GetDepthOfStateInInterruptOrParentChain(XComGameState SearchState);

// returns true if successful
function bool MergeRelativeToAssociatedVisBlock(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisualizationMgr;
	local array<X2Action> Nodes;
	local X2Action CurrentNode, BestNode;
	local int ParentStateDepth, BestDepth;
	
	if( AssociatedPlayTiming != SPT_None )
	{
		VisualizationMgr = `XCOMVISUALIZATIONMGR;
		VisualizationMgr.GetNodesOfType(VisualizationMgr.VisualizationTree, 
			(AssociatedPlayTiming == SPT_BeforeParallel || AssociatedPlayTiming == SPT_BeforeSequential) 
										? class'X2Action_MarkerTreeInsertBegin' 
										: class'X2Action_MarkerTreeInsertEnd', 
										Nodes);

		// search through the marker nodes to find the one closest to this GameState's Parent chain
		foreach Nodes(CurrentNode)
		{
			ParentStateDepth = GetDepthOfStateInInterruptOrParentChain(CurrentNode.StateChangeContext.AssociatedState);

			if ( ParentStateDepth >= 0 && (BestNode == none || ParentStateDepth < BestDepth)) //Standard matching logic that will work for the first in a sequence caused by the same event				  
			{
				BestNode = CurrentNode;
				BestDepth = ParentStateDepth;
			}
			else if (CurrentNode.StateChangeContext.AssociatedPlayTiming != SPT_None && 
					 ((AssociatedState.ParentGameState == none) || (CurrentNode.StateChangeContext.AssociatedState.ParentGameState == AssociatedState.ParentGameState)) &&
				     (CurrentNode.StateChangeContext.AssociatedState.HistoryIndex < AssociatedState.HistoryIndex) )//Handles ordering within sequential nodes caused by the same event
			{
				//If the current node's history frame is later, use it. Keeps the nodes running in order.
				if (BestNode == none || BestNode.StateChangeContext.AssociatedState.HistoryIndex < CurrentNode.StateChangeContext.AssociatedState.HistoryIndex)
				{
					BestNode = CurrentNode;
					BestDepth = ParentStateDepth;
				}				
			}
		}

		// found either the begin or end node we're interested in
		if( BestNode != none )
		{
			switch( AssociatedPlayTiming )
			{
			case SPT_BeforeParallel:
				if( BestNode == VisualizationTree )
				{
					VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, BestNode);
				}
				else
				{
				VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, None, BestNode.ParentActions);
				}
				break;
			case SPT_BeforeSequential:
				//Find the X2Action_MarkerTreeInsertEnd within the BuildTree we are trying to merge
				Nodes.Length = 0;
				VisualizationMgr.GetNodesOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd', Nodes);
				if (Nodes.Length > 0)
				{
					VisualizationMgr.InsertSubtree(BuildTree, Nodes[0], BestNode.ParentActions[0]);					
				}
				else
				{
					VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, true, None, BestNode.ParentActions);
				}
				break;
			case SPT_AfterParallel:
				VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, BestNode);
				break;
			case SPT_AfterSequential:
				//Find the X2Action_MarkerTreeInsertEnd within the BuildTree we are trying to merge
				Nodes.Length = 0;
				VisualizationMgr.GetNodesOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd', Nodes);
				if (Nodes.Length > 0)
				{
					VisualizationMgr.InsertSubtree(BuildTree, Nodes[0], BestNode);
				}
				else
				{
					//Degenerate case, but let it visualize anyways
					VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, true, BestNode);
				}
				break;
			}

			return true;
		}
	}

	return false;
}

/// <summary>
/// This method allows for context specific merging of <BuildVisTree> into the main visualization tree used by the visualization mgr. The default behavior defined here should handle
/// all but the most complicated visualization sequences.
/// </summary>
function MergeIntoVisualizationTree(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisualizationMgr;
	local X2Action DesiredParent;
	local X2Action_MarkerTreeInsertEnd EndOfBuildTree;
	local X2Action_MarkerInterruptBegin BeginningOfInterrupt;
	local X2Action_MarkerInterruptEnd EndOfInterrupt;
	local array<X2Action> AdditionalParentInterruptMarkers;
	local array<X2Action> TreeEndNodes;
	local int Index;
	local VisualizationActionMetadata MetaData;

	VisualizationMgr = `XCOMVISUALIZATIONMGR;	

	if (BuildTree != none)
	{
		//If we were an interrupt, we insert ourselves into the tree - otherwise, let the system just append the tree as normal
		if (VisualizationTree != none)
		{
			if( !MergeRelativeToAssociatedVisBlock(BuildTree, VisualizationTree) )
			{
				//Find the parent node that this tree should be parented to. Don't need to check this for none since it cannot be if VisualizationTree is non null.
				DesiredParent = VisualizationMgr.GetBestFitNode(BuildTree, VisualizationTree);

				if( bVisualizationOrderIndependent ) //If this context is order independent, attach it to the current visualization tree root, which will start it right away / in parallel with other visualizations
				{
					VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, VisualizationTree);
				}
				else if( DesiredParent.ChildActions.Length == 0 ) //If desired parent does not have children, simply attach the new tree to the best fit node
				{
					VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, DesiredParent);
				}
				else //If desired parent already has children then we need to insert into the tree.
				{
					EndOfInterrupt = X2Action_MarkerInterruptEnd(DesiredParent.ChildActions[0]);//If this is an interrupt, insert between the markers
					if( EndOfInterrupt != none )
					{
						//Find the X2Action_MarkerTreeInsertEnd within the BuildTree we are trying to merge
						VisualizationMgr.GetNodesOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd', TreeEndNodes);

						//Show a red screen if we can't find a tree insert end marker, or we find too many. Every BuildTree should have exactly one of these.
						if( TreeEndNodes.Length != 1 )
						{
							`redscreen("MergeIntoVisualizationTree found an incorrect number (" $ TreeEndNodes.Length $ ") of X2Action_MarkerTreeInsertEnd nodes for context" @ self $ ". Added by ContextBuildVisualizationFrame, there should only be one!");
							//Perform a "default" connection as a fall back
							VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, DesiredParent);
						}
						else
						{
							//Cache some of the nodes we will be working with						
							EndOfBuildTree = X2Action_MarkerTreeInsertEnd(TreeEndNodes[0]);

							// We have all the markers we need, now insert BuildTree into the visualization tree 
							//=================================================================================

							//In some cases, interrupt end markers will be connect to others. Preserve this connection since it will be severed below in DisconnectAction
							for( Index = 0; Index < EndOfInterrupt.ParentActions.Length; ++Index )
							{
								if( EndOfInterrupt.ParentActions[Index].IsA('X2Action_MarkerInterruptEnd') )
								{
									AdditionalParentInterruptMarkers.AddItem(EndOfInterrupt.ParentActions[Index]);
									break;
								}
							}

							//Disconnect the interrupt end marker, we are going to insert BuildTree between it and its parent (interrupt begin marker)
							VisualizationMgr.DisconnectAction(EndOfInterrupt);

							//Connect BuildTree to the desired parent
							//If this visualization sequence is reaction fire, we want it to go simultaneously with other reaction fire. Otherwise, interrupts are processed sequentially.
							if( class'XComTacticalGRI'.static.GetReactionFireSequencer().IsReactionFire(XComGameStateContext_Ability(self)) )
							{
								VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, EndOfInterrupt.BeginNode);
							}
							else
							{
								VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, DesiredParent);
							}


							//This logic will trip if BuildTree is the first interrupt to be added between a BeginningOfInterrupt and EndOfInterrupt. It will determine whether
							//the interruption was terminal and prune the tree if necessary
							BeginningOfInterrupt = X2Action_MarkerInterruptBegin(DesiredParent);
							if( BeginningOfInterrupt != none && EndOfInterrupt.ChildActions.Length > 0 )
							{
								//Determine whether the interrupt was terminal ( ie. didn't resume ).							
								if( BeginningOfInterrupt.StateChangeContext.ResumeHistoryIndex == -1 && BeginningOfInterrupt.StateChangeContext.InterruptionStatus == eInterruptionStatus_Interrupt )
								{
									//Prune the tree beyond interrupt markers if it was terminal									
									VisualizationMgr.DestroySubtree(EndOfInterrupt, false);

									//This will destroy the insert end marker node, so add another one									
									MetaData = BeginningOfInterrupt.ParentActions[0].Metadata;
									class'X2Action_MarkerTreeInsertEnd'.static.AddToVisualizationTree(MetaData, self, false, EndOfInterrupt);
								}
							}

							//Connect EndOfInterrupt to the end of BuildTree - completing the insertion
							VisualizationMgr.ConnectAction(EndOfInterrupt, VisualizationTree, false, EndOfBuildTree, AdditionalParentInterruptMarkers);
							//=================================================================================
							//
						}
					}
					else
					{
						//Not an interrupt. May be a visualization sequence that wants to run in parallel with another
						VisualizationMgr.ConnectAction(BuildTree, VisualizationTree, false, DesiredParent);
					}
				}
			}
		}
		else //If there is no visualization tree to merge into, we become the new tree
		{
			VisualizationTree = BuildTree;
		}
	}
}

/// <summary>
/// Used to set internal state variables for interruption. Called from InterruptionPostProcess
/// </summary>
function SetInterruptionIndex(bool bSetResumeHistoryIndex, int HistoryIndex)
{
	`assert(InterruptionStatus != eInterruptionStatus_None);

	if( bSetResumeHistoryIndex )
	{
		if( InterruptionStatus != eInterruptionStatus_Resume ) //Resume states never have a ResumeHistoryIndex set
		{
			ResumeHistoryIndex = HistoryIndex;  //Index in the history that holds the state that is resuming from where we were interrupted
		}
	}
	else			
	{
		InterruptionHistoryIndex = HistoryIndex; //Index in the history that holds the state that was interrupted, which we are resuming		
	}
}

/// <summary>
/// Sets whether this is an interrupted or a resume state context
/// </summary>
function SetInterruptionStatus(EInterruptionStatus Status)
{
	InterruptionStatus = Status;
}

function SetSendGameState(bool bSend)
{
	bSendGameState = bSend;
}

/// <summary>
/// Permits gameplay to mark this context as being order independent with its visualization
/// </summary>
native final function SetVisualizationOrderIndependent(bool bSetVisualizationOrderIndependent);

/// <summary>
/// Allows this game state to be visualized concurrently with the specified history index
/// </summary>
native final function SetVisualizationStartIndex(int SetVisualizationStartIndex);

/// <summary>
/// Marks this game state object as a visualization fence. These game states do not start their visualization until all prior game 
/// states have been visualized, and inhibit all subsequent game states from being visualized until they have started their visualization
///
/// <param name="Timeout">Sets a maximum time for the fence to wait. A setting of 0 waits indefinitely</param>
/// </summary>
native final function SetVisualizationFence(bool bSetVisualizationFence, float Timeout = 20.0f);

/// <summary>
/// Sets the currently used random number seed on the Context from the Engine.
/// </summary>
native function SetContextRandSeedFromEngine();

/// <summary>
/// Sets the Engine's random number seed to the one specified from this context.
/// </summary>
native function SetEngineRandSeedFromContext();


/// <summary>
/// Override to return TRUE for the context object to show that the associated state is a start state
/// </summary>
event bool IsStartState()
{
	return false;
}


native function bool NativeIsStartState();

event int GetStartStateOffset()
{
	return 0;
}

/// <summary>
/// Returns the first game state in the event chain that this game state context is a part of.
/// </summary>
native function XComGameState GetFirstStateInEventChain();

/// <summary>
/// Returns the next game state in the event chain that this game state context is a part of.
/// </summary>
native function XComGameState GetNextStateInEventChain();

/// <summary>
/// Returns the last game state in the event chain that this game state context is a part of.
/// </summary>
native function XComGameState GetLastStateInEventChain(bool AllowNone = false);

/// <summary>
/// Seaches backwards in the history and returns the first state with an interruption status of eInterruptionStatus_Interrupt
/// </summary>
native function XComGameState GetInterruptedState();

/// <summary>
/// If this context is part of an interruption sequence, returns the game state that initiated the interruption.
/// For example, if a unit moves, and is then overwatched, and then killed, this function will return
/// the initial move game state for all three of the above contexts.
/// If this context is not interrupted, returns the associated game state.
/// </summary>
native function XComGameState GetFirstStateInInterruptChain();

/// <summary>
/// If this context is part of an interruption sequence, returns the game state that finished the interrupted sequence.
/// For example, if a unit moves, and is then overwatched, and then killed, this function will return
/// the move state for all three of the above contexts.
/// If this context is not interrupted, returns the associated game state.
/// </summary>
native function XComGameState GetLastStateInInterruptChain();

/// <summary>
/// If this context has a resume index, returns the gamestate for it, or null if it doesn't have one
/// </summary>
native function XComGameState GetResumeState();

function VisualizerReplaySyncSetState(XComGameState InAssociatedState)
{	
	AssociatedState = InAssociatedState;
}

/// <summary>
/// Returns a short description of this context object
/// </summary>
event string SummaryString();

/// <summary>
/// Returns a string representation of this object.
/// </summary>
native function string ToString() const;

/// <summary>
/// Returns a long description of information about the context. 
/// </summary>
function string VerboseDebugString()
{
	return ToStringT3D();
}

// Debug-only function used in X2DebugHistory screen.
function bool HasAssociatedObjectID(int ID)
{
	return (AssociatedState.GetGameStateForObjectID(ID) != none);
}
//***************************************************

/// <summary>
/// Builds a new meta data object that can be associated with a game state. XComGameStateContext objects provide context for the object state changes 
/// contained in an XComGameState. See the description in XComGameStateContext for more detail.
/// </summary>
static function XComGameStateContext CreateXComGameStateContext()
{
	local XComGameStateContext NewContext;

	NewContext = new default.Class;
	NewContext.bReadOnly = false;

	return NewContext;
}

/// <summary>
/// This static method encapsulates the logic that must take place following an interruption - letting the interrupted and resumed states know about 
/// each other. Must be called after both states have been added to the history.
/// </summary>
static function InterruptionPostProcess(XComGameState InterruptedState, XComGameState ResumedState)
{	
	local int NextHistoryIndex;

	//None of this logic needs to be done for interrupt states that don't resume
	if( ResumedState != none )
	{
		//Make sure the states being input to this method are what we expect
		`assert(InterruptedState != none);
		`assert(InterruptedState.HistoryIndex > -1);
		`assert(InterruptedState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt);				
		`assert(ResumedState != none);
		`assert(ResumedState.HistoryIndex == -1);		
		`assert(ResumedState.GetContext().InterruptionStatus != eInterruptionStatus_None);		

		//At the point this method should be called, the resume state has not yet been added to the history but it should be the next state added.
		NextHistoryIndex = `XCOMHISTORY.GetNumGameStates();
		InterruptedState.GetContext().SetInterruptionIndex(true, NextHistoryIndex);
		ResumedState.GetContext().SetInterruptionIndex(false, InterruptedState.HistoryIndex);		
	}
}

function SetHistoryIndexInterruptedBySelf(int HistoryIndex)
{
	HistoryIndexInterruptedBySelf = HistoryIndex;
}

function OnSubmittedToReplay(XComGameState SubmittedGameState);

/// <summary>
/// This sets what history index the context should be visualized in. This will move it from its associated state's visualization
/// to the given history index. If the given HistoryIndex is part of a context that doesn't get visualized then this context will
/// still visualize during its associated states history index.
/// </summary>
function SetDesiredVisualizationBlockIndex(int HistoryIndex)
{
	DesiredVisualizationBlockIndex = HistoryIndex;
}

/// <summary>
/// Setting this flag indicates that a this game state's visualization will have game state side effects. This should be extraordinarily rare. Rag dolls, for example, may 
/// alter the location of a unit.
/// </summary>
function SetVisualizerUpdatesState(bool bSetting)
{
	bVisualizerUpdatesState = bSetting;
}

function int GetPrimaryObjectRef()
{
	return -1;
}

defaultproperties
{
	InterruptionHistoryIndex = -1
	ResumeHistoryIndex = -1
	EventChainStartIndex = -1
	bVisualizationOrderIndependent = false;	
	VisualizationStartIndex = -1
	VisualizationFenceTimeout = 20.0 // Timeout of 20 seconds by default
	DesiredVisualizationBlockIndex=-1
	bAddedFutureVisualizations = false
	HistoryIndexInterruptedBySelf = -1
	AssociatedPlayTiming = SPT_None
}