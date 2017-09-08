class X2Effect_ModifyInitiativeOrder extends X2Effect;

var bool bRemoveGroupFromInitiativeOrder;
var bool bAddGroupToInitiativeOrder;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local XComGameState_AIGroup AIGroupState;
	local X2TacticalGameRuleset Rules;

	Rules = `TACTICALRULES;
	TargetUnitState = XComGameState_Unit(kNewTargetState);
	AIGroupState = TargetUnitState.GetGroupMembership();
	AIGroupState = XComGameState_AIGroup(NewGameState.ModifyStateObject(class'XComGameState_AIGroup', AIGroupState.ObjectID));

	if (bRemoveGroupFromInitiativeOrder)
	{
		Rules.RemoveGroupFromInitiativeOrder(AIGroupState, NewGameState);
	}
	else if (bAddGroupToInitiativeOrder)
	{
		Rules.AddGroupToInitiativeOrder(AIGroupState, NewGameState);
	}
}