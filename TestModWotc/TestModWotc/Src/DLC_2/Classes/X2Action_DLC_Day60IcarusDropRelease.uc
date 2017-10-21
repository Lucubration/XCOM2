//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_DLC_Day60IcarusDropRelease extends X2Action;

var StateObjectReference PartnerRef;

//Cached info for performing the action
//*************************************
var	protected CustomAnimParams				Params;
var protected String						AnimName;
//*************************************

event bool BlocksAbilityActivation()
{
	return true;
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
	function AnimNodeSequence PlayReleaseStartAnim(XGUnit PlayOnUnit, XComUnitPawn PlayOnPawn)
	{
		PlayOnUnit.IdleStateMachine.PersistentEffectIdleName = '';
		PlayOnPawn.GetAnimTreeController().SetAllowNewAnimations(true);

		Params = default.Params;
		Params.AnimName = 'NO_IcarusDrop_HurtDropStart';

		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

	function AnimNodeSequence PlayReleaseStopAnim(XComUnitPawn PlayOnPawn, const out vector EndLocation)
	{
		Params = default.Params;
		Params.AnimName = 'NO_IcarusDrop_HurtDropStop';
		Params.DesiredEndingAtoms.Add(1);
		Params.DesiredEndingAtoms[0].Translation = EndLocation;
		Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(PlayOnPawn.Rotation);
		Params.DesiredEndingAtoms[0].Scale = 1.0f;

		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;	

	FinishAnim(PlayReleaseStartAnim(Unit, UnitPawn));
	
	CompleteAction();
}

DefaultProperties
{
}
