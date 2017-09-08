//---------------------------------------------------------------------------------------
//  FILE:    XComGameStateVisualizationMgr.uc
//  AUTHOR:  Ryan McFall  --  10/9/2013
//  PURPOSE: This object is responsible for taking an XComGameState delta and visually
//           representing the state change ( unit moving, shooting, etc. )
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateVisualizationMgr extends Actor native(Core) dependson(XComGameState);

//Holds key information relating to an X2Action.
struct native VisualizationActionMetadata
{		
	// Metadata fields
	// Should be set prior to using VisualizationActionMetadata as an argument to creating an X2Action
	var XComGameState_BaseObject StateObject_OldState;  //A copy of the state object at the beginning of the action being visualized
	var XComGameState_BaseObject StateObject_NewState;  //A copy of the state object at the end of the action being visualized		
	var Actor VisualizeActor;							//A visualizer to associate with the action
	var init array<Actor> AdditionalVisualizeActors;	//A list of additional visualization actors the associated X2Action is controlling
	var StateObjectReference StateObjectRef;			//The state object to associate

	// Set when this meta data is used while adding an action. Convenience field since most of the time users want to attach / create actions in a linear sequence.
	var X2Action LastActionAdded;

	structcpptext
	{	
	UBOOL IsAssociatedWithVisualizer(const class AActor* Visualizer)
	{
		if (VisualizeActor == Visualizer)
		{
			return TRUE;
		}
		else if (AdditionalVisualizeActors.Num() && AdditionalVisualizeActors.FindItemIndex(const_cast<AActor*>(Visualizer)) != INDEX_NONE)
		{
			return TRUE;
		}

		return FALSE;
	}
	}
};

struct native SloMoControlStruct
{
	var Actor Visualizer;
	var X2VisualizerInterface VisualizerInterface;
	var float SlomoFactor;
};

struct native InterruptionStackElement
{
	//A list of visualizer controls that indicate a custom slo mo factor to use ( by default all visualizers are slowed during an interrupt )
	var init array<SloMoControlStruct> Controls; 		
	var XComGameStateContext InterruptContext;
};

enum EVisualizerCustomCommand
{
	eCommandNone,
	eCommandReplaySkip,
	eCommandLoadGame,
};

struct native TreeDrawNode
{	
	//Filled out during exploration of the tree
	var int NodeIndex; //Index into DrawNodes of this node
	var init array<int> ParentNodeIndices; //Index in DrawNodes of this node's parents
	var X2Action TreeNode;
	var int Depth;	
	var int SubtreeIndex;

	//Filled out after the topology of the tree is known and a position can be assigned
	var Vector Location;

	structcpptext
	{
	FTreeDrawNode() :
	NodeIndex(0),
	TreeNode(NULL),
	Depth(0)
	{		
	}

	FTreeDrawNode(EEventParm)
	{
		appMemzero(this, sizeof(FTreeDrawNode));
	}

	FORCEINLINE UBOOL operator==(const FTreeDrawNode &Other) const
	{
		return Other.TreeNode == TreeNode;
	}

	FORCEINLINE UBOOL operator!=(const FTreeDrawNode& Other) const
	{
		return Other.TreeNode != TreeNode;
	}
	}
};

struct native SubtreeDrawNode
{
	var int SubtreeOffsetX; //Value 0 -> N where the value is > 0 if we are drawn at the same Y value as another subtree ( ie. happening simultaneously )
	var int Width;			//Width in nodes
	var int Height;			//Height in nodes
	var int MinDepth;
	var int MaxDepth;
	var int StartNodeIndex;
	var int EndNodeIndex;	
	var init array<int> DrawNodeIndices;
};

//The visualization "tree" is actually a directed acyclic graph since actions are permitted to have multiple parents, but from a conceptual stand point
//the resulting structure is typically tree-like.
var protectedwrite X2Action VisualizationTree;			//The current tree of X2Actions - active or pending
var X2Action BuildVisTree;								//Globally accessible reference to a sub tree being constructed by visualization code. If non-null visualization is being built.
var private array<X2Action> ConnectedActionsToStart;	//Actions connected during a merge operation that need to be immediately started by CheckStartBuildTree

//Debug visualization of tree
var array<TreeDrawNode> DrawNodes;
var array<SubtreeDrawNode> Subtrees;

var int DebugTreeOffsetX;
var int DebugTreeOffsetY;
var bool bHideEmptyInterruptMarkers;

var private int BlocksAddedHistoryIndex;                                //This index keeps track of which frames from History have been added to the system already
var private int StartStateHistoryIndex;									//Caches off the start state index for the current session being visualized
var public	int LastStateHistoryVisualized;								//Caches off the latest visualization block we've visualized
var private native Set_Mirror CompletedFrames{TSet<INT>};				//Tracks which history frames have finished visualizing
var private native Set_Mirror ActiveFrames{ TSet<INT> };				//Tracks which history frames are currently processing

var private array<int> SkipVisualizationList;							//History indices in this list will have their visualization block pushed empty instead of normally processing
var private bool bEnabled;                                              //Determines whether this manager can process new state frames. Defaults to false, set to true by the bootstrapping process when entering a game.
var private bool BuildingLatentGameState;                               //Flag set by the ruleset when building a threaded game state. Prevents new history frames from being visualized until it's complete.
var private bool bWaitingOnVisualizationFence;							//TRUE if the last call to TryAddPendingBlocks hit a visualization fence
var private float TimeWithNoExecutingActions;							//Tracks the length of time where the vis tree is in a state where no actions are executing at a regular rate. If this gets
																		//too large, the vis tree is considered to be in a bad state and tries to automatically recover.

var private array<X2VisualizationMgrObserverInterfaceNative> NativeObservers; //List of observer objects that are listening for events triggered by visualization
var private array<X2VisualizationMgrObserverInterface>       Observers; //List of observer objects that are listening for events triggered by visualization

//Slo mo factors are directly controlled by the VisualizationMgr in response to interruption nodes encountered while executing nodes on the visualization tree.
var privatewrite init array<InterruptionStackElement> InterruptionStack; //A stack of visualizers that are performing interruptions. The last element in this array is the
																		 //'top' of the stack. The visualizers at the top of the interruption stack have their slo-mo factor
																		 //set to 1.0 while all other visualizers are slowed by various degrees based on their situation.

var bool SingleBlockMode; //If this flag is true, ActiveVisualizationBlocks will only be allowed to have one element. This will force visualization of the game states to 
						  //run one at a time.

const TREENODE_WIDTH = 150;
const TREENODE_HEIGHT = 25;
const TREENODE_DETAILHEIGHT = 40;
const TREENODE_SEP_X = 10;
const TREENODE_SEP_Y = 20;

var X2VisualizerHelpers VisualizerHelpers;

cpptext
{
	/// <summary>
	/// Adds the specified value to CompletedBlocks and encapsulates any related logic
	/// </summary>
	void AddEntryToCompletedBlocks(int BlockCompletedHistoryIndex);
}

/// <summary>
/// Validates that there are no leftover visualization managers, and destroys any it finds
/// </summary>
native function CleanupDuplicateManagers();
native function CleanupAccelerator();

/// <summary>
/// Handles initialization for this actor
/// </summary>
event PostBeginPlay()
{
	VisualizerHelpers = new class'X2VisualizerHelpers';
	SubscribeToOnCleanupWorld();

	CleanupDuplicateManagers();
}

function Cleanup()
{
	VisualizerHelpers = none; //Clear out the visualizer helpers
	DestroySubtree(VisualizationTree, true);
	VisualizationTree = none;

	CleanupAccelerator();
}

event Destroyed()
{
	Cleanup();
}

simulated event OnCleanupWorld()
{
	Cleanup();
}

native function OnAnimNotify(AnimNotify Notify, XGUnitNativeBase Unit);

/// <summary>
/// Called following the load of a saved game. Fills out the completed blocks set and performs other load specific startup logic.
/// </summary>
native function OnJumpForwardInHistory();

/// <summary>
/// Creates an action sequence for delta between HistoryFrame(FrameIndex) and HistoryFrame(FrameIndex - 1). By default, builds a visualization for the last frame.
/// </summary>
/// <param name="FrameIndex">The index of the history frame for which we want to build a visualization</param>
simulated function BuildVisualizationFrame(int FrameIndex, out array<X2Action> NewlyAddedActions, optional bool bReplaySkip = false)
{
	local XComGameStateHistory History;
	local XComGameState VisualizeFrame;
	local XComGameStateContext_TacticalGameRule ReplaySkipContext;
	local XComGameStateContext ProcessContext;
	local int NumGameStates;	

	History = `XCOMHISTORY;
	NumGameStates = History.GetNumGameStates();

	if( NumGameStates > 0 )
	{		
		if( NumGameStates == 1 || FrameIndex == 0 )
		{			
			VisualizeFrame = History.GetGameStateFromHistory(0, eReturnType_Reference);
		}
		else
		{
			FrameIndex = FrameIndex == -1 ? (NumGameStates - 1) : FrameIndex;
			//If this is a replay skip, then get a full game state
			VisualizeFrame = History.GetGameStateFromHistory(FrameIndex, bReplaySkip ? eReturnType_Copy : eReturnType_Reference, !bReplaySkip); 
		}

		if(VisualizeFrame != none)
		{
			// don't add visualization blocks for archives. there's nothing there to visualize, everything is from the start state on.
			if (XComGameStateContext_ArchiveHistory( VisualizeFrame.GetContext() ) != none)
			{
				return;
			}

			//Update our cached start state index
			if(VisualizeFrame.GetContext().IsStartState())
			{
				StartStateHistoryIndex = FrameIndex;
			}

			//If we are doing a replay skip, build a fake context and use that
			if( bReplaySkip )
			{
				ReplaySkipContext = XComGameStateContext_TacticalGameRule(class'XComGameStateContext_TacticalGameRule'.static.CreateXComGameStateContext());
				ReplaySkipContext.GameRuleType = eGameRule_ReplaySync;

				ProcessContext = ReplaySkipContext;
				ProcessContext.VisualizerReplaySyncSetState(VisualizeFrame);
				ProcessContext.ContextBuildVisualizationFrame();
			}
			else
			{
				if (SkipVisualizationList.Find(FrameIndex) < 0)
				{
					ProcessContext = VisualizeFrame.GetContext();
					ProcessContext.ContextBuildVisualizationFrame();
				}
				else
				{
					SkipVisualizationList.RemoveItem(FrameIndex);
				}
			}
		
			//Attach the visualization tree produced from the context build to the main visualization tree			
			if (ProcessContext != none)
			{
				if (BuildVisTree != none)
				{
					ProcessContext.MergeIntoVisualizationTree(BuildVisTree, VisualizationTree);

					NewlyAddedActions.AddItem(BuildVisTree);
					CheckStartBuildTree();
										
					BuildVisTree = none;					
				}
				else
				{
					ProcessNoVisualization(VisualizeFrame);
				}
			}
		}
	}
}

//Checks whether the newly merged build tree needs to be manually started. This will be necessary if it has 
//been parented to a portion of the global tree that has already been executed.
function CheckStartBuildTree()
{
	local int Index;
	local bool bNeedsStart;

	if (BuildVisTree != none)
	{
		bNeedsStart = true;
		for (Index = 0; Index < BuildVisTree.ParentActions.Length; ++Index)
		{
			if (!BuildVisTree.ParentActions[Index].bCompleted)
			{
				bNeedsStart = false;
				break;
			}
		}

		if (bNeedsStart)
		{
			ConnectedActionsToStart.AddItem(BuildVisTree);
		}
	}

	for (Index = 0; Index < ConnectedActionsToStart.Length; ++Index)
	{
		if (ConnectedActionsToStart[Index] != none)
		{
			ConnectedActionsToStart[Index].Init();
			ConnectedActionsToStart[Index].GotoState('Executing');
		}
	}
	ConnectedActionsToStart.Length = 0;
}

simulated function EnableBuildVisualization(bool bEnable = true)
{
	bEnabled = bEnable;
}

//Use to halt processing, for example - while a map is shutting down
simulated function DisableForShutdown()
{
	bEnabled = false;
	SetTickIsDisabled(true);
}


simulated function SetCurrentHistoryFrame(int SetIndex)
{
	BlocksAddedHistoryIndex = SetIndex;
}

simulated function int GetCurrenHistoryFrame()
{
	return BlocksAddedHistoryIndex;
}

simulated function bool CanEvaluateNewGameStates()
{
	return bEnabled && !`XCOMGAME.GameRuleset.BuildingLatentGameState && !InReplay() && !`ONLINEEVENTMGR.bInitiateValidationAfterLoad;
}

simulated function EvaluateVisualizationState()
{
	local int NumHistoryFrames;
	local int LastHistoryFrameIndex;
	local int Index;
	local array<X2Action> NewActions;

	if(!CanEvaluateNewGameStates())
	{
		return;
	}

	NumHistoryFrames = `XCOMHISTORY.GetNumGameStates();
	LastHistoryFrameIndex = NumHistoryFrames - 1;
	if (LastHistoryFrameIndex > BlocksAddedHistoryIndex)
	{
		for (Index = BlocksAddedHistoryIndex + 1; Index < NumHistoryFrames; ++Index)
		{
			BuildVisualizationFrame(Index, NewActions);
		}

		`log("Processed history frames:" @ (BlocksAddedHistoryIndex + 1) @ " to " @ LastHistoryFrameIndex, , 'XCom_Visualization');

		BlocksAddedHistoryIndex = LastHistoryFrameIndex;	

		// Before handling control over the visualizer, reset all the collision that may have been changed by the state submission
		if (`XWORLD != none)
			`XWORLD.RestoreFrameDestructionCollision();

		if (VisualizationTree != none && VisualizationTree.IsInState('WaitingToStart'))
		{
			VisualizationTree.Init();
			VisualizationTree.GotoState('Executing');
		}
	}
}

/// <summary>
/// Adds <HistoryFrame> to the ProcessedFrames set.
/// </summary>
simulated native function ProcessNoVisualization(XComGameState HistoryFrame);

/// <summary>
/// Connects the specified action <ActionToPlace> into the visualization tree specified by <UseTree>. If <Parent> or <AdditionalParents> are specified they are 
/// used to place the node. The specified parents must belong to the tree specified by <UseTree>. 
///
/// <NOTE>
/// <If NO parents> are specified, a heuristic is used to place the action based on various factors such as visualizer actor, object ID, history frame, and others. 
/// This functionality is temporary, designed to ease porting previous visualization manager code to the new system.
/// </summary>
simulated native function ConnectAction(X2Action ActionToConnect, out X2Action UseTree, bool ReparentChildren = false, optional X2Action Parent, optional array<X2Action> AdditionalParents);

/// <summary>
/// Removes <ActionToDisconnect> from all parents. <ActionToDisconnect> will have its <TreeRoot> setting cleared.
/// </summary>
simulated native function DisconnectAction(X2Action ActionToDisconnect);

/// <summary>
/// Inserts <NewNode> where <OldNode> is and then remove <OldNode>
/// </summary>
simulated native function ReplaceNode(X2Action NewNode, X2Action OldNode);

/// <summary>
/// Inserts a sub tree between <InsertionTreeNode> and its children. Where the sub tree is defined by <SubTreeRootNode> and <SubTreeEndNode> which will be connected to
/// <InsertionTreeNode> and its children, respectively.
/// </summary>
simulated native function InsertSubtree(X2Action SubTreeRootNode, X2Action SubTreeEndNode, X2Action InsertionTreeNode);

/// <summary>
/// Calls <DestroyAction> on all nodes below <TreeRoot>. If <bDestroyTreeRoot> is set to <TRUE>, destroys <TreeRoot> as well. Use to prune the visualization tree.
/// </summary>
simulated native function DestroySubtree(X2Action TreeRoot, bool bDestroyTreeRoot);

/// <summary>
/// Removes <ActionToRemove> from any trees it is a part of. Destroys the <ActionToRemove> actor. <bWorldDestroy> should be true if GWorld->DestroyActor should be called. Should be TRUE in almost all circumstances
/// </summary>
simulated native function DestroyAction(X2Action ActionToRemove, bool bWorldDestroy = true);

/// <summary>
/// Walks VisualizationTree and returns TRUE if all it's actions are complete, FALSE if not
/// </summary>
simulated native function bool AllVisualizationTreeActionsCompleted(float fDeltaTime);

/// <summary>
/// This method will return the node that would be selected by the automatic tree placement functionality ( ie. if <PlaceVisualizationActionIntoTree> were used with parents unspecified )
/// </summary>
simulated native function X2Action GetBestFitNode(X2Action ActionToPlace, X2Action UseTree);

/// <summary>
/// Retrieves a list of <LeafNodes> within the tree specified by <TreeRoot>. The nodes are ordered breadth first.
/// </summary>
simulated native function GetAllLeafNodes(X2Action TreeRoot, out array<X2Action> LeafNodes);

/// <summary>
/// Retrieves a list of <Nodes> of the given <SearchType> within the tree specified by <TreeRoot>. If <Visualizer> is specified, only nodes that are associated
/// with <Visualizer> will be returned.
/// </summary>
simulated native function GetNodesOfType(X2Action TreeRoot, class<X2Action> SearchType, out array<X2Action> Nodes, optional const Actor Visualizer, optional int StateObjectID, optional bool bSortByHistoryIndex);

/// <summary>
/// Retrieves a node of the given <SearchType> within the tree specified by <TreeRoot>. Use in situations where you are confident that there is only one of the given 
/// type of node. Example: death action for a unit. If <Visualizer> is specified, only nodes that are associated with <Visualizer> will be returned. If more than one 
/// node is found only the first will be returned and a red screen posted.
/// </summary>
simulated native function X2Action GetNodeOfType(X2Action TreeRoot, class<X2Action> SearchType, optional const Actor Visualizer, optional int StateObjectID);

/// <summary>
/// Adds and removes elements from the interruption stack, which defines customized slo mo factors for visualizers participating in an interrupt sequence
/// </summary>
simulated native function PushInterruptionStackElement(XComGameStateContext InterruptContext);
simulated native function PopInterruptionStackElement();

/// <summary>
/// This should be called by X2Actions where the action demands a character's animation run at a certain rate. For example, characters taking a shot need to run at full speed.
/// Will have no effect if <InterruptionStack> is empty, otherwise adds / sets the specified data into the topmost interruption stack element
/// </summary>
simulated native function SetInterruptionSloMoFactor(Actor Visualizer, float SlomoFactor);

/// <summary>
/// Returns <TRUE> if there is one or more actions of type <RunningActionClass> executing on <Visualizer>. <OutActions> will contain the relevant actions, if specified.
/// </summary>
simulated native function bool IsRunningAction(const Actor Visualizer, class RunningActionClass, optional out array<X2Action> OutActions);

simulated native function X2Action GetCurrentActionForVisualizer(const Actor Visualizer);
simulated native function X2Action GetCurrentActionForState(const out StateObjectReference Receiver, optional int HistoryIndex = -1);

/// <summary>
/// Returns true if the specified actor belongs to any active visualization blocks. If IncludePending
/// is set to true, will also check pending (not yet active) blocks.
/// </summary>
native function bool IsActorBeingVisualized(Actor Visualizer, optional bool IncludePending = true);

/// <summary>
/// Instructs the visualization mgr to insert and empty frame for the specified game state index
/// </summary>
simulated function SkipVisualization(int HistoryIndex)
{
	SkipVisualizationList.AddItem(HistoryIndex);
}

/// <summary>
/// Ask the visualization mgr to if this history index is in the skip visualization list
/// </summary>
simulated function bool ShouldSkipVisualization(int HistoryIndex)
{
	return SkipVisualizationList.Find(HistoryIndex) != INDEX_NONE;
}

/// <summary>
/// This is a special use method that will add a given active visualization block to the completed set, which will allow pending visualization blocks to start
/// running simultaneously with it. Use for special sequencing requirements such as multiple simultaneous overwatch shots
/// </summary>
native function ManualPermitNextVisualizationBlockToRun(int HistoryIndex);

/// <summary>
/// Adds the specified observer object to the list of observers to notify when visualization events occur
/// </summary>
simulated function RegisterObserver(object NewObserver)
{
	if( X2VisualizationMgrObserverInterfaceNative(NewObserver) != none )
	{
		if(NativeObservers.Find(NewObserver) == INDEX_NONE)
		{
			NativeObservers.AddItem( X2VisualizationMgrObserverInterfaceNative(NewObserver) );
		}
	}
	else if( X2VisualizationMgrObserverInterface(NewObserver) != none )
	{
		if(Observers.Find(NewObserver) == INDEX_NONE)
		{
			Observers.AddItem( X2VisualizationMgrObserverInterface(NewObserver) );
		}
	}
	else
	{
		`log("XComGameStateVisualizationMgr.RegisterObserver called with invalid observer:"@ NewObserver);
		ScriptTrace();
	}
}

/// <summary>
/// Removes the specified observer object from the list of observers to notify when visualization events occur
/// </summary>
simulated function RemoveObserver(object RemoveObserver)
{
	if( X2VisualizationMgrObserverInterfaceNative(RemoveObserver) != none )
	{
		NativeObservers.RemoveItem( X2VisualizationMgrObserverInterfaceNative(RemoveObserver) );
	}
	else if( X2VisualizationMgrObserverInterface(RemoveObserver) != none )
	{
		Observers.RemoveItem( X2VisualizationMgrObserverInterface(RemoveObserver) );
	}
	else
	{
		`log("XComGameStateVisualizationMgr.RemoveObserver called with invalid observer:"@ RemoveObserver);		
		ScriptTrace();
	}
}

/// <summary>
/// Used by actions to notify this manager that they have started. Internally, the manager will update the ActiveFrames set if necessary and emit the OnVisualizationBlockStarted
/// event if a frame has just started being visualized
/// </summary>
native function OnActionInited(X2Action Action);

/// <summary>
/// Used by actions to notify this manager that they have completed
/// </summary>
native function OnActionCompleted(X2Action Action);

private event OnVisualizationBlockStarted(XComGameState AssociatedGameState)
{
	`XEVENTMGR.OnVisualizationBlockStarted(AssociatedGameState);
}

private event OnVisualizationBlockComplete(XComGameState AssociatedGameState)
{
	local int Index;

	// Notify observers that this block is done processing.
	// Iterate backwards in case an observer removes itself from the list in response
	// to the event
	for(Index = Observers.Length - 1; Index >= 0; --Index)
	{
		Observers[Index].OnVisualizationBlockComplete(AssociatedGameState);
	}

	for(Index = NativeObservers.Length - 1; Index >= 0; --Index)
	{
		NativeObservers[Index].OnVisualizationBlockComplete(AssociatedGameState);
	}

	/*
	`log("Marking Visualization Block Complete - History Frame"@AssociatedGameState.HistoryIndex);
	`log("*********************************************************************************");
	`log(AssociatedGameState.GetContext().SummaryString());
	`log("*********************************************************************************");
	*/

	`XEVENTMGR.OnVisualizationBlockCompleted(AssociatedGameState);
}

function NotifyActiveUnitChanged(XComGameState_Unit NewActiveUnit)
{
	local int Index;

	HandleNewUnitSelection();

	// Notify observers that the active unit has changed
	// Iterate backwards in case an observer removes itself from the list in response
	// to the event
	for(Index = Observers.Length - 1; Index >= 0; --Index)
	{
		Observers[Index].OnActiveUnitChanged(NewActiveUnit);
	}

	for(Index = NativeObservers.Length - 1; Index >= 0; --Index)
	{
		NativeObservers[Index].OnActiveUnitChanged(NewActiveUnit);
	}
}

simulated function DrawDebugLabel(Canvas kCanvas)
{	
	local XComCheatManager LocalCheatManager;
	local TreeDrawNode TreeNode;
	local int Index;	
	local int StartX;
	local int StartY;	
	
	LocalCheatManager = XComCheatManager(GetALocalPlayerController().CheatManager);

	if( LocalCheatManager.bDebugVisualizers && VisualizationTree != none)
	{
		StartX = 80 + DebugTreeOffsetX;
		StartY = 80 + DebugTreeOffsetY;

		DrawNodes.Length = 0;
		SubTrees.Length = 0;

		//Add all nodes to a breadth first list
		FillDrawNodes(VisualizationTree, bHideEmptyInterruptMarkers);
		
		//Draw the tree.
		for (Index = 0; Index < DrawNodes.Length; ++Index)
		{
			TreeNode = DrawNodes[Index];						
			DrawNodeBodies(StartX + TreeNode.Location.X, StartY + TreeNode.Location.Y, TreeNode, kCanvas);			
		}

		for (Index = 0; Index < DrawNodes.Length; ++Index)
		{
			TreeNode = DrawNodes[Index];
			DrawNodeLinks(StartX + TreeNode.Location.X, StartY + TreeNode.Location.Y, TreeNode, kCanvas);
		}
	}
}

//Populates the DrawNodes array. If bRemoveEmptyInterruptMarkers is TRUE, interrupt markers that did not get filled with visualization will be omitted.
native function FillDrawNodes(X2Action Tree, bool bRemoveEmptyInterruptMarkers);

function DrawNodeBodies(int PositionX, int PositionY, out TreeDrawNode Node, Canvas kCanvas)
{
	local int BoxWidth;
	local int BoxHeight;
	local string ActionName;

	kCanvas.SetPos(PositionX, PositionY);

	DrawNodes[Node.NodeIndex].Location.X = PositionX;
	DrawNodes[Node.NodeIndex].Location.Y = PositionY;

	if (Node.TreeNode.IsTimedOut())
	{
		kCanvas.SetDrawColor(255, 0, 0);
	}
	else if (Node.TreeNode.IsInState('WaitingToStart'))
	{
		kCanvas.SetDrawColor(155, 155, 155);
	}
	else if (Node.TreeNode.IsInState('Executing'))
	{
		kCanvas.SetDrawColor(0, 255, 0);
	}
	else if (Node.TreeNode.IsInState('Finished'))
	{
		kCanvas.SetDrawColor(0, 155, 0);
	}
	
	BoxWidth = TREENODE_WIDTH;
	BoxHeight = `CHEATMGR.bDebugVisualizersDetail ? TREENODE_DETAILHEIGHT : TREENODE_HEIGHT;
	kCanvas.DrawRect(BoxWidth, BoxHeight);

	kCanvas.SetPos(PositionX, PositionY);
	kCanvas.SetDrawColor(255, 255, 255);

	ActionName = Node.TreeNode.SummaryString() $ "\n(" $ Node.TreeNode.Metadata.VisualizeActor $ ")\n" $ Node.TreeNode.StateChangeContext.SummaryString();
	ActionName = Repl(ActionName, "X2Action_", "");
	if (Node.TreeNode.IsTimedOut())
	{
		ActionName @= "TIMED OUT!";
	}
	kCanvas.DrawText(ActionName);
}

function DrawNodeLinks(int PositionX, int PositionY, out TreeDrawNode Node, Canvas kCanvas)
{
	local int Index;
	local int EventIndex;
	local TreeDrawNode ParentNode;
	local Color Inactive;
	local Color Active;
	local int BoxWidth;
	local int BoxHeight;	

	Inactive.R = 155;
	Inactive.G = 155;
	Inactive.B = 155;

	Active.R = 0;
	Active.G = 255;
	Active.B = 0;

	BoxWidth = TREENODE_WIDTH;
	BoxHeight = `CHEATMGR.bDebugVisualizersDetail ? TREENODE_DETAILHEIGHT : TREENODE_HEIGHT;

	//Draw links to parents - with color coding to denote event signals
	for (Index = 0; Index < Node.ParentNodeIndices.Length; ++Index)
	{
		//The parent node index may be -1 for interrupt marker nodes that were omitted from drawing
		if (Node.ParentNodeIndices[Index] > -1)
		{
			ParentNode = DrawNodes[Node.ParentNodeIndices[Index]];

			//See if we have received an event from this parent
			EventIndex = Node.TreeNode.ReceivedEvents.Find('Parent', ParentNode.TreeNode);
			if (EventIndex == INDEX_NONE)
			{
				kCanvas.Draw2DLine(DrawNodes[Node.NodeIndex].Location.X + (BoxWidth / 2), DrawNodes[Node.NodeIndex].Location.Y,
					ParentNode.Location.X + (BoxWidth / 2), ParentNode.Location.Y + (BoxHeight),
					Inactive);
			}
			else
			{
				kCanvas.Draw2DLine(DrawNodes[Node.NodeIndex].Location.X + (BoxWidth / 2), DrawNodes[Node.NodeIndex].Location.Y,
					ParentNode.Location.X + (BoxWidth / 2), ParentNode.Location.Y + (BoxHeight),
					Active);
			}
		}
	}
}

function DebugClearHangs()
{
	local X2Action Action;

	foreach AllActors(class'X2Action', Action)
	{
		if (Action.IsTimedOut())
		{
			Action.ForceComplete();
		}
	}
}

static simulated function bool VisualizerIdleAndUpToDateWithHistory()
{
	return !VisualizerBusy() && (`XCOMVISUALIZATIONMGR.GetCurrenHistoryFrame() == (`XCOMHISTORY.GetNumGameStates() - 1));
}

/// <summary>
/// Returns true if the visualizer is currently in the process of showing the last game state change
/// </summary>
static simulated function bool VisualizerBusy()
{
	return `XCOMVISUALIZATIONMGR.IsInState('ExecutingVisualization') || `XCOMGAME.GameRuleset.BuildingLatentGameState;
}

/// <summary>
/// Returns true if the visualizer is currently in the process of showing the last game state change
/// </summary>
simulated native function bool VisualizerBlockingAbilityActivation(optional bool bDebugWhy);

/// <summary>
/// Attempt to release control of any cameras used by current or pending visualization blocks
/// </summary>
simulated native function HandleNewUnitSelection();

//This state is active if there are NO visualization blocks in the ActiveVisualizationBlocks or PendingVisualizationBlocks
auto state Idle
{
	simulated function NotifyIdle()
	{
		local int Index;

		// Notify observers that this block is done processing.
		// Iterate backwards in case an observer removes itself from the list in response
		// to the event
		for(Index = Observers.Length - 1; Index >= 0; --Index)
		{
			Observers[Index].OnVisualizationIdle();
		}

		for(Index = NativeObservers.Length - 1; Index >= 0; --Index)
		{
			NativeObservers[Index].OnVisualizationIdle();
		}
	}

	simulated event BeginState(name PreviousStateName)
	{
		`log(self@"entered state: "@ GetStateName(), ,'XCom_Visualization');

		NotifyIdle();
	}

	simulated event Tick( float fDeltaT )
	{	
		//If we are not performing a replay, see if there are new history frames to visualize
		if (bEnabled && !InReplay() && !`ONLINEEVENTMGR.bInitiateValidationAfterLoad)
		{
			EvaluateVisualizationState();
		}

		if (VisualizationTree != none)
		{
			GotoState('ExecutingVisualization');
		}
	}
Begin:
}

function BeginNextTrackAction(VisualizationActionMetadata Track, X2Action CompletedAction)
{
}

simulated function bool InReplay()
{
	return XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI) != None && XComTacticalGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ReplayMgr.bInReplay;
}

//This state is active if there are visualization blocks in the ActiveVisualizationBlocks or PendingVisualizationBlocks
state ExecutingVisualization
{
	simulated event BeginState(name PreviousStateName)
	{
		`log(self@"entered state: "@ GetStateName(), , 'XCom_Visualization');
		VisualizationTree.Init();
		VisualizationTree.GotoState('Executing');
	}

	simulated event Tick( float fDeltaT )
	{
		local X2TacticalGameRuleset TacticalRules;
				
		//Process new visualization frames if it is the players's turn, and we meet the standard criteria from the Idle state. The player has ability activation blocking logic applied
		//that the AI does not - so by default the AI cannot submit while the executing state is happening.
		TacticalRules = `TACTICALRULES;
		if (bEnabled && !InReplay() && !`ONLINEEVENTMGR.bInitiateValidationAfterLoad &&
			(TacticalRules != None && !TacticalRules.UnitActionPlayerIsAI()))
		{
			EvaluateVisualizationState();
		}

		if(AllVisualizationTreeActionsCompleted(fDeltaT))
		{
			//Clean up the actions when we are done with them, and clear the tree reference
			DestroySubtree(VisualizationTree, true);
			VisualizationTree = none;
			DebugTreeOffsetX = 0;
			DebugTreeOffsetY = 0;

			GotoState('Idle');
		}
	}
}

public function GetTrackActions(int BlockIndex)
{
	
}
/*
//Find pending visualization blocks that have the TrackActor performing the specified ability.
public function GetVisModInfoForTrackActor(const Name AbilityName, const Actor TrackActor, out array<VisualizationActionMetadataModInfo> InfoArray)
{
	local int Index;
	local int TrackIndex;
	local XComGameState GameState;
	local XComGameStateContext_Ability AbilityContext;
	local VisualizationActionMetadataModInfo NewInfo;

	for (Index = 0; Index < PendingVisualizationBlocks.Length; ++Index)
	{
		for (TrackIndex = 0; TrackIndex < PendingVisualizationBlocks[Index].Tracks.Length; ++TrackIndex)
		{
			if (PendingVisualizationBlocks[Index].Tracks[TrackIndex].AbilityName == AbilityName &&
				PendingVisualizationBlocks[Index].Tracks[TrackIndex].VisualizeActor == TrackActor)
			{
				GameState = `XCOMHISTORY.GetGameStateFromHistory(PendingVisualizationBlocks[Index].HistoryIndex);
				if (GameState != none)
				{
					AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
					if (AbilityContext != none)
					{
						NewInfo.Context = AbilityContext;
						NewInfo.BlockIndex = Index;
						NewInfo.TrackIndex = TrackIndex;
						InfoArray.AddItem(NewInfo);
						break;
					}
				}
			}
		}
	}
}
*/
public function RemovePendingTrackAction(int BlockIndex, int TrackIndex, int ActionIndex)
{
	
}

public function bool VisualizationBlockExistForHistoryIndex(int HistoryIndex)
{
	return false;
}


DefaultProperties
{	
	bEnabled = false;
	bHideEmptyInterruptMarkers = true;
	LastStateHistoryVisualized = -1;
}