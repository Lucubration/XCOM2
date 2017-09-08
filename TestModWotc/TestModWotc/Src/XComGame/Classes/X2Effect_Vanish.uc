class X2Effect_Vanish extends X2Effect_PersistentStatChange
	config(GameCore);

var name ReasonNotVisible;
var name VanishRevealAdditiveAnimName;
var name VanishRevealAnimName;
var name VanishSyncAnimName;

var config int COLLISION_MIN_TILE_DISTANCE;
var config int COLLISION_MAX_TILE_DISTANCE;
var config array<name> VANISH_EXCLUDE_EFFECTS;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	//Effects that change visibility must actively indicate it
	kNewTargetState.bRequiresVisibilityUpdate = true;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local X2Action_ForceUnitVisiblity ForceVisiblityAction;

	super.AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, EffectApplyResult);

	ForceVisiblityAction = X2Action_ForceUnitVisiblity(class'X2Action_ForceUnitVisiblity'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
	ForceVisiblityAction.ForcedVisible = eForceNotVisible;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit Unit;
	local XComWorldData World;
	local array<Actor> TileActors;
	local vector NewLoc;
	local XGUnit UnitVisualizer;
	local TTile NewTileLocation;

	World = `XWORLD;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	//Effects that change visibility must actively indicate it
	Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	Unit.bRequiresVisibilityUpdate = true;

	//dslonneger - CL 275875 - [TTP 531] Chosen Assassin -Move the unit if the user happens to move on top of her
	//BEGIN
	TileActors = World.GetActorsOnTile(Unit.TileLocation);
	if( (TileActors.Length > 1) )
	{
		// Move the tile location
		UnitVisualizer = XGUnit(Unit.GetVisualizer());
		if( !UnitVisualizer.m_kBehavior.PickRandomCoverLocation(NewLoc, default.COLLISION_MIN_TILE_DISTANCE, default.COLLISION_MAX_TILE_DISTANCE) )
		{
			NewLoc = World.FindClosestValidLocation(UnitVisualizer.Location, false, false, true);
		}

		NewTileLocation = World.GetTileCoordinatesFromPosition(NewLoc); 
		Unit.SetVisibilityLocation(NewTileLocation);
	}
	//END
}

protected function OnAddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameStateContext_Ability Context;
	local X2Action_ForceUnitVisiblity ForceVisiblityAction;
	local X2Action_PlayAdditiveAnim PlayAdditiveAnim;
	local X2Action_PlayAnimation PlayAnim;
	local XComGameState_Unit TestUnit;

	TestUnit = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if( !(TestUnit.bRemovedFromPlay) )
	{
		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

		super.AddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, RemovedEffect);

		ForceVisiblityAction = X2Action_ForceUnitVisiblity(class'X2Action_ForceUnitVisiblity'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
		ForceVisiblityAction.ForcedVisible = eForceVisible;
		ForceVisiblityAction.bMatchToGameStateLoc = true;

		if( (VanishRevealAnimName == '') && (VanishRevealAdditiveAnimName != '') )
		{
			PlayAdditiveAnim = X2Action_PlayAdditiveAnim(class'X2Action_PlayAdditiveAnim'.static.AddToVisualizationTree(BuildTrack, Context));
			PlayAdditiveAnim.AdditiveAnimParams.AnimName = VanishRevealAdditiveAnimName;
		}
		else
		{
			PlayAnim = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
			PlayAnim.Params.AnimName = VanishRevealAnimName;
		}
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	OnAddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, RemovedEffect);
}

simulated function VanishSyncVisualizationFn(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlayAnimation AnimationAction;

	if (VanishSyncAnimName != '')
	{
		AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		AnimationAction.Params.AnimName = VanishSyncAnimName;
		AnimationAction.Params.BlendTime = 0.0f;
		AnimationAction.Params.Additive = true;
	}

	AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
}

function ModifyGameplayVisibilityForTarget(out GameRulesCache_VisibilityInfo InOutVisibilityInfo, XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit)
{
	if( SourceUnit.IsEnemyUnit(TargetUnit) )
	{
		InOutVisibilityInfo.bVisibleGameplay = false;
		InOutVisibilityInfo.GameplayVisibleTags.AddItem(ReasonNotVisible);
	}
}

function EGameplayBlocking ModifyGameplayPathBlockingForTarget(const XComGameState_Unit UnitState, const XComGameState_Unit TargetUnit)
{
	// This unit blocks the target unit if they are on the same team (not an enemy) or the target unit is a civilian
	if( !UnitState.IsEnemyUnit(TargetUnit) || TargetUnit.IsCivilian() )
	{
		return eGameplayBlocking_Blocks;
	}
	else
	{
		return eGameplayBlocking_DoesNotBlock;
	}
}

function EGameplayBlocking ModifyGameplayDestinationBlockingForTarget(const XComGameState_Unit UnitState, const XComGameState_Unit TargetUnit) 
{
	return ModifyGameplayPathBlockingForTarget(UnitState, TargetUnit);
}

function bool HideUIUnitFlag() { return true; }
function bool AreMovesVisible() { return false; }

static function X2Condition_UnitEffects VanishShooterEffectsCondition()
{
	local X2Condition_UnitEffects Condition;
	local int i;

	Condition = new class'X2Condition_UnitEffects';
	for( i = 0; i < default.VANISH_EXCLUDE_EFFECTS.Length; ++i )
	{
		Condition.AddExcludeEffect(default.VANISH_EXCLUDE_EFFECTS[i], default.VANISH_EXCLUDE_EFFECTS[i]);
	}

	return Condition;
}

defaultproperties
{
	EffectRank=1 // This rank is set for blocking
	EffectName="Vanish"
	ReasonNotVisible="Vanish"
	bBringRemoveVisualizationForward=true
	EffectSyncVisualizationFn=VanishSyncVisualizationFn
}