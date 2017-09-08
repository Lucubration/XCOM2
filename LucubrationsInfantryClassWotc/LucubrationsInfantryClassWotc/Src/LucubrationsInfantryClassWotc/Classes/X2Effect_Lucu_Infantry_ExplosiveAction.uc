class X2Effect_Lucu_Infantry_ExplosiveAction extends X2Effect;
	
var int BonusActionPoints;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local int i;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		// Apply bonus action points
		for (i = 0; i < BonusActionPoints; ++i)
		{
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
		}

		//`LOG("Lucubration Infantry Class: Explosive Action granted " @ string(BonusActionPoints) @ " action points to unit " @ UnitState.GetFullName() @ ".");
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}