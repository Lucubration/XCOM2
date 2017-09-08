//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Fire_SpectralArmy extends X2Action_Fire;

var private bool bAllNotifiesReceived;
var private int NumNotifies;
var private array<XComGameState_Unit> SpectralUnits;
var private AnimNodeSequence LoopAnimSequence;
var private bool bIsPullRight;

function Init()
{
	local X2Effect_SpawnSpectralArmy SpawnSpectralArmyEffect;

	super.Init();

	SetCustomTimeOutSeconds(30.0f);

	// First target effect is X2Effect_SpawnSpectralArmy
	SpawnSpectralArmyEffect = X2Effect_SpawnSpectralArmy(AbilityContext.ResultContext.TargetEffectResults.Effects[0]);

	if( SpawnSpectralArmyEffect == none )
	{
		`RedScreenOnce("X2Action_Fire_SpectralArmy: Missing X2Effect_SpawnSpectralArmy -dslonneger @gameplay");
		return;
	}

	SpawnSpectralArmyEffect.FindNewlySpawnedUnit(VisualizeGameState, SpectralUnits);

	bAllNotifiesReceived = false;
	NumNotifies = 0;
}

function NotifyTargetsAbilityApplied()
{
	`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', SpectralUnits[NumNotifies++], self);

	if (NumNotifies >= SpectralUnits.Length)
	{
		bAllNotifiesReceived = true;
	}
}

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
Begin:
	// Play the Start anim
	AnimParams = default.AnimParams;
	AnimParams.AnimName = 'HL_SpectralArmy_Start';

	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	bIsPullRight = true;
	//CurrentLoopAnimName = 'HL_SpectralArmy_PullRight';
	while( !bAllNotifiesReceived )
	{
		AnimParams = default.AnimParams;
		AnimParams.AnimName = bIsPullRight ? 'HL_SpectralArmy_PullRight' : 'HL_SpectralArmy_PullLeft';
		AnimParams.BlendTime = 0.0f;

		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

		bIsPullRight = !bIsPullRight;
	}

	CompleteAction();
}

defaultproperties
{
}
