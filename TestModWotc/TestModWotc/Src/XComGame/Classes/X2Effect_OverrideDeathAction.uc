class X2Effect_OverrideDeathAction extends X2Effect_Persistent;

var class<X2Action> DeathActionClass;

static function bool AllowOverrideActionDeath(VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	return true;
}

simulated function X2Action AddX2ActionsForVisualization_Death(out VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	local X2Action AddAction;

	if( DeathActionClass != none && DeathActionClass.static.AllowOverrideActionDeath(ActionMetadata, Context))
	{
		AddAction = class'X2Action'.static.CreateVisualizationActionClass( DeathActionClass, Context, ActionMetadata.VisualizeActor );
		class'X2Action'.static.AddActionToVisualizationTree(AddAction, ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	}

	return AddAction;
}