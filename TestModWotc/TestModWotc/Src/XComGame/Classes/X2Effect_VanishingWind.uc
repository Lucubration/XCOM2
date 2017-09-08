class X2Effect_VanishingWind extends X2Effect_Vanish
	config(GameCore);

var config int PARTINGSILKREVEAL_MIN_TILE_DISTANCE;

var name MovingVanishRevealAdditiveAnimName;

protected function OnAddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameStateContext_Ability Context;
	local XComGameStateVisualizationMgr VisualizationMgr;
	local X2Action_ExitCover ExitCoverAction;
	local X2Action_MoveDirect MoveDirectAction;
	local X2Action_ForceUnitVisiblity ShowUnitAction;
	local X2Action_PlayAdditiveAnim PlayAdditiveAnim;
	local name AdditiveAnimName;
	local X2Action_HideUIUnitFlag HideUIFlagAction;
	local array<X2Action> FoundNodes;
	local X2Action BuildTreeStartNode, FireAction;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	if (Context.InputContext.AbilityTemplateName == 'PartingSilk')
	{
		VisualizationMgr = `XCOMVISUALIZATIONMGR;

		BuildTreeStartNode = VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MarkerTreeInsertBegin');
		HideUIFlagAction = X2Action_HideUIUnitFlag(class'X2Action_HideUIUnitFlag'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), true, BuildTreeStartNode));
		HideUIFlagAction.bHideUIUnitFlag = true;

		if (Context.InputContext.MovementPaths.Length > 0 
			&& Context.InputContext.MovementPaths[0].MovementTiles.Length > default.PARTINGSILKREVEAL_MIN_TILE_DISTANCE)
		{
			// We have enough distance to do the reveal effect while she is moving
			AdditiveAnimName = MovingVanishRevealAdditiveAnimName;

			VisualizationMgr.GetNodesOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveDirect', FoundNodes, BuildTrack.VisualizeActor);
			MoveDirectAction = X2Action_MoveDirect(FoundNodes[0]);

			ShowUnitAction = X2Action_ForceUnitVisiblity(class'X2Action_ForceUnitVisiblity'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, none, MoveDirectAction.ParentActions));
		}
		else
		{
			AdditiveAnimName = VanishRevealAdditiveAnimName;

			ExitCoverAction = X2Action_ExitCover(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_ExitCover'));
			ShowUnitAction = X2Action_ForceUnitVisiblity(class'X2Action_ForceUnitVisiblity'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), true, none, ExitCoverAction.ParentActions));
		}

		ShowUnitAction.ForcedVisible = eForceVisible;

		PlayAdditiveAnim = X2Action_PlayAdditiveAnim(class'X2Action_PlayAdditiveAnim'.static.AddToVisualizationTree(BuildTrack, Context, true, ShowUnitAction));
		PlayAdditiveAnim.AdditiveAnimParams.AnimName = AdditiveAnimName;


		FireAction = VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_Fire');
		HideUIFlagAction = X2Action_HideUIUnitFlag(class'X2Action_HideUIUnitFlag'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, FireAction));
		HideUIFlagAction.bHideUIUnitFlag = false;
	}
	else
	{
		super.OnAddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, RemovedEffect);
	}
}

defaultproperties
{
	EffectRank=1 // This rank is set for blocking
	EffectName="VanishingWind"
	ReasonNotVisible="VanishingWind"
	bBringRemoveVisualizationForward=true
	VanishRevealAdditiveAnimName="ADD_HL_VanishingWindBase_Unhide"
	MovingVanishRevealAdditiveAnimName="ADD_MV_VanishingWindBase_Unhide"
}