//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_DLC_2ThrowAxe.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2TargetingMethod_DLC_2ThrowAxe extends X2TargetingMethod_OverTheShoulder;

var protected XComPrecomputedPath GrenadePath;
var protected transient XComEmitter ExplosionEmitter;
var protected XGWeapon WeaponVisualizer;

static function bool UseGrenadePath() { return true; }

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameState_Item WeaponItem;
	local X2WeaponTemplate WeaponTemplate;
	local X2AbilityTemplate AbilityTemplate;

	super.Init(InAction, NewTargetIndex);

	// determine our targeting range
	WeaponItem = Ability.GetSourceWeapon();
	AbilityTemplate = Ability.GetMyTemplate( );

	// show the grenade path
	WeaponTemplate = X2WeaponTemplate(WeaponItem.GetMyTemplate());
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());

	XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = true;

	GrenadePath = `PRECOMPUTEDPATH;	
	GrenadePath.SetupPath(WeaponVisualizer.GetEntity(), FiringUnit.GetTeam(), WeaponTemplate.WeaponPrecomputedPathData);
	GrenadePath.UpdateTrajectory();

	if (!AbilityTemplate.SkipRenderOfTargetingTemplate)
	{
		// setup the blast emitter
		ExplosionEmitter = `BATTLE.spawn(class'XComEmitter');
		if(AbilityIsOffensive)
		{
			ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere", class'ParticleSystem')));
		}
		else
		{
			ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere_Neutral", class'ParticleSystem')));
		}
		ExplosionEmitter.LifeSpan = 60 * 60 * 24 * 7; // never die (or at least take a week to do so)
	}
}

function Canceled()
{
	super.Canceled();

	if (ExplosionEmitter != none)
	{
		ExplosionEmitter.Destroy();
	}

	GrenadePath.ClearPathGraphics();
	XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = false;
	ClearTargetedActors();
}