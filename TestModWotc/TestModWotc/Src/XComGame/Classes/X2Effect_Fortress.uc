class X2Effect_Fortress extends X2Effect_Persistent
	dependson(XComPerkContent)
	config(GameData_SoldierSkills);

var config array<name> DamageImmunities;

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return DamageImmunities.Find(DamageType) != INDEX_NONE;
}

function OnUnitChangedTile(const out TTile NewTileLocation, XComGameState_Effect EffectState, XComGameState_Unit TargetUnit)
{
	local XComWorldData WorldData;
	local XComGameStateHistory History;
	local bool bHazard;
	local XGUnit SourceUnit;
	local XComUnitPawnNativeBase SourcePawn;
	local array<XComPerkContentInst> Perks;
	local int i;
	local PerkActivationData ActivationData;

	WorldData = `XWORLD;
	History = `XCOMHISTORY;
	//  assumes DamageImmunities includes Fire, Acid, and Poison
	bHazard = WorldData.TileContainsAcid(NewTileLocation) || WorldData.TileContainsFire(NewTileLocation) || WorldData.TileContainsPoison(NewTileLocation);

	SourceUnit = XGUnit( History.GetVisualizer( EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID ) );
	if (SourceUnit != none)
	{
		SourcePawn = SourceUnit.GetPawn( );

		class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, SourcePawn, EffectState.ApplyEffectParameters.AbilityInputContext.AbilityTemplateName );

		for (i = 0; i < Perks.Length; ++i)
		{
			if (bHazard && Perks[ i ].IsInState('Idle'))
			{
				Perks[ i ].OnPerkActivation( ActivationData );
			}
			else if (!bHazard && Perks[ i ].IsInState('ActionActive'))
			{
				Perks[ i ].OnPerkDeactivation( );
			}
		}
	}
}

DefaultProperties
{
	EffectName="PsiFortress"
	DuplicateResponse=eDupe_Ignore
}