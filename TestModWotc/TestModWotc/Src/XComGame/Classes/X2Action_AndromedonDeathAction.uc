//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_AndromedonDeathAction extends X2Action_PlayAnimation;

var private StateObjectReference SpawnedRobotUnitReference;
var private TTile CurrentTile;
var private bool bReceivedMeshSwapNotify;

static function bool AllowOverrideActionDeath(VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	local XComGameState_Unit AndromedonUnit;
	local XComGameStateHistory History;
	local int i;
	local XComGameStateContext TestContext;
	local XComGameStateContext_Ability TestAbilityContext;
	local bool bFoundAssociatedSwitch;

	AndromedonUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	// Check to see if the switch occurs if the unit is currently alive,
	// otherwise use this override death action
	if( (AndromedonUnit != none) )
	{
		History = `XCOMHISTORY;

		// Search through the chain to find when the Andromedon's SwitchToRobot ability occurs
		i = Context.EventChainStartIndex;
		TestContext = Context;
		bFoundAssociatedSwitch = false;
		while( !bFoundAssociatedSwitch && (!TestContext.bLastEventInChain) )
		{
			TestContext = History.GetGameStateFromHistory(i).GetContext();

			TestAbilityContext = XComGameStateContext_Ability(TestContext);

			if( TestAbilityContext != none &&
				TestAbilityContext.DesiredVisualizationBlockIndex == Context.AssociatedState.HistoryIndex &&
				TestAbilityContext.InputContext.AbilityTemplateName == 'SwitchToRobot' &&
				TestAbilityContext.InputContext.SourceObject.ObjectID == AndromedonUnit.ObjectID )
			{
				// We found a SwitchToRobot that wants to visualize in this context, so do the switch
				bFoundAssociatedSwitch = true;
			}

			++i;
		}

		return bFoundAssociatedSwitch;
	}

	return false;
}

function Init()
{
	local XComGameState_Unit AndromedonUnit, SpawnedRobotUnit;
	local UnitValue SpawnedUnitValue;
	local XComGameStateHistory History;
	local int i;
	local XComGameStateContext Context;
	local XComGameStateContext_Ability TestAbilityContext;

	super.Init();

	Params.AnimName = 'HL_RobotBattleSuitStart';
	History = `XCOMHISTORY;

	// Search through the chain to find when the Andromedon's SwitchToRobot ability occurs
	i = StateChangeContext.EventChainStartIndex;
	Context = StateChangeContext;
	while( (AndromedonUnit == none) && (!Context.bLastEventInChain))
	{
		Context = History.GetGameStateFromHistory(i).GetContext();

		TestAbilityContext = XComGameStateContext_Ability(Context);

		if( TestAbilityContext!= none &&
			TestAbilityContext.InputContext.AbilityTemplateName == 'SwitchToRobot' &&
			TestAbilityContext.InputContext.SourceObject.ObjectID == UnitPawn.ObjectID )
		{
			// Get the up to date version of this unit so we can find the associated spawned robot
			AndromedonUnit = XComGameState_Unit(TestAbilityContext.AssociatedState.GetGameStateForObjectID(UnitPawn.ObjectID));
			AndromedonUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);
		}

		++i;
	}

	if( AndromedonUnit == none )
	{
		`RedScreenOnce("X2Action_AndromedonDeathAction: Andromedon not found, should have come from SwitchToRobot GameState -dslonneger @gameplay");
	}

	SpawnedRobotUnit = XComGameState_Unit(History.GetGameStateForObjectID(SpawnedUnitValue.fValue));
	if( SpawnedRobotUnit == none )
	{
		`RedScreenOnce("X2Action_AndromedonDeathAction: AndromedonRobot not found, Andromedon needs to have the reference -dslonneger @gameplay");
	}

	SpawnedRobotUnitReference = SpawnedRobotUnit.GetReference();
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{
	local XComAnimNotify_NotifyTarget NotifyTarget;

	NotifyTarget = XComAnimNotify_NotifyTarget(ReceiveNotify);
	if(NotifyTarget != none)
	{
		bReceivedMeshSwapNotify = true;
	}
}

simulated state Executing
{
Begin:
	StopAllPreviousRunningActions(Unit);

	//Just minimal setup. The Andromedon robot spawn will take care of most of our visualization for this
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;
	UnitPawn.bPlayedDeath = true;

	CompleteAction();
}

defaultproperties
{
	bReceivedMeshSwapNotify=false
}