class X2Effect_GhostStuff extends X2Effect_Persistent;

function bool DoesEffectAllowUnitToBleedOut(XComGameState_Unit UnitState) { return false; }
function bool DoesEffectAllowUnitToBeLooted(XComGameState NewGameState, XComGameState_Unit UnitState) { return false; }