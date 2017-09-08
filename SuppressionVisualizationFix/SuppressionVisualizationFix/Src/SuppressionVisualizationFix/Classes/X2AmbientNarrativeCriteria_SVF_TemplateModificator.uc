class X2AmbientNarrativeCriteria_SVF_TemplateModificator extends X2AmbientNarrativeCriteria;

static function array<X2DataTemplate> CreateTemplates()
{
	// This turns out to be a good hook for doing global template modification because subclasses of X2AmbientNarrativeCriteria
	// are the last ones loaded when the game is setting up. We'll just return an empty list of templates for template creation
	// (because we're not actually using this to create any templates) and put our template modifications in-between
	local array<X2DataTemplate> Templates;
	Templates.Length = 0;

	// Update the Suppression visualization function
	UpdateSuppressionVisualizationFunction();

	return Templates;
}

static function UpdateSuppressionVisualizationFunction()
{
	local X2AbilityTemplate AbilityTemplate;
	
	// Find the Suppression ability template
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('Suppression');
	if (AbilityTemplate != none)
	{
		AbilityTemplate.BuildVisualizationFn = SuppressionBuildVisualization;

		`LOG("Suppression Visualization Fix: Updated " @ AbilityTemplate.DataName @ " template visualization function.");
	}
}

//---------------------------------------------------------------------------------------------------
// Suppression Visualization
//---------------------------------------------------------------------------------------------------


static simulated function SuppressionBuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability	Context;
	local StateObjectReference			InteractingUnitRef;

	local VisualizationTrack			EmptyTrack;
	local VisualizationTrack			BuildTrack;

	local XComGameState_Ability			Ability;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;

	local XComUnitPawn					UnitPawn;
	local XComWeapon					Weapon;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	// Check the actor's pawn and weapon, see if they can play the suppression effect
	UnitPawn = XGUnit(BuildTrack.TrackActor).GetPawn();
	Weapon = XComWeapon(UnitPawn.Weapon);
	if (Weapon != None &&
		!UnitPawn.GetAnimTreeController().CanPlayAnimation(Weapon.WeaponSuppressionFireAnimSequenceName) &&
		!UnitPawn.GetAnimTreeController().CanPlayAnimation(class'XComWeapon'.default.WeaponSuppressionFireAnimSequenceName))
	{
		// The unit can't play their weapon's suppression effect. Replace it with the normal fire effect so at least they'll look like they're shooting
		Weapon.WeaponSuppressionFireAnimSequenceName = Weapon.WeaponFireAnimSequenceName;
	}
	
	class'X2Action_ExitCover'.static.AddToVisualizationTrack(BuildTrack, Context);
	class'X2Action_StartSuppression'.static.AddToVisualizationTrack(BuildTrack, Context);
	OutVisualizationTracks.AddItem(BuildTrack);
	//****************************************************************************************
	//Configure the visualization track for the target
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
	if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
	}
	OutVisualizationTracks.AddItem(BuildTrack);
}
