//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor.
//-----------------------------------------------------------
class X2Action_AbilityPerkDurationEnd extends X2Action
	dependson(XComAnimNodeBlendDynamic);

var private XGUnit TrackUnit;

var private XGUnit CasterUnit;
var private XGUnit TargetUnit;
var private XComUnitPawnNativeBase CasterPawn;
var private XComPerkContentInst EndingPerk;

var private CustomAnimParams AnimParams;
var private int x, i;

var XComGameState_Effect EndingEffectState;

function Init()
{
	local X2Effect EndingEffect;
	local name EndingEffectName;
	//local array<XComPerkContentInst> Perks;
	local bool bIsCasterTarget;

	super.Init();

	TrackUnit = XGUnit( Metadata.VisualizeActor );

	EndingEffect = class'X2Effect'.static.GetX2Effect( EndingEffectState.ApplyEffectParameters.EffectRef );
	if (X2Effect_Persistent(EndingEffect) != none)
	{
		EndingEffectName = X2Effect_Persistent(EndingEffect).EffectName;
	}
	`assert( EndingEffectName != '' ); // what case isn't being handled?

	CasterUnit = XGUnit( `XCOMHISTORY.GetVisualizer( EndingEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID ) );
	if (CasterUnit == none)
		CasterUnit = TrackUnit;

	CasterPawn = CasterUnit.GetPawn( );

	TargetUnit = XGUnit( `XCOMHISTORY.GetVisualizer( EndingEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID ) );

	EndingPerk = class'XComPerkContent'.static.GetAssociatedDurationPerkInstance( CasterPawn, EndingEffectState );
	if ((EndingPerk != none) && (EndingPerk.m_PerkData.TargetDurationFXOnly || EndingPerk.m_PerkData.CasterDurationFXOnly))
	{
		bIsCasterTarget = (TargetUnit == CasterUnit);
		`assert((!bIsCasterTarget && EndingPerk.m_PerkData.TargetDurationFXOnly) ||
				(bIsCasterTarget && EndingPerk.m_PerkData.CasterDurationFXOnly));
	}
}

event bool BlocksAbilityActivation()
{
	return false;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	simulated event BeginState(Name PreviousStateName)
	{
		if (EndingPerk != none)
		{
			if ((TargetUnit != None) && (TargetUnit != CasterUnit))
			{
				EndingPerk.RemovePerkTarget( TargetUnit );
			}
			else
			{
				EndingPerk.OnPerkDurationEnd( );
			}
		}
	}

Begin:

	if (EndingPerk != none)
	{
		AnimParams.AnimName = class'XComPerkContent'.static.ChooseAnimationForCover( CasterUnit, EndingPerk.m_PerkData.CasterDurationEndedAnim );
		AnimParams.PlayRate = GetNonCriticalAnimationSpeed();

		if ((EndingPerk.m_ActiveTargetCount == 0) && EndingPerk.m_PerkData.CasterDurationEndedAnim.PlayAnimation && AnimParams.AnimName != '')
		{
			if( EndingPerk.m_PerkData.CasterDurationEndedAnim.AdditiveAnim )
			{
				FinishAnim(CasterPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(AnimParams));
				CasterPawn.GetAnimTreeController().RemoveAdditiveDynamicAnim(AnimParams);
			}
			else
			{
				FinishAnim(CasterPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));
			}
		}

		if (EndingPerk.m_PerkData.TargetDurationEndedAnim.PlayAnimation)
		{
			AnimParams.AnimName = class'XComPerkContent'.static.ChooseAnimationForCover( TargetUnit, EndingPerk.m_PerkData.TargetDurationEndedAnim );
			if (AnimParams.AnimName != '')
			{
				if( EndingPerk.m_PerkData.CasterDurationEndedAnim.AdditiveAnim )
				{
					FinishAnim(TargetUnit.GetPawn().GetAnimTreeController().PlayAdditiveDynamicAnim(AnimParams));
					TargetUnit.GetPawn().GetAnimTreeController().RemoveAdditiveDynamicAnim(AnimParams);
				}
				else
				{
					FinishAnim(TargetUnit.GetPawn().GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));
				}
			}
		}
	}

	CompleteAction();
}

