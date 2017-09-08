//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_PlayAnimation extends X2Action
	dependson(XComAnimTreeController);

var public  BlendMaskIndex		BlendType;
var public  float				BlendOutTime;
var public	bool				bBlendOut;
var	public	CustomAnimParams	Params;
var public  bool                bFinishAnimationWait;
var private AnimNodeSequence    PlayingSequence;
var public  bool                bResetWeaponsToDefaultSockets; //If set, ResetWeaponsToDefaultSockets will be called on the unit before the animation is played.
var protected bool				bSkipAnimation; //If set, the animation will not be played and the node will immediately complete
var bool 						bOffsetRMA;

function bool CheckInterrupted()
{
	return false;
}

simulated state Executing
{
Begin:
	if (!bSkipAnimation)
	{
		UnitPawn.EnableRMA(true, true);
		UnitPawn.EnableRMAInteractPhysics(true);

		if( bOffsetRMA )
		{
			Params.DesiredEndingAtoms.Add(1);
			Params.DesiredEndingAtoms[0].Translation = UnitPawn.Location;
			Params.DesiredEndingAtoms[0].Translation.Z = UnitPawn.GetDesiredZForLocation(UnitPawn.Location);
			Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(UnitPawn.Rotation);
			Params.DesiredEndingAtoms[0].Scale = 1.0f;

			UnitPawn.SetLocation(UnitPawn.GetAnimTreeController().GetStartingAtomFromDesiredEndingAtom(Params).Translation);
		}

		//For this action, we always want to play at regular speed. Interruption is limited to movement and exit cover for firing off abilities
		VisualizationMgr.SetInterruptionSloMoFactor(Unit, 1.0f);

		if (UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) || Params.HasPoseOverride == true)
		{
			//The current use-case for this is when a unit becomes stunned; they may get stunned by a counter-attack while they have a secondary weapon out, for example.
			if (bResetWeaponsToDefaultSockets)
				Unit.ResetWeaponsToDefaultSockets();

			if (Params.Additive)
			{
				UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(Params);
			}
			else
			{
				PlayingSequence = UnitPawn.GetAnimTreeController().PlayDynamicAnim(Params, BlendType);

				if (bFinishAnimationWait)
				{
					FinishAnim(PlayingSequence);

					if (bBlendOut)
					{
						UnitPawn.GetAnimTreeController().BlendOutDynamicNode(BlendOutTime, BlendType);
					}
				}
			}
		}
		else
		{
			`RedScreen("Failed to play animation" @ Params.AnimName @ "on" @ UnitPawn @ "as part of" @ self);
		}
	}

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return false;
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{
	if( XComAnimNotify_NotifyTarget(ReceiveNotify) != None )
	{
		`XEVENTMGR.TriggerEvent('Visualizer_AbilityHit', self, self);
	}
}

DefaultProperties
{
	OutputEventIDs.Add( "Visualizer_AbilityHit" )
	InputEventIDs.Add( "Visualizer_AbilityHit" )
	bFinishAnimationWait=true
	bResetWeaponsToDefaultSockets=false
}
