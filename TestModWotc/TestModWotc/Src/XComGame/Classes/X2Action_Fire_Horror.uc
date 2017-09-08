//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Fire_Horror extends X2Action_Fire;

//Cached info for the unit performing the action
//*************************************
var private CustomAnimParams Params;
var bool ProjectileHit;
var XComUnitPawn FocusUnitPawn;
//*************************************

function bool CheckInterrupted()
{
	return VisualizationBlockContext.InterruptionStatus == eInterruptionStatus_Interrupt;
}

function NotifyTargetsAbilityApplied()
{
	super.NotifyTargetsAbilityApplied();
	ProjectileHit = true;
}

simulated state Executing
{
	function StartTargetFaceSource()
	{
		local Vector FaceVector;
		
		FocusUnitPawn = XGUnit(PrimaryTarget).GetPawn();

		FaceVector = UnitPawn.Location - FocusUnitPawn.Location;
		FaceVector = Normal(FaceVector);

		FocusUnitPawn.m_kGameUnit.IdleStateMachine.ForceHeading(FaceVector);
	}

Begin:
	//Make the target face source
	StartTargetFaceSource();
	Sleep(0.1f);

	//Wait for our turn to complete so that we are facing mostly the right direction when the target's RMA animation starts
	while(FocusUnitPawn.m_kGameUnit.IdleStateMachine.IsEvaluatingStance())
	{
		Sleep(0.01f);
	}

	Unit.CurrentFireAction = self;

	if( AbilityContext.IsHitResultHit(AbilityContext.ResultContext.HitResult) )
	{
		Params.AnimName = 'HL_Horror_Start';
		UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

		while( !ProjectileHit )
		{
			Sleep(0.01f);
		}

		Params.AnimName = 'HL_Horror_Stop';
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));

		FocusUnitPawn.m_kGameUnit.IdleStateMachine.CheckForStanceUpdateOnIdle();
	}
	else
	{
		Params.AnimName = 'HL_Horror';
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));
	}

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}