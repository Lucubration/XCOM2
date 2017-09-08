//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_BeginTurnSignals extends X2Action
	config(Animation);

//Cached info for performing the action
//*************************************
var XGUnit				Target;
var private config float			AttackHimPercentage;
//*************************************

static function AddBeginTurnSignalsToBlock(XComGameStateContext_TacticalGameRule Context)
{
	local VisualizationActionMetadata ActionMetadata;
	local XGAIPlayer PlayerVisualizer;
	local XComGameState_Player PlayerGameState;
	local XComGameState_AIPlayerData kAIPlayerData;
	local int ScanGroup;
	local XComGameState_AIGroup AIGroupState;
	local XComGameStateHistory History;
	local array<int> LivingMembers;
	local XComGameState_Unit GroupLeader;
	local XGUnit GroupLeaderVisualizer;
	local GameRulesCache_VisibilityInfo OutVisibilityInfo;
	local X2Action_BeginTurnSignals Action;
	local X2Action_CameraLookAt LookAtAction;
	local array<StateObjectReference> OutFriendsSeeingTarget;
	local XComGameState_Unit ClosestTarget;
	local int ScanFriends;
	local XComGameState_Unit FriendUnit;
	local int HistoryIndexForContext;

	// skip signals in zip mode
	if( `XPROFILESETTINGS.Data.bEnableZipMode )
	{
		return;
	}

	History = `XCOMHISTORY;

	HistoryIndexForContext = Context.AssociatedState.HistoryIndex;

	PlayerGameState = XComGameState_Player(History.GetGameStateForObjectID(Context.PlayerRef.ObjectID, eReturnType_Reference, HistoryIndexForContext));
	if( PlayerGameState != None && PlayerGameState.GetTeam() == eTeam_Alien )
	{
		PlayerVisualizer = XGAIPlayer(PlayerGameState.GetVisualizer());
		if( PlayerVisualizer != None )
		{
			kAIPlayerData = XComGameState_AIPlayerData(History.GetGameStateForObjectID(PlayerVisualizer.GetAIDataID(), eReturnType_Reference, HistoryIndexForContext));
			if( kAIPlayerData != None )
			{
				for( ScanGroup = 0; ScanGroup < kAIPlayerData.GroupList.Length; ++ScanGroup )
				{
					AIGroupState = XComGameState_AIGroup(History.GetGameStateForObjectID(kAIPlayerData.GroupList[ScanGroup].ObjectID, eReturnType_Reference, HistoryIndexForContext));
					if( AIGroupState.GetLivingMembers(LivingMembers) )
					{
						GroupLeader = XComGameState_Unit(History.GetGameStateForObjectID(LivingMembers[0], eReturnType_Reference, HistoryIndexForContext));
						if( GroupLeader.GetMyTemplateName() == 'ChryssalidCocoon' || 
							GroupLeader.GetMyTemplateName() == 'ChryssalidCocoonHuman')
						{
							continue;
						}

						GroupLeaderVisualizer = XGUnit(GroupLeader.GetVisualizer());
						if( GroupLeaderVisualizer.GetAlertLevel() == eAL_Red &&  class'X2TacticalVisibilityHelpers'.static.GetClosestVisibleEnemy(GroupLeader.ObjectID, OutVisibilityInfo, HistoryIndexForContext, class'X2TacticalVisibilityHelpers'.default.GameplayVisibleFilter) )
						{
							ClosestTarget = XComGameState_Unit(History.GetGameStateForObjectID(OutVisibilityInfo.TargetID, eReturnType_Reference, HistoryIndexForContext));

							if( OutVisibilityInfo.bVisibleFromDefault )
							{
								class'X2TacticalVisibilityHelpers'.static.GetEnemyViewersOfTarget(ClosestTarget.ObjectID, OutFriendsSeeingTarget, HistoryIndexForContext, class'X2TacticalVisibilityHelpers'.default.GameplayVisibleFilter);
								for( ScanFriends = 0; ScanFriends < OutFriendsSeeingTarget.Length; ++ScanFriends )
								{
									FriendUnit = XComGameState_Unit(History.GetGameStateForObjectID(OutFriendsSeeingTarget[ScanFriends].ObjectID, eReturnType_Reference, HistoryIndexForContext));
									if( FriendUnit != None && FriendUnit.GetTeam() == GroupLeader.GetTeam() )
									{
										if( FRand() <= default.AttackHimPercentage )
										{
											ActionMetadata.StateObject_OldState = GroupLeader;
											ActionMetadata.StateObject_NewState = GroupLeader;
											ActionMetadata.VisualizeActor = GroupLeaderVisualizer;

											LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
											LookAtAction.LookAtObject = GroupLeader;
											LookAtAction.UseTether = false;
											LookAtAction.BlockUntilActorOnScreen = true;

											Action = X2Action_BeginTurnSignals(class'X2Action_BeginTurnSignals'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
											Action.Target = XGUnit(ClosestTarget.GetVisualizer());
											
											return; // Only 1 squad leader should signal
										}

										// We already did our 25% check so who cares about the rest of our friends
										break;
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	Unit.IdleStateMachine.SignalAnimationName = 'HL_SignalPoint';
	Unit.IdleStateMachine.SignalFaceLocation = Target.Location;
	Unit.IdleStateMachine.GotoState('Signal');

	while( Unit.IdleStateMachine.GetStateName() == 'Signal' )
	{
		Sleep(0.1f);
	}

	CompleteAction();
}

DefaultProperties
{
}
