class X2Effect_Lucu_Sniper_TargetLeading extends X2Effect_ToHitModifier;

var int ReactionModifier;

function ModifyReactionFireSuccess(XComGameState_Unit UnitState, XComGameState_Unit TargetState, out int Modifier)
{
	Modifier = ReactionModifier;
}
