class X2Action_MindControlled extends X2Action;

var XGUnit          ControlledUnit;
var XComUnitPawn    ControlledPawn;
var name            MindControlledAnim;
var CustomAnimParams            Params;
var bool bForceAllowNewAnimations;

function Init()
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;

	super.Init();

	History = `XCOMHISTORY;
	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	ControlledUnit = XGUnit(UnitState.GetVisualizer());
	ControlledPawn = ControlledUnit.GetPawn();
}

function ResetUnitFlag(int ObjectID)
{
	local StateObjectReference kRef;
	kRef.ObjectID = ObjectID;
	`PRES.ResetUnitFlag(kRef);
}

simulated state Executing
{
Begin:
	if(!ControlledUnit.IsTurret())
	{
		while(ControlledUnit.IdleStateMachine.IsEvaluatingStance())
		{
			Sleep(0.0f);
		}
		Params.AnimName = MindControlledAnim;

		if(bForceAllowNewAnimations)
		{
			ControlledPawn.GetAnimTreeController().SetAllowNewAnimations(true);
		}
		
		FinishAnim(ControlledPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));
	}

	ResetUnitFlag(ControlledUnit.ObjectID);
	CompleteAction();
}

DefaultProperties
{
	InputEventIDs.Add("Visualizer_ProjectileHit")
	MindControlledAnim="HL_Psi_MindControlled"
}