//---------------------------------------------------------------------------------------
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameStateContext_AuraUpdate extends XComGameStateContext_EffectRemoved;

protected function ContextBuildVisualization()
{
	local XComGameState_Effect CurrentEffect;
	local X2Effect EffectToVisualize;
	local VisualizationActionMetadata Metadata;
	local XComGameState VisualizeGameState;
	local XGUnit CurrentUnit;
	local XGUnit SourceUnit;
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local VisualizationActionMetadata EmptyData;
	
	History = `XCOMHISTORY;

	super.ContextBuildVisualization();

	VisualizeGameState = AssociatedState;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', CurrentEffect)
	{
		if( RemovedEffects.Find('ObjectID', CurrentEffect.ObjectID) != INDEX_NONE )
		{
			continue;
		}
		
		EffectToVisualize = CurrentEffect.GetX2Effect();

		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(CurrentEffect.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		SourceUnit = XGUnit(History.GetVisualizer(CurrentEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

		if( AbilityState != None )
		{				
			CurrentUnit = XGUnit(History.GetVisualizer(CurrentEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

			Metadata = EmptyData;
			Metadata.VisualizeActor = CurrentUnit;
			Metadata.StateObject_OldState = History.GetGameStateForObjectID(CurrentEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
			Metadata.StateObject_NewState = Metadata.StateObject_OldState;

			// We know the apply result was success
			EffectToVisualize.AddX2ActionsForVisualization(VisualizeGameState, Metadata, 'AA_Success');
		}
	}

	if (SourceUnit != none)
	{
		Metadata = EmptyData;
		Metadata.VisualizeActor = SourceUnit;
		Metadata.StateObject_OldState = History.GetGameStateForObjectID(SourceUnit.ObjectID);
		Metadata.StateObject_NewState = Metadata.StateObject_OldState;

		class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree( Metadata, self );
		class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree( Metadata, self );
	}
}

function string SummaryString()
{
	return "XComGameStateContext_AuraUpdate";
}