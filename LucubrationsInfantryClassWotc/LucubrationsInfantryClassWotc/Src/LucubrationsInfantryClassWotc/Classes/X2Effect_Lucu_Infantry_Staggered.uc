class X2Effect_Lucu_Infantry_Staggered extends X2Effect_PersistentStatChange;
	
function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    local int i;
    local name ActionPointType;

    ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

    //`LOG("Lucubration Infantry Class: Staggered tick started with " @ string(ActionPoints.Length) @ " action points on unit " @ UnitState.GetFullName() @ ".");

    for (i = UnitState.ActionPoints.Length - 1; i >= 0; --i)
    {
	    if (UnitState.ActionPoints[i] == ActionPointType)
	    {
		    // Remove action point
		    UnitState.ActionPoints.Remove(i, 1);

		    //`LOG("Lucubration Infantry Class: Staggered tick removed 1 " @ string(ActionPointType) @ " action point from unit " @ UnitState.GetFullName() @ ".");

		    break;
	    }
    }

    //`LOG("Lucubration Infantry Class: Staggered tick ended with " @ string(UnitState.ActionPoints.Length) @ " action points on unit " @ UnitState.GetFullName() @ ".");
}
