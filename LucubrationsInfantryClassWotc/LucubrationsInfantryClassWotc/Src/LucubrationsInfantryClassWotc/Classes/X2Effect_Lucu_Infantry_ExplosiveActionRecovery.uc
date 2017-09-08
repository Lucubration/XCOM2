class X2Effect_Lucu_Infantry_ExplosiveActionRecovery extends X2Effect_Persistent;
	
var int RecoveryActionPoints;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local int i;
	local int ActionPointsRemoved;
	local name ActionPointType;
    
	ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

	//`LOG("Lucubration Infantry Class: Explosive Action Recovery removal started with " @ string(ActionPoints.Length) @ " action points on unit " @ UnitState.GetFullName() @ ".");

	ActionPointsRemoved = 0;

	for (i = ActionPoints.Length - 1; i >= 0 && ActionPointsRemoved < RecoveryActionPoints; --i)
	{
		if (ActionPoints[i] == ActionPointType)
		{
			// Remove recovery action point
			ActionPoints.Remove(i, RecoveryActionPoints);
			ActionPointsRemoved++;

			//`LOG("Lucubration Infantry Class: Explosive Action Recovery removed " @ string(RecoveryActionPoints) @ string(ActionPointType) @ " action points from unit " @ UnitState.GetFullName() @ ".");
		}
	}

	//`LOG("Lucubration Infantry Class: Explosive Action Recovery removal ended with " @ string(UnitState.ActionPoints.Length) @ " action points on unit " @ UnitState.GetFullName() @ ".");
}
